local opts,match,format,insert,floor,type,pairs,error,getmetatable,pcall,native_load,bit32,t_swap=Cdata.opts,ENV(2,3,7,11,13,14,15,18,20,21,22,24)
--bitwize operators (lua53 - backport feature) and idiv
local stx,pht,p,p_un,tb,bt,check,loc_base,idiv_func,_,arg =[[O
|
~
&
<< >>
//
]],{},opts["<"][1]+1,opts["#"][2],Cdata.skip_tb,
t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},t_swap{2,9,4},"__cssc__bit_"..(direct and"d_"or""), --priority base, unary priority,bitw funcs
native_load([[local p,n,t,g,e,F,f={},"number",... f=function(a,b)local ta,tb=t(a)==n, t(b)==n if ta and tb then return F(a/b)end e("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value",2)end
return function(a,b)return((g(a)or p).__idiv or(g(b)or p).__idiv or f)(a,b)end]],"OP: '//'",nil,nil)(type,getmetatable,error,floor),...


if not bit32 then Control.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
local direct--TODO:temporal solution rework
if arg then
    for k,v in pairs(arg)do
        direct = direct or v=="direct"
    end
end
C:load_lib"code.cssc.runtime"
C:load_lib"code.cssc.op_stack"

C:load_lib"code.syntax_loader"(stx,{O=function(...)--reg syntax
    for k,v,tab,has_un in pairs{...}do
        has_un=v=="~"
        k= v=="//" and opts["*"][1] or p --calc actual priority
        opts[v]=has_un and{k,p_un}or{k}
        tab={{" ",5},{loc_base..bt[v],3}}
        
        has_un=has_un and {{loc_base.."bnot",3}}
        --local bit_name,bit_func
        --try get metatables from a and b and select function to run (probably it's better to check their type before, but the smaller the function the faster it will be)    
        if not direct then
            local func =bit32[bt[v]] and native_load(format([[local p,g,f,P,e,t={},... return function(a,b)a,b=P((g(a)or p).%s or(g(b)or p).%s or f ,a,b) return a and b or e(((g(a)or p).%s or(g(b)or p).%s) and b or("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value"),2) end]],"__"..bt[v],"__"..bt[v],"__"..bt[v],"__"..bt[v])
            ,"OP: '"..v.."'",nil,nil)(getmetatable,bit32[bt[v]],pcall,error,type)or idiv_func --this function creates ultra fast & short pice of runtime working code
            Runtime.build("bit."..bt[v],func,1)
        else Runtime.build("bitD."..bt[v],bit32[bt[v]] or idiv_func ,1) end
        
        Operators[v]=function()--operator detected!
            local id,prew,is_un,i,d = Cdata.tb_while(tb)
            is_un = has_un and prew[1]==2 or prew[1]==9 --is unary operator
            i,d=Cdata.tb_while(tb)

            if not is_un and check[d[1]] then Control.error("Unexpected '%s' after '%s'!",v,Result[i])end--error check before

            Runtime.reg(is_un and loc_base.."bnot" or loc_base..bt[v],is_un and "bit.bnot" or "bit."..bt[v])
            Control.inject(nil,is_un and ""or",",2,not is_un and k or nil, is_un and p_un or nil)--inject found operator Control.Cdata.opts[","][1]
            Text.split_seq(nil,#v)--remove bitwize from queue
            Event.run(2,v,2,1)--send events to fin opts in OP_st
            Event.run("all",v,2,1)

            Event.reg("all",function(obj,tp)--error check after
                --if tp==4 and not match(Control.Result[#Control.Result],"^function") or  tp==10 or tp==2 and not Control.Cdata[#Control.Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                if tp==4 and Result[#Result]~="function" or  tp==10 or tp==2 and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                return not tb[tp] and 1 
            end)
            --reg operator data
            Control.configure_operator(is_un and has_un or tab,is_un and p_un or k,is_un,nil,nil) --including stat_end
        end
        --TODO: opts
    end
    p=p+1
end})
if  direct then
    Runtime.build("bitD.bnot",bit32.bnot,1)
else
    local func = native_load([[local p,g,f,P,e,t,_={},... return function(a)_,a=P((g(a)or p).__bnot or f,a) return _ and a or e((g(a)or p).__bnot and a or ("attempt to perform bitwise operation on a "..t(a).." value"),2) end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot,pcall,error,type)
    Runtime.build("bit.bnot",func,1)
end
--return 1