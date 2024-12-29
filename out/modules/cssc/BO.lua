local l_opts,Sg,Sm,SF,Ti,floor,Gt,Gp,Ge,GG,GP,Gl,bit32,TS=Cdata.opts,ENV(5,2,3,7,27,12,13,14,17,19,20,21,23)floor=floor.floor
local make_err,func_part1,func_part2=function(i)return function(a,b)Ge("attempt to perform ariphmetic on a "..(Gt(a)~="number"and Gt(a)or Gt(b)).." value",i)end end,'local p,t,f,g,e={},...return function(a,b)return(',')(a,b)end'local run_err,stx,cur_priority,p_un,skipper_tab,bitwize_opts,check,loc_base,idiv_func=make_err(2),[[O
|
~
&
<< >>
//
]],l_opts["<"][1]+1,l_opts["#"][2],Cdata.skip_tb,TS{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},TS{2,9,4},"__cssc__bit_",Gl(func_part1..[["number"==t(a)and"number"==t(b))and f(a/b)or((g(a)or p).__idiv or(g(b)or p).__idiv or e]]..func_part2,"OP: '//'",nil,nil)(Gt,floor,GG,make_err(3))if not bit32 then C.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
local direct
Ti(PreRun,function()direct=TS(C.args)["cssc.BO.direct"]and"bitD."or"bit."end)C:load_libs"code".cssc"runtime""op_stack"()"syntax_loader"(3)(stx,{O=function(...)for k,v,tab,has_un in Gp{...}do
has_un=v=="~"k=v=="//"and l_opts["*"][1]or cur_priority
l_opts[v]=has_un and{k,p_un}or{k}tab={{" ",5},{loc_base..bitwize_opts[v],3}}has_un=has_un and{{loc_base.."bnot",3}}Runtime.build("bit."..bitwize_opts[v],bit32[bitwize_opts[v]]and
Gl(SF(func_part1..[[("number"~=t(a)or"number"~=t(b))and((g(a)or p).%s or(g(b)or p).%s or e)or f]]..func_part2,"__"..bitwize_opts[v],"__"..bitwize_opts[v],"__"..bitwize_opts[v],"__"..bitwize_opts[v]),"OP: '"..v.."'",nil,nil)(Gt,bit32[bitwize_opts[v]],GG,run_err)or idiv_func,1)Runtime.build("bitD."..bitwize_opts[v],bit32[bitwize_opts[v]]or idiv_func,1)Operators[v]=function()local id,prew,is_un,i,d=Cdata.tb_while(skipper_tab)is_un=has_un and prew[1]==2 or prew[1]==9 or prew[1]==4
_G.print(is_un)_G.print(prew[1])i,d=Cdata.tb_while(skipper_tab)if not is_un and check[d[1]]then C.Ge("Unexpected '%s' after '%s'!",v,Result[i])end
Runtime.reg(is_un and loc_base.."bnot"or loc_base..bitwize_opts[v],direct..(is_un and"bnot"or bitwize_opts[v]))Cssc.inject(is_un and""or",",2,not is_un and k or nil,is_un and p_un or nil)Text.split_seq(nil,#v)Event.run(2,v,2,1)Event.run("all",v,2,1)Event.reg("all",function(obj,tp)if tp==4 and Result[#Result]~="function"or tp==10 or tp==2 and not Cdata[#Cdata][3]then C.Ge("Unexpected '%s' after '%s'!",obj,v)end
return not skipper_tab[tp]and 1
end)Cssc.op_conf(is_un and has_un or tab,is_un and p_un or k,is_un,nil,nil)end
end
cur_priority=cur_priority+1
end})Runtime.build("bitD.bnot",bit32.bnot,1)Runtime.build("bit.bnot",Gl(Sg(func_part1,",b","")..[["number"~=t(a)and((g(a)or p).__bnot or e)or f)(a)end]])(Gt,bit32.bnot,GG,Ge),1)