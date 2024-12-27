local tb,fk,match,sub=Cdata.skip_tb,"function",ENV(__ENV_MATCH__,__ENV_SUB__)

Operators["->"]=function()
	local s,ei,ed,cor,br=__WORD__,Cdata.tb_while(tb)--get last esenshual_index,esenshual_data
	if match(Result[ei],"^%)")then--breaket located
		ei=ed[2]
		cor = ei and match(Result[Cdata.tb_while(tb,ei-1)]or"","^[=%(,]")--coma is acceptable here 
	else--breaketless args, probably will be removed in future
		while ei>0 and(tb[ed[1]] or ed[1]==s or s~=__WORD__ and ((ed[2]or-1)==Cdata.opts[","][1] and match(Result[ei],"^%,")))do
			ei,s=ei-1,s*(tb[ed[1]] and 1 or -1)--com skip/swap state __WORD__/__OPERATOR__(coma)
			ed=Cdata[ei]
		end
		ei,br,cor=ei+1,__TRUE__,ei>0 and s~=__WORD__ and match(Result[ei],"^[=%(]")
	end
	if not cor then Control.error("Corrupted lambda arguments at line %d !",C.line)Text.split_seq(nil,2) return end
	
	Cssc.inject(ei,fk,__KEYWORD__)--inject function kwrd
	Cssc.inject(ei," ",__SPACE__)--inject space before function
	if br then --place breakets
		Cssc.inject(ei+2,"(",__OPEN_BREAKET__)--inject open breaket
		Cssc.inject(")",__CLOSE_BREAKET__,ei+1)--inject closeing breaket
	end
	if"-"==sub(C.operator,1,1)then Cssc.inject("return",__KEYWORD__) Cssc.inject(" ",__SPACE__) end--inject return kwrd

	Event.run(__OPERATOR__,"->",__OPERATOR__,__TRUE__)--Iinform core about insertet operators (__TRUE__ means cssc_generated)
	Event.run("all",sub(C.operator,1,1)..">",tp,__TRUE__)

	Level.open(fk,nil,ei)--open new function level (auto end set)
	Level[#Level].DA_np=nil --prevent DEF ARGS
	Text.split_seq(nil,2)-- remove ->/=> from Control.operator
end
Operators["=>"]=Operators["->"]
--return __TRUE__
