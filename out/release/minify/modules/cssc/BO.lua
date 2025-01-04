local O,Sg,Sm,SF,Ti,floor,Gt,Gp,Ge,GG,GP,Gl,bit32,TS=Cdata.opts,ENV(5,2,3,7,27,12,13,14,17,19,20,21,23)floor=floor.floor
local e,F,f,D=function(i)return function(a,b)Ge("attempt to perform ariphmetic on a "..(Gt(a)~="number"and Gt(a)or Gt(b)).." value",i)end end,'local p,t,f,g,e={},...return function(a,b)return(',')(a,b)end'local r,s,P,p,S,B,c,l,x=e(2),[[O
|
~
&
<< >>
//
]],O["<"][1]+1,O["#"][2],Cdata.skip_tb,TS{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},TS{2,9,4},"__cssc__bit_",Gl(F..[["number"==t(a)and"number"==t(b))and f(a/b)or((g(a)or p).__idiv or(g(b)or p).__idiv or e]]..f,"OP: '//'",nil,nil)(Gt,floor,GG,e(3))if not bit32 then C.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
Ti(PreRun,function()D=TS(C.args)["cssc.BO.D"]and"bitD."or"bit."end)C:load_libs"code".cssc"runtime""op_stack"()"syntax_loader"(3)(s,{O=function(...)for k,v,I,u in Gp{...}do
u=v=="~"k=v=="//"and O["*"][1]or P
O[v]=u and{k,p}or{k}I={{" ",5},{l..B[v],3}}u=u and{{l.."bnot",3}}Runtime.build("bit."..B[v],bit32[B[v]]and
Gl(SF(F..[[("number"~=t(a)or"number"~=t(b))and((g(a)or p).%s or(g(b)or p).%s or e)or f]]..f,"__"..B[v],"__"..B[v],"__"..B[v],"__"..B[v]),"OP: '"..v.."'",nil,nil)(Gt,bit32[B[v]],GG,r)or x,1)Runtime.build("bitD."..B[v],bit32[B[v]]or x,1)Operators[v]=function()local i,d,U=Cdata.tb_while(S)U=u and d[1]==2 or d[1]==9 or d[1]==4
if not U and c[d[1]]then C.error("Unexpected '%s' after '%s'!",v,Result[i])end
Runtime.reg(U and l.."bnot"or l..B[v],D..(U and"bnot"or B[v]))Cssc.inject(U and""or",",2,not U and k or nil,U and p or nil)Text.split_seq(nil,#v)Event.run(2,v,2,1)Event.run("all",v,2,1)Event.reg("all",function(o,t)if t==4 and Result[#Result]~="function"or t==10 or t==2 and not Cdata[#Cdata][3]then C.error("Unexpected '%s' after '%s'!",o,v)end
return not S[t]and 1
end)Cssc.op_conf(U and u or I,U and p or k,U,nil,nil)end
end
P=P+1
end})Runtime.build("bitD.bnot",bit32.bnot,1)Runtime.build("bit.bnot",Gl(Sg(F,",b","")..[["number"~=t(a)and((g(a)or p).__bnot or e)or f)(a)end]])(Gt,bit32.bnot,GG,Ge),1)