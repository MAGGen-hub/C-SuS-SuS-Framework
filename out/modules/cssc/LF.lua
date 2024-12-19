local tb,fk,match,sub=Cdata.skip_tb,"function",ENV(2,6)

Operators["->"]=function()
	local s,ei,ed,cor,br=3,Cdata.tb_while(tb)--get last esenshual_index,esenshual_data
	if match(Result[ei],"^%)")then--breaket located
		ei=ed[2]
		cor = ei and match(Result[Cdata.tb_while(tb,ei-1)]or"","^[=%(,]")--coma is acceptable here 
	else--breaketless args, probably will be removed in future
		while ei>0 and(tb[ed[1]] or ed[1]==s or s~=3 and ((ed[2]or-1)==Cdata.opts[","][1] and match(Result[ei],"^%,")))do
			ei,s=ei-1,s*(tb[ed[1]] and-1 or 1)--com skip/swap state 3/2(coma)
			ed=Cdata[ei]
		end
		ei,br,cor=ei+1,1,ei>0 and s~=3 and match(Result[ei],"^[=%(]")
	end
	if not cor then Control.error("Corrupted lambda arguments at line %d !",C.line)Text.split_seq(nil,2) return end
	
	Control.inject(nil," ",5)
	Control.inject(ei,fk,4)--inject function kwrd
	if br then --place breakets
		Control.inject(ei+1,"(",9)--inject open breaket
		Control.inject(nil,")",10,ei+1)--inject closeing breaket
	end
	if"-"==sub(C.operator,1,1)then Control.inject(nil,"return",4) Control.inject(nil," ",5) end--inject return kwrd

	Event.run(2,"->",2,1)--Iinform core about insertet operators (1 means cssc_generated)
	Event.run("all",sub(C.operator,1,1)..">",tp,1)

	Level.open(fk,nil,ei)--open new function level (auto end set)
	Level[#Level].DA_np=nil --prevent DEF ARGS
	Text.split_seq(nil,2)-- remove ->/=> from Control.operator
end
Operators["=>"]=Operators["->"]
--return 1
