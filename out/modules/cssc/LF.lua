local match,sub=ENV(2,6)

local tb,fk = Control.Cdata.skip_tb,"function"--mk hash table
Control.Operators["->"]=function(Control)
	local s,ei,ed,cor,br=3,Control.Cdata.tb_while(tb)--get last esenshual_index,esenshual_data
	if match(Control.Result[ei],"^%)")then--breaket located
		ei=ed[2]
		--Control.log("EI:%d - %s;%s;%s;",ei,Control.Result[ei],match(Control.Result[ei],"^[=%(,]"), ei and match(Control.Result[ei],"^[=%(,]"))
		cor = ei and match(Control.Result[Control.Cdata.tb_while(tb,ei-1)]or"","^[=%(,]")--coma is acceptable here 
		--Control.log("COR:%s",cor)
	else--default args
		while ei>0 and(tb[ed[1]] or ed[1]==s or s~=3 and ((ed[2]or-1)==Control.Cdata.opts[","][1] and match(Control.Result[ei],"^%,")))do
			ei,s=ei-1,s*(tb[ed[1]] and-1 or 1)--com skip/swap state 3/2(coma)
			ed=Control.Cdata[ei]
		end
		ei,br,cor=ei+1,1,ei>0 and s~=3 and match(Control.Result[ei],"^[=%(]")
	end
	if not cor then Control.error("Corrupted lambda arguments at line %d !",Control.line)Control.Text.split_seq(nil,2) return end
	
	--Control.inject(ei,"" @@DEBUG .."--[[cl mrk]]"
	--,2,Control.Cdata.opts[":"][1])--call mark
	Control.inject(nil," ",5)
	Control.inject(ei,fk,4)--inject function kwrd
	if br then --place breakets
		Control.inject(ei+1,"(",9)--inject open breaket
		Control.inject(nil,")",10,ei+1)--inject closeing breaket
	end
	if"-"==sub(Control.operator,1,1)then Control.inject(nil,"return",4) Control.inject(nil," ",5) end--inject return kwrd

	Control.Event.run(2,"->",2,1)--Iinform core about insertet operators (1 means cssc_generated)
	Control.Event.run("all",sub(Control.operator,1,1)..">",tp,1)

	Control.Level.open(fk,nil,ei)--open new function level (auto end set)
	Control.Level[#Control.Level].DA_np=nil --prevent DEF ARGS
	Control.Text.split_seq(nil,2)-- remove ->/=> from Control.operator
end
Control.Operators["=>"]=Control.Operators["->"]
--return 1
