local opts,match,format,insert,floor,type,pairs,error,getmetatable,pcall,native_load,bit32,t_swap=Cdata.opts,ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_FLOOR__,__ENV_TYPE__,__ENV_PAIRS__,__ENV_ERROR__,__ENV_GETMETATABLE__,__ENV_PCALL__,__ENV_LOAD__,__ENV_BIT_LIB__,__ENV_T_SWAP__)
--bitwize operators (lua53 - backport feature) and idiv
local stx,pht,p,p_un,tb,bt,check,loc_base,idiv_func =[[O
|
~
&
<< >>
//
]],{},opts["<"][1]+1,opts["#"][2],Cdata.skip_tb,
t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},t_swap{__OPERATOR__,__OPEN_BREAKET__,__KEYWORD__},"__cssc__bit_", --priority base, unary priority,bitw funcs
native_load([[local p,n,t,g,e,F,f={},"number",... f=function(a,b)local ta,tb=t(a)==n, t(b)==n if ta and tb then return F(a/b)end e("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value",2)end
return function(a,b)return((g(a)or p).__idiv or(g(b)or p).__idiv or f)(a,b)end]],"OP: '//'",nil,nil)(type,getmetatable,error,floor)

if not bit32 then Control.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
local direct--TODO:temporal solution rework
insert(PreRun,function() direct=t_swap(C.args)["cssc.BO.direct"]and"bitD."or"bit." end)
C:load_libs"code"
    .cssc
        "runtime"
        "op_stack"()
    "syntax_loader"(3)(stx,{O=function(...)--reg syntax
    for k,v,tab,has_un in pairs{...}do
        has_un=v=="~"
        k= v=="//" and opts["*"][1] or p --calc actual priority
        opts[v]=has_un and{k,p_un}or{k}
        tab={{" ",__SPACE__},{loc_base..bt[v],__WORD__}}
        
        has_un=has_un and {{loc_base.."bnot",__WORD__}}
        --local bit_name,bit_func
        --try get metatables from a and b and select function to run (probably it's better to check their type before, but the smaller the function the faster it will be)    
        --if not direct then
        local func =bit32[bt[v]] and native_load(format([[local p,g,f,P,e,t={},... return function(a,b)a,b=P((g(a)or p).%s or(g(b)or p).%s or f ,a,b) return a and b or e(((g(a)or p).%s or(g(b)or p).%s) and b or("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value"),2) end]],"__"..bt[v],"__"..bt[v],"__"..bt[v],"__"..bt[v])
        ,"OP: '"..v.."'",nil,nil)(getmetatable,bit32[bt[v]],pcall,error,type)or idiv_func --this function creates ultra fast & short pice of runtime working code
        Runtime.build("bit."..bt[v],func,__TRUE__)
        Runtime.build("bitD."..bt[v],bit32[bt[v]] or idiv_func ,__TRUE__)
        --end
        
        Operators[v]=function()--operator detected!
            local id,prew,is_un,i,d = Cdata.tb_while(tb)
            is_un = has_un and prew[1]==__OPERATOR__ or prew[1]==__OPEN_BREAKET__ --is unary operator
            i,d=Cdata.tb_while(tb)

            if not is_un and check[d[1]] then Control.error("Unexpected '%s' after '%s'!",v,Result[i])end--error check before

            Runtime.reg(is_un and loc_base.."bnot" or loc_base..bt[v],direct..(is_un and"bnot"or bt[v]))
            Cssc.inject(is_un and ""or",",__OPERATOR__,not is_un and k or nil, is_un and p_un or nil)--inject found operator Control.Cdata.opts[","][1]
            Text.split_seq(nil,#v)--remove bitwize from queue
            Event.run(__OPERATOR__,v,__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
            Event.run("all",v,__OPERATOR__,__TRUE__)

            Event.reg("all",function(obj,tp)--error check after
                --if tp==__KEYWORD__ and not match(Control.Result[#Control.Result],"^function") or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Control.Cdata[#Control.Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                if tp==__KEYWORD__ and Result[#Result]~="function" or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                return not tb[tp] and __TRUE__ 
            end)
            --reg operator data
            Cssc.op_conf(is_un and has_un or tab,is_un and p_un or k,is_un,nil,nil) --including stat_end
        end
        --TODO: opts
    end
    p=p+1
end})
if  direct then
    Runtime.build("bitD.bnot",bit32.bnot,__TRUE__)
else
    local func = native_load([[local p,g,f,P,e,t,_={},... return function(a)_,a=P((g(a)or p).__bnot or f,a) return _ and a or e((g(a)or p).__bnot and a or ("attempt to perform bitwise operation on a "..t(a).." value"),2) end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot,pcall,error,type)
    Runtime.build("bit.bnot",func,__TRUE__)
end
--return __TRUE__