{[_init]=function(Control,direct)--bitwize operators (lua53 - backport feature)
    direct=false--TODO:temporal solution rework
    Control:load_lib"code.cssc.pdata"
    Control:load_lib"code.cssc.op_stack"
    local opts= Control.Cdata.opts
    local stx=[[O
|
~
&
<< >>
//
]]--last one 'bitwize not'
    local pht ={}
    local p = opts["<"][1]+1 --priority base
    local p_un = opts["#"][2] --unary priority
    local bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}--bitw funcs
    local tb=t_swap{__COMMENT__}
    local loc_base = "__cssc__bit_"
    local used_opts= {}

    Control:load_lib"code.syntax_loader"(stx,{O=function(...)--reg syntax
        for k,v,tab,has_un in pairs{...}do
            has_un=v=="~"
            k= v=="//" and opts["*"][1] or p --calc actual priority
            opts[v]=has_un and{k,p_un}or{k}
            tab={{loc_base..bt[v],__WORD__}}
            
            has_un=has_un and {{loc_base.."bnot",__WORD__}}
            local bit_name,bit_func
            --try get metatables from a and b and select function to run (probably it's better to check their type before, but the smaller the function the faster it will be)    
            if not direct then
                local func = native_load(format([[local p,g,f={},... return function(a,b)return((g(a)or p).%s or(g(b)or p).%s or f)(a,b)end]],"__"..bt[v],"__"..bt[v])
                ,loc_base..bt[v],nil,nil)(getmetatable,bit32[bt[v]])--this function creates ultra fast & short pice of runtime working code
                --prewious code is equivalent of: function(a,b)
                --    return((getmetatable(a)or pht)[bit_name] or (getmetatable(b)or pht)[bit_name] or bit_func)(a,b)
                --end
                Control.Runtime.build("bit."..bt[v],func,__TRUE__)
            else Control.Runtime.build("bitD."..bt[v],func,__TRUE__) end
            
            Control.Operators[v]=function()--operator detected!
                local id,prew,is_un = Control.Cdata.tb_while(tb)

                is_un = has_un and prew[1]==__OPERATOR__ or prew[1]==__OPEN_BREAKET__
                if not used_opts[is_un and "bnot"or v] then Control.Runtime.reg(is_un and loc_base.."bnot" or loc_base..bt[v],is_un and "bit.bnot" or "bit."..bt[v])end
                Control.inject(nil,is_un and ""or",",__OPERATOR__,not is_un and k or nil, is_un and p_un or nil)--inject found operator Control.Cdata.opts[","][1]
                Control.split_seq(nil,#v)--remove bitwize from queue
                Control.Event.run(__OPERATOR__,v,__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
                Control.Event.run("all",v,__OPERATOR__,__TRUE__)
                --reg operator data
                Control.inject_operator(is_un and has_un or tab,is_un and p_un or k,is_un) --including stat_end
            end
            --TODO: opts
        end
        p=p+1
    end})
    if not direct then
        local func = native_load([[local p,g,f={},... return function(a)return((g(a)or p).__bnot or f)(a)end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot)
        Control.Runtime.build("bit.bnot",func,__TRUE__)
    else
        Control.Runtime.build("bitD.bnot",bit32.bnot,__TRUE__)
    end
    insert(Control.Clear,function()used_opts={}end)
end}