local skipper_tab,func_kwrd,match,sub=Cdata.skip_tb,"function",ENV(2,6)

Operators["->"]=function()
	local state_ctrl,index,l_data,is_corrupt,breaket=3,Cdata.tb_while(skipper_tab)--get last esenshual_index,esenshual_data
	if match(Result[index],"^%)")then--breaket located
		index=l_data[2]
		is_corrupt = index and match(Result[Cdata.tb_while(skipper_tab,index-1)]or"","^[=%(,]")--coma is acceptable here 
	else--breaketless args, probably will be removed in future
		while index>0 and(skipper_tab[l_data[1]] or l_data[1]==state_ctrl or state_ctrl~=3 and ((l_data[2]or-1)==Cdata.opts[","][1] and match(Result[index],"^%,")))do
			index,state_ctrl=index-1,state_ctrl*(skipper_tab[l_data[1]] and 1 or -1)--com skip/swap state 3/2(coma)
			l_data=Cdata[index]
		end
		index,breaket,is_corrupt=index+1,1,index>0 and state_ctrl~=3 and match(Result[index],"^[=%(]")
	end
	if not is_corrupt then C.error("Corrupted lambda arguments at line %d !",C.line)Text.split_seq(nil,2) return end
	
	Cssc.inject(index,func_kwrd,4)--inject function kwrd
	Cssc.inject(index," ",5)--inject space before function
	if breaket then --place breakets
		Cssc.inject(index+2,"(",9)--inject open breaket
		Cssc.inject(")",10,index+1)--inject closing breaket
	end
	if"-"==sub(C.operator,1,1)then Cssc.inject("return",4) Cssc.inject(" ",5) end--inject return kwrd

	Event.run(2,"->",2,1)--Iinform core about insertet operators (1 means cssc_generated)
	Event.run("all",sub(C.operator,1,1)..">",tp,1)

	Level.open(func_kwrd,nil,index)--open new function level (auto end set)
	Level[#Level].DA_np=nil --prevent DEF ARGS
	Text.split_seq(nil,2)-- remove ->/=> from Control.operator
end
Operators["=>"]=Operators["->"]
--return 1
