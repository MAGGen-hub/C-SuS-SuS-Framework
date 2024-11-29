local match,format,gsub,sub,insert,concat,unpack=
ENV(2,3,5,6,7,8,10)
--comment/string/number detector
local get_number_part=Control.get_num_prt
local get_number,split_seq=function()--get_number:function to locate numbers with floating point;
	local c,d=match(Control.word,"^0([Xx])")d=Control.operator=="."and not c--dot-able number detection (t-> dot located | c->hex located)
	if not match(Control.word,"^%d")or not d and#Control.operator>0 then return end --number not located... return
	local num_data,f=d and{"."}or{},c and{"0"..c.."%x","Pp"}or{"%d","Ee"}
	if get_number_part(num_data,f)or"."==num_data[1]then return num_data end--fin of number or dot-able floating point number
	-- now: #ex==0 and #Control.word==0; all other ways are found
	--Control.word==0 -> number might have floating point
	Control.Iterator() --update op_word_sequences
	if Control.operator=="."then --floating point found
		num_data[#num_data+1]="."
		f[1]=sub(f[1],-2)
		get_number_part(num_data,f)
	end
	return num_data
end,Control.split_seq
--STRUCTURE MODULE
insert(Control.Struct,function()
	local com,rez,mode,lvl,str=#Control.operator>0 and"operator"or"word"
	--STRUCTURE HANDLER
	if#Control.operator>0 then --string structures
		rez,com,lvl={},match(Control.operator,"^(-?)%1%[(=*)%[")--long strings and coments
		com=match(Control.operator,"^-%-")
		str=match(Control.operator,"^['\"]")--small strings/comments
		if lvl then --LONG BUILDER
			lvl="%]"..lvl.."()%]"
			repeat
				if split_seq(rez,match(Control.operator,lvl))then mode=com and 11 or 7 break end --structure finished
				insert(rez,Control.word)
			until Control.Iterator()
		elseif str then --STRING BUILDER
			split_seq(rez,1)--burn first simbol of structure
			str="(\\*()["..str.."\n])"
			while Control.index do
				com,mode=match(Control.operator,str)
				if split_seq(rez,mode)then--end of string found
					mode=match(com,"\n$")
					lvl = lvl or mode --line counter
					-- "ddd \
					-- abc" --still correct string because there is an "\" before "\n"
					if #com%2>0 then mode=not mode and 7 break end --end of string or \n found
				else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
					if split_seq(rez,match(Control.word,"()\n"),1)then break end --unfinished string "word" mode split seq
					Control.Iterator()
				end
			end
		elseif com then --COMMENT BUILDER
			repeat
				if split_seq(rez,match(Control.operator,"()\n"))or split_seq(rez,match(Control.word,"()\n"),1)then Control.line=Control.line+1 break end --comment end found
			until Control.Iterator()
			mode=11
		else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
			rez=get_number()
			mode=rez and 6 --6
		end
	elseif#Control.word>0 then --NUMBER BUILDER
		rez=get_number()
		mode=rez and 6 --6
	end
	if rez then
		rez=concat(rez)
		if lvl then
			rez,com=gsub(rez,"\n",{})
			Control.line=Control.line+com --line counter for long structures
		end
		Control.Result[#Control.Result+1]=rez
		Control.Core(mode or 12,rez)-- mode==nul or false -> unfinished structure PUSH_ERROR required
		return true --inform base that structure is found and structure_module_restart required before future processing
	end
end)
