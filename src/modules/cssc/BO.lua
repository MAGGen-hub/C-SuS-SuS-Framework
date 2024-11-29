local match,format,insert,floor,type,pairs,error,getmetatable,pcall,native_load,bit32,t_swap=ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_FLOOR__,__ENV_TYPE__,__ENV_PAIRS__,__ENV_ERROR__,__ENV_GETMETATABLE__,__ENV_PCALL__,__ENV_LOAD__,__ENV_BIT_LIB__,__ENV_T_SWAP__)
local mod,arg=...
--bitwize operators (lua53 - backport feature) and idiv
if not bit32 then Control.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
local direct--TODO:temporal solution rework
if arg then
    for k,v in pairs(arg)do
        direct = direct or v=="direct"
    end
end
Control:load_lib"code.cssc.runtime"
Control:load_lib"code.cssc.op_stack"
local opts= Control.Cdata.opts
local stx=[[O
|
~
&
<< >>
//
]]--last one 'bitwize not' (not shown in "stx")
local pht ={}
local p = opts["<"][1]+1 --priority base
local p_un = opts["#"][2] --unary priority
local bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}--bitw funcs
local tb=Control.Cdata.skip_tb
local check = t_swap{__OPERATOR__,__OPEN_BREAKET__,__KEYWORD__}
local loc_base = "__cssc__bit_"..(direct and"d_"or"")
local used_opts= {}
local num="number"
local idiv_func=native_load([[local p,n,t,g,e,F,f={},"number",... f=function(a,b)local ta,tb=t(a)==n, t(b)==n if ta and tb then return F(a/b)end e("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value",2)end
return function(a,b)return((g(a)or p).__idiv or(g(b)or p).__idiv or f)(a,b)end]],"OP: '//'",nil,nil)(type,getmetatable,error,floor)

Control:load_lib"code.syntax_loader"(stx,{O=function(...)--reg syntax
    for k,v,tab,has_un in pairs{...}do
        has_un=v=="~"
        k= v=="//" and opts["*"][1] or p --calc actual priority
        opts[v]=has_un and{k,p_un}or{k}
        tab={{" ",__SPACE__},{loc_base..bt[v],__WORD__}}
        
        has_un=has_un and {{loc_base.."bnot",__WORD__}}
        local bit_name,bit_func
        --try get metatables from a and b and select function to run (probably it's better to check their type before, but the smaller the function the faster it will be)    
        if not direct then
            local func =bit32[bt[v]] and native_load(format([[local p,g,f,P,e,t={},... return function(a,b)a,b=P((g(a)or p).%s or(g(b)or p).%s or f ,a,b) return a and b or e(((g(a)or p).%s or(g(b)or p).%s) and b or("attempt to perform ariphmetic on a "..(ta and t(b) or t(a)).." value"),2) end]],"__"..bt[v],"__"..bt[v],"__"..bt[v],"__"..bt[v])
            ,"OP: '"..v.."'",nil,nil)(getmetatable,bit32[bt[v]],pcall,error,type)or idiv_func --this function creates ultra fast & short pice of runtime working code
            Control.Runtime.build("bit."..bt[v],func,__TRUE__)
        else Control.Runtime.build("bitD."..bt[v],bit32[bt[v]] or idiv_func ,__TRUE__) end
        
        Control.Operators[v]=function()--operator detected!
            local id,prew,is_un = Control.Cdata.tb_while(tb)

            is_un = has_un and prew[1]==__OPERATOR__ or prew[1]==__OPEN_BREAKET__

            local i,d=Control.Cdata.tb_while(tb)
            if not is_un and check[d[1]] then Control.error("Unexpected '%s' after '%s'!",v,Control.Result[i])end--error check before

            if not used_opts[is_un and "bnot"or v] then used_opts[is_un and "bnot"or v]=__TRUE__  Control.Runtime.reg(is_un and loc_base.."bnot" or loc_base..bt[v],is_un and "bit.bnot" or "bit."..bt[v])end
            Control.inject(nil,is_un and ""or",",__OPERATOR__,not is_un and k or nil, is_un and p_un or nil)--inject found operator Control.Cdata.opts[","][1]
            Control.split_seq(nil,#v)--remove bitwize from queue
            Control.Event.run(__OPERATOR__,v,__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
            Control.Event.run("all",v,__OPERATOR__,__TRUE__)

            Control.Event.reg("all",function(obj,tp)--error check after
                if tp==__KEYWORD__ and not match(Control.Result[#Control.Result],"^function") or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Control.Cdata[#Control.Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                return not tb[tp] and __TRUE__ 
            end)
            --reg operator data
            Control.configure_operator(is_un and has_un or tab,is_un and p_un or k,is_un,nil,nil) --including stat_end
        end
        --TODO: opts
    end
    p=p+1
end})
if  direct then
    Control.Runtime.build("bitD.bnot",bit32.bnot,__TRUE__)
else
    local func = native_load([[local p,g,f,P,e,t,_={},... return function(a)_,a=P((g(a)or p).__bnot or f,a) return _ and a or e((g(a)or p).__bnot and a or ("attempt to perform bitwise operation on a "..t(a).." value"),2) end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot,pcall,error,type)
    Control.Runtime.build("bit.bnot",func,__TRUE__)
end
insert(Control.Clear,function()used_opts={}end)
--return __TRUE__