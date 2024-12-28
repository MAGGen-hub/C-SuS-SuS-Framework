local opts,Sm,SF,Ti,floor,Gt,Gp,Ge,GG,GP,Gl,bit32,TS=Cdata.opts,ENV(2,3,7,27,12,13,14,17,19,20,21,23)floor=floor.floor
local err=function(a,b)Ge("attempt to perform ariphmetic on a "..(Gt(a)~="number"and Gt(a)or Gt(b)).." value",3)end
local err2=function(a,b)Ge("attempt to perform ariphmetic on a "..(Gt(a)~="number"and Gt(a)or Gt(b)).." value",2)end
local stx,pht,p,p_un,tb,bt,check,loc_base,idiv_func=[[O
|
~
&
<< >>
//
]],{},opts["<"][1]+1,opts["#"][2],Cdata.skip_tb,TS{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},TS{2,9,4},"__cssc__bit_",Gl([[local p,t,f,g,e={},...return function(a,b)return("number"==t(a)and"number"==t(b))and f(a/b)or((g(a)or p).__idiv or(g(b)or p).__idiv or e)(a,b)end]],"OP: '//'",nil,nil)(Gt,floor,GG,err2)if not bit32 then Control.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
local direct
Ti(PreRun,function()direct=TS(C.args)["cssc.BO.direct"]and"bitD."or"bit."end)C:load_libs"code".cssc"runtime""op_stack"()"syntax_loader"(3)(stx,{O=function(...)for k,v,tab,has_un in Gp{...}do
has_un=v=="~"k=v=="//"and opts["*"][1]or p
opts[v]=has_un and{k,p_un}or{k}tab={{" ",5},{loc_base..bt[v],3}}has_un=has_un and{{loc_base.."bnot",3}}local func=bit32[bt[v]]and Gl(SF([[local p,t,f,g,e={},...return function(a,b)return(("number"~=t(a)or"number"~=t(b))and((g(a)or p).%s or(g(b)or p).%s or e)or f)(a,b)end]],"__"..bt[v],"__"..bt[v],"__"..bt[v],"__"..bt[v]),"OP: '"..v.."'",nil,nil)(Gt,bit32[bt[v]],GG,err)or idiv_func
Runtime.build("bit."..bt[v],func,1)Runtime.build("bitD."..bt[v],bit32[bt[v]]or idiv_func,1)Operators[v]=function()local id,prew,is_un,i,d=Cdata.tb_while(tb)is_un=has_un and prew[1]==2 or prew[1]==9
i,d=Cdata.tb_while(tb)if not is_un and check[d[1]]then Control.Ge("Unexpected '%s' after '%s'!",v,Result[i])end
Runtime.reg(is_un and loc_base.."bnot"or loc_base..bt[v],direct..(is_un and"bnot"or bt[v]))Cssc.inject(is_un and""or",",2,not is_un and k or nil,is_un and p_un or nil)Text.split_seq(nil,#v)Event.run(2,v,2,1)Event.run("all",v,2,1)Event.reg("all",function(obj,tp)if tp==4 and Result[#Result]~="function"or tp==10 or tp==2 and not Cdata[#Cdata][3]then Control.Ge("Unexpected '%s' after '%s'!",obj,v)end
return not tb[tp]and 1
end)Cssc.op_conf(is_un and has_un or tab,is_un and p_un or k,is_un,nil,nil)end
end
p=p+1
end})if direct then
Runtime.build("bitD.bnot",bit32.bnot,1)else
local func=Gl([[local p,g,f,P,e,t,_={},... return function(a)_,a=P((g(a)or p).__bnot or f,a) return _ and a or e((g(a)or p).__bnot and a or ("attempt to perform bitwise operation on a "..t(a).." value"),2) end]],"__cssc_bit_bnot",nil,nil)(GG,bit32.bnot,GP,Ge,Gt)Runtime.build("bit.bnot",func,1)end