{[_init]=function(Control)--bitwize operators (lua53 - backport feature)
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

    Control:load_lib"code.syntax_loader"(stx,{O=function(...)
        for k,v in pairs{...}do k=k+p
            opts[v]=opts[v]and{opts[v][1],p_un}or{k}
            
            Control.Operators[v]=function()
                local lvl = Control.Level[#Control.Level]
                lvl.BO_st=lvl.BO_st or {k}--BO_stack for this level
                --Cdata trace back (li -> bitwize can't jump out of his own level)
                local i,li,c = #Control.Cdata,lvl.index
                c=Control.Cdata[i]
                while i>li and not(c[1]==__OPERATOR__ and c[2] < k) do --find operator with lower priority than our bitwize op
                    i=(Control.Level.data[Control.Result[i]]or pht)[2] and c[2] or i-1 --check level -> if lvl is closeable: try jump back to it's start
                    if c[1]==__OPERATOR__ and c[2]==0 then end --TODO: EMIT ERROR!!! statement_end detected!!!!
                    c=Control.Cdata[i]
                end

                Control.inject(nil,",",__OPERATOR__)
            end
            --TODO: opts
        end
    end})

    Control.Operators["&"]
    Control.Operators["~"]
    Control.Operators["<<"]
    Control.Operators[">>"]
    Control.Operators["|"]
    Control.Operators["//"]
    function(Control,obj)

    end

    for 
end}