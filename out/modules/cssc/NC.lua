local Ss,Ti,Gp,GS,TS=ENV(6,7,13,18,23)local stx,phf,tb,check=[[O
?. ?: ?( ?{ ?[ ?" ?'
]],function()end,Cdata.skip_tb,TS{7,3,10}local runtime_meta,runtime_dual_meta=GS({},{__call=function()end,__newindex=function()end}),{__index=function()return phf end}local runtime_func,runtime_dual_func=function(obj)return obj==nil and runtime_meta or obj end,function(obj)return obj==nil and runtime_dual_meta or GS({},{__index=function(self,i)return obj[i]or phf end})end
C:load_libs"code".cssc"runtime""op_stack"()"syntax_loader"(3)(stx,{O=function(...)for k,v in Gp{...}do
Operators[v]=function()local tp,i,d=Ss(v,2)i,d=Cdata.tb_while(tb)if not check[d[1]]then C.Ge("Unexpected '?' after '%s'!",Result[i])end
Event.run(2,"?x",2,1)Event.run("all","?x",2,1)if tp==":"then
Runtime.reg("__cssc__op_d_nc","nilF.dual")Cssc.op_conf({{" ",5},{"__cssc__op_d_nc",3}},Cdata.opts["."][1],false,false,true)else
Runtime.reg("__cssc__op_nc","nilF.basic")Cssc.op_conf({{" ",5},{"__cssc__op_nc",3}},Cdata.opts["."][1],false,false,true)end
Text.split_seq(nil,1)end
end
end})Runtime.build("nilF.dual",runtime_dual_func)Runtime.build("nilF.basic",runtime_func)