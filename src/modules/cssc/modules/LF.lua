{[_init]=function(Control)
	local ct,fk = t_swap{__COMMENT__},"function"--mk hash table
	Control.Operators["->"]=function(Control)
		local s,ei,ed,cor,br=__WORD__,Control.Cdata.tb_while(ct)--get last esenshual_index,esenshual_data
		if match(Control.Result[ei],"^%)")then--breaket located
			ei=ed[2]
			Control.log("EI:%d - %s;%s;%s;",ei,Control.Result[ei],match(Control.Result[ei],"^[=%(,]"), ei and match(Control.Result[ei],"^[=%(,]"))
			cor = ei and match(Control.Result[ei-1]or"","^[=%(,]")--coma is acceptable here
			Control.log("COR:%s",cor)
		else--default args
			while ei>0 and(ed[1]==__COMMENT__ or ed[1]==s or s~=__WORD__ and match(Control.Result[ei],"^%,"))do
				ei,s=ei-1,s*(ed[1]~=__COMMENT__ and-1 or 1)--com skip/swap state __WORD__/__OPERATOR__(coma)
				ed=Control.Cdata[ei]
			end
			ei,br,cor=ei+1,__TRUE__,ei>0 and s~=__WORD__ and match(Control.Result[ei],"^[=%(]")
		end
		if not cor then Control.error("Corrupted lambda arguments at line %d !",Control.line)Control.split_seq(nil,2) return end
		
		Control.inject(fk,__KEYWORD__,ei)--inject function kwrd
		if br then --place breakets
			Control.inject("(",__OPEN_BREAKET__,ei+1)--inject open breaket
			Control.inject(")",__CLOSE_BREAKET__,nil,ei+1)--inject closeing breaket
		end
		if"-"==sub(Control.operator,1,1)then Control.inject("return ",__KEYWORD__) end--inject return kwrd
		Control.Level.open(fk,nil,ei)--open new function level (auto end set)
		Control.split_seq(nil,2)-- remove ->/=> from Control.operator
	end
	Control.Operators["=>"]=Control.Operators["->"]
end}