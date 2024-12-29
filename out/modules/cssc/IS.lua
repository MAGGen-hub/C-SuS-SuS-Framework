local Ti,Gt,Ge,TS=ENV(7,12,14,23)local T,S,c,a,I=C:load_libs"code.cssc""runtime""op_stack""typeof"(3),Cd.skip_tb,TS{2,9,4},TS{4,10},{{" ",5},{"__cssc__kw_is",3}}Runtime.build("kwrd.is",function(obj,cmp)local w,t,r=Gt(cmp),T(obj),false
if w=="string"then r=t==cmp
elseif w=="table"then for i=1,#cmp do r=r or t==cmp[i]end
else Ge("bad argument #2 to 'is' operator (got '"..w.."', expected 'table' or 'string')",2)end
return r
end)Words["is"]=function()Runtime.reg("__cssc__kw_is","kwrd.is")local i,d=Cd.tb_while(S)if c[d[1]]then C.error("Unexpected 'is' a '%s'!",Result[i])end
Cssc.inject(",",2,Cd.opts["^"][1])Text.split_seq(nil,2,1)Event.run(2,"is",2,1)Event.run("all","is",2,1)Event.reg("all",function(obj,tp)if a[tp]or tp==2 and not Cd[#Cd][3]then C.error("Unexpected '%s' a 'is'!",obj)end
return not S[tp]and 1
end)Cssc.op_conf(I,Cd.opts["^"][1])end