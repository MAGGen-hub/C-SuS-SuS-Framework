{[_init]=function(Control)--bitwize operators (lua53 - backport feature)
    Control:load_lib"code.cssc.pdata"
    Control:load_lib"code.cssc.op_stack"
    local opts= Control.Cdata.opts
    --local lvl = Control.Level
    local stx=[[O
|
~
&
<< >> ~]]--last one 'bitwize not'
    local pht ={}
    local p = opts["<"][1]+1 --priority base
    local p_un = opts["#"][2] --unary priority
    local bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}--bitw funcs
    --local pr=t_swap{'|','~','&','<<'} pr[">>"]=4--make priority table
    --for i=1,#pr do pr[i]=pr[i]+pr_base end 


    Control.Event.reg()--reg lvl_close to inject closeing breaket
    Control.Event.reg()--reg __OPERATOR__ event to check it's priority and close is it lower or equal
    local tb=t_swap{__COMMENT__}
    Control:load_lib"code.syntax_loader"(stx,{O=function(...)
        for k,v,tab in pairs{...}do k=v=="//" and opts["*"][1] or k+p --calc actual priority
            tab={{"bitw_opt",__WORD__},{".",__OPERATOR__,Control.Cdata.opts["."][1]},{bt[v],__WORD__}}
            opts[v]=opts[v]and{opts[v][1],p_un}or{k}
            
            Control.Operators[v]=function()--operator detected!
                --TODO: error check!
                local id,prew = Control.Cdata.tb_while(tb)
                Control.inject(nil,",",__OPERATOR__,k)--inject found operator
                Control.split_seq(nil,#v)--remove bitwize from queue

                Control.Event.run(__OPERATOR__,v,__OPERATOR__)--send events to fin opts in OP_st
                Control.Event.run("all",v,__OPERATOR__)
                --reg operator data
                Control.inject_operator(tab,k,v=="~" and prew[1]==__OPERATOR__) --including stat_end

            end
            --TODO: opts
        end
    end})
end}