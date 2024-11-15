{[_init]=function(Control)--bitwize operators (lua53 - backport feature)
    Control:load_lib"code.cssc.pdata"
    Control:load_lib"code.cssc.op_stack"
    local opts= Control.Cdata.opts
    --local lvl = Control.Level
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
    Control:load_lib"code.syntax_loader"(stx,{O=function(...)--reg syntax
        for k,v,tab,has_un in pairs{...}do
            has_un=v=="~"
            k= v=="//" and opts["*"][1] or p --calc actual priority
            opts[v]=has_un and{k,p_un}or{k}
            tab={{"__cssc__bit_"..bt[v],__WORD__}}
            
            has_un=has_un and {{"__cssc__bit_bnot",__WORD__}} 
            if has_un then Control.Runtime.reg("__cssc__bit_bnot","bit.bnot",function()end,__TRUE__) end
            Control.Runtime.reg("__cssc__bit_"..bt[v],"bit."..bt[v],function()end,__TRUE__)
            
            Control.Operators[v]=function()--operator detected!
                
                local id,prew,is_un = Control.Cdata.tb_while(tb)
                is_un = has_un and prew[1]==__OPERATOR__ or prew[1]==__OPEN_BREAKET__
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
    --reg_data
    Control.Runtime.reg()
end}