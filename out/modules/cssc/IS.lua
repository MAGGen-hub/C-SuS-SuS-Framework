local Ti,Gt,Ge,TS=ENV(7,12,14,23)local l_typeof,skipper_tab,check,after,inject_tab=C:load_libs"code.cssc""runtime""op_stack""typeof"(3),Cdata.skip_tb,TS{2,9,4},TS{4,10},{{" ",5},{"__cssc__kw_is",3}}Runtime.build("kwrd.is",function(obj,cmp)local work_mode,obj_tp,rez=Gt(cmp),l_typeof(obj),false
if work_mode=="string"then rez=obj_tp==cmp
elseif work_mode=="table"then for i=1,#cmp do rez=rez or obj_tp==cmp[i]end
else Ge("bad argument #2 to 'is' operator (got '"..work_mode.."', expected 'table' or 'string')",2)end
return rez
end)Words["is"]=function()Runtime.reg("__cssc__kw_is","kwrd.is")local id,data=Cdata.tb_while(skipper_tab)if check[data[1]]then C.Ge("Unexpected 'is' after '%s'!",Result[id])end
Cssc.inject(",",2,Cdata.opts["^"][1])Text.split_seq(nil,2,1)Event.run(2,"is",2,1)Event.run("all","is",2,1)Event.reg("all",function(obj,tp)if after[tp]or tp==2 and not Cdata[#Cdata][3]then C.Ge("Unexpected '%s' after 'is'!",obj)end
return not skipper_tab[tp]and 1
end)Cssc.op_conf(inject_tab,Cdata.opts["^"][1])end