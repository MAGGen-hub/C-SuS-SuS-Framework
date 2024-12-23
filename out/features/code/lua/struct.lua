local match,format,gsub,sub,insert,concat,unpack=
ENV(2,3,5,6,7,8,10)

Text.get_num_prt = function(nd,f) --function that collect number parts into num_data. 
	local ex                            --Returns 1 if end of number found or nil if floating point posible
	nd[#nd+1],ex,C.word=match(C.word,format("^(%s*([%s]?%%d*))(.*)",unpack(f)))--get number part
	C.operator="" -- dot-able number protection (reset operator)
	if#C.word>0 or#ex>1 then return 1 end--finished number or finished exponenta
	if#ex>0 then--unfinished exponenta #ex==1
		Iterator()-- update op_word_seq
		ex=match(C.operator or"","^[+-]$")
		if ex then
			nd[#nd+1]=ex
			nd[#nd+1],C.word=match(C.word,"^(%d*)(.*)")
			C.operator=""
		end --TODO: else push_error() end -> incorrect exponenta prohibited by lua
		return 1
	end --unfinished exponenta #ex==1
end

--comment/string/number detector
--local get_number_part=Control.Text.get_num_prt
local get_number,split_seq=function()--get_number:function to locate numbers with floating point;
	local c,d=match(C.word,"^0([Xx])")d=C.operator=="."and not c--dot-able number detection (t-> dot located | c->hex located)
	if not match(C.word,"^%d")or not d and#C.operator>0 then return end --number not located... return
	local num_data,f=d and{"."}or{},c and{"0"..c.."%x","Pp"}or{"%d","Ee"}
	if Text.get_num_prt(num_data,f)or"."==num_data[1]then return num_data end--fin of number or dot-able floating point number
	-- now: #ex==0 and #Control.word==0; all other ways are found
	--Control.word==0 -> number might have floating point
	Iterator() --update op_word_sequences
	if C.operator=="."then --floating point found
		num_data[#num_data+1]="."
		f[1]=sub(f[1],-2)
		Text.get_num_prt(num_data,f)
	end
	return num_data
end,Text.split_seq
--STRUCTURE MODULE
insert(Struct,function()
	local com,rez,mode,lvl,str=#C.operator>0 and"operator"or"word"
	--STRUCTURE HANDLER
	if#C.operator>0 then --string structures
		rez,com,lvl={},match(C.operator,"^(-?)%1%[(=*)%[")--long strings and coments
		com=match(C.operator,"^-%-")
		str=match(C.operator,"^['\"]")--small strings/comments
		if lvl then --LONG BUILDER
			lvl="%]"..lvl.."()%]"
			repeat
				if split_seq(rez,match(C.operator,lvl))then mode=com and 11 or 7 break end --structure finished
				insert(rez,C.word)
			until Iterator()
		elseif str then --STRING BUILDER
			split_seq(rez,1)--burn first simbol of structure
			str="(\\*()["..str.."\n])"
			while C.index do
				com,mode=match(C.operator,str)
				if split_seq(rez,mode)then--end of string found
					mode=match(com,"\n$")
					lvl = lvl or mode --line counter
					-- "ddd \
					-- abc" --still correct string because there is an "\" before "\n"
					if #com%2>0 then mode=not mode and 7 break end --end of string or \n found
				else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
					if split_seq(rez,match(C.word,"()\n"),1)then break end --unfinished string "word" mode split seq
					Iterator()
				end
			end
		elseif com then --COMMENT BUILDER
			repeat
				if split_seq(rez,match(C.operator,"()\n"))or split_seq(rez,match(C.word,"()\n"),1)then C.line=C.line+1 break end --comment end found
			until Iterator()
			mode=11
		else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
			rez=get_number()
			mode=rez and 6 --6
		end
	elseif#C.word>0 then --NUMBER BUILDER
		rez=get_number()
		mode=rez and 6 --6
	end
	if rez then
		rez=concat(rez)
		if lvl then
			rez,com=gsub(rez,"\n",{})
			C.line=C.line+com --line counter for long structures
		end
		Result[#Result+1]=rez
		Core(mode or 12,rez)-- mode==nul or false -> unfinished structure PUSH_ERROR required
		return true --inform base that structure is found and structure_module_restart required before future processing
	end
end)
