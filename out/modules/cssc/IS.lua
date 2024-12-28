local Ti,Gt,Ge,TS=ENV(7,12,14,23)local ltpof=C:load_libs"code.cssc""runtime""op_stack""typeof"(3)local IS_func=function(obj,comp)local md,tp,rez=Gt(comp),ltpof(obj),false
if md=="string"then rez=tp==comp
elseif md=="table"then for i=1,#comp do rez=rez or tp==comp[i]end
else Ge("bad argument #2 to 'is' operator (got '"..md.."', expected 'table' or 'string')",2)end
return rez
end
local tab,used={{" ",5},{"__cssc__kw_is",3}}local tb=Cdata.skip_tb
local check=TS{2,9,4}local after=TS{4,10}Runtime.build("kwrd.is",IS_func)Words["is"]=function()Runtime.reg("__cssc__kw_is","kwrd.is")local i,d=Cdata.tb_while(tb)if check[d[1]]then Control.Ge("Unexpected 'is' after '%s'!",Result[i])end
Cssc.inject(",",2,Cdata.opts["^"][1])Text.split_seq(nil,2,1)Event.run(2,"is",2,1)Event.run("all","is",2,1)Event.reg("all",function(obj,tp)if after[tp]or tp==2 and not Cdata[#Cdata][3]then Control.Ge("Unexpected '%s' after 'is'!",obj)end
return not tb[tp]and 1
end)Cssc.op_conf(tab,Cdata.opts["^"][1])end