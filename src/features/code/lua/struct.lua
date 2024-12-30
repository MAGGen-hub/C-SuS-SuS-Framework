local match,format,gsub,sub,insert,concat,unpack=
ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_GSUB__,__ENV_SUB__,__ENV_INSERT__,__ENV_CONCAT__,__ENV_UNPACK__)

Text.get_num_prt = function(num_data,m_data) --function that collect number parts into num_data. 
	local exponenta                            --Returns 1 if end of number found or nil if floating point posible
	num_data[#num_data+1],exponenta,C.word=match(C.word,format("^(%s*([%s]?%%d*))(.*)",unpack(m_data)))--get number part
	C.operator="" -- dot-able number protection (reset operator)
	if#C.word>0 or#exponenta>1 then return 1 end--finished number or finished exponenta
	if#exponenta>0 then--unfinished exponenta #exponenta==1
		Iterator()-- update op_word_seq
		exponenta=match(C.operator or"","^[+-]$")
		if exponenta then
			num_data[#num_data+1]=exponenta
			num_data[#num_data+1],C.word=match(C.word,"^(%d*)(.*)")
			C.operator=""
		end --TODO: else push_error() end -> incorrect exponenta prohibited by lua
		return 1
	end --unfinished exponenta #exponenta==1
end

--comment/string/number detector
--local get_number_part=Control.Text.get_num_prt
local get_number,split_seq=function()--get_number:function to locate numbers with floating point;
	local mode,dot=match(C.word,"^0([Xx])")dot=C.operator=="."and not mode--dot-able number detection (t-> dot located | c->hex located)
	if not match(C.word,"^%d")or not dot and#C.operator>0 then return end --number not located... return
	local num_data,m_data=dot and{"."}or{},mode and{"0"..mode.."%x","Pp"}or{"%d","Ee"}
	if Text.get_num_prt(num_data,m_data)or"."==num_data[1]then return num_data end--fin of number or dot-able floating point number
	-- now: #exponenta==0 and #Control.word==0; all other ways are found
	--Control.word==0 -> number might have floating point
	Iterator() --update op_word_sequences
	if C.operator=="."then --floating point found
		num_data[#num_data+1]="."
		m_data[1]=sub(m_data[1],-2)
		Text.get_num_prt(num_data,m_data)
	end
	return num_data
end,Text.split_seq
--STRUCTURE MODULE
insert(Struct,function()
	local comment,rez,mode,Lvl,str_obj=#C.operator>0 and"operator"or"word"
	--STRUCTURE HANDLER
	if#C.operator>0 then --string structures
		rez,comment,Lvl={},match(C.operator,"^(-?)%1%[(=*)%[")--long strings and coments
		comment=match(C.operator,"^-%-")
		str_obj=match(C.operator,"^['\"]")--small strings/comments
		if Lvl then --LONG BUILDER
			Lvl="%]"..Lvl.."()%]"
			repeat
				if split_seq(rez,match(C.operator,Lvl))then mode=comment and __COMMENT__ or __STRING__ break end --structure finished
				insert(rez,C.word)
			until Iterator()
		elseif str_obj then --STRING BUILDER
			split_seq(rez,1)--burn first simbol of structure
			str_obj="(\\*()["..str_obj.."\n])"
			while C.index do
				comment,mode=match(C.operator,str_obj)
				if split_seq(rez,mode)then--end of string found
					mode=match(comment,"\n$")
					Lvl = Lvl or mode --line counter
					-- "ddd \
					-- abc" --still correct string because there is an "\" before "\n"
					if #comment%2>0 then mode=not mode and __STRING__ break end --end of string or \n found
				else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
					if split_seq(rez,match(C.word,"()\n"),1)then break end --unfinished string "word" mode split seq
					Iterator()
				end
			end
		elseif comment then --COMMENT BUILDER
			repeat
				if split_seq(rez,match(C.operator,"()\n"))or split_seq(rez,match(C.word,"()\n"),1)then C.line=C.line+1 break end --comment end found
			until Iterator()
			mode=__COMMENT__
		else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
			rez=get_number()
			mode=rez and __NUMBER__ --__NUMBER__
		end
	elseif#C.word>0 then --NUMBER BUILDER
		rez=get_number()
		mode=rez and __NUMBER__ --__NUMBER__
	end
	if rez then
		rez=concat(rez)
		if Lvl then
			rez,comment=gsub(rez,"\n",{})
			C.line=C.line+comment --line counter for long structures
		end
		Result[#Result+1]=rez
		Core(mode or __UNFINISHED__,rez)-- mode==nul or false -> unfinished structure PUSH_ERROR required
		return true --inform base that structure is found and structure_module_restart required before future processing
	end
end)
