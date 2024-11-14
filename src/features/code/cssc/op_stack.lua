function(Control) --cssc feature to process and stack unfinished operators (turned into function calls) in current level data field. (op_st - field name) 
    --Control.OStack
    --OP_stack feature: {OP_index,OP_priority,OP_start,OP_breaket}
    local L,CD,pht = Control.Level,Control.CData,{}

    --fin all unfinished operators
    Control.Event.reg("lvl_close",function(lvl)
        if lvl.OP_st then
            local i = #CD
            for k=#lvl.OP_st,1 do
                Control.inject(i,")",__CLOSE_BREAKET__,lvl.OP_st[k][4])--fin all unfinished
            end
        end
    end,"OP_st_f",__TRUE__)

    --priority check
    Control.Event.reg(__OPERATOR__,function(obj,tp)
        local lvl,cdt,st = L[#L],CD[#CD]
        if lvl.OP_st and cdt[2] then --level has OP_stack and current op is binary (unary opts has no affection on opts before them)
            if cdt[2] <= lvl.OP_st[#lvl.OP_st][2] then--priority of CSSC operator is highter or equal -> inject closing breaket
                st=remove(lvl.OP_st)--del last
                Control.inject(#CD,")",__CLOSE_BREAKET__,st[4])--insert breaket before current operator
            end
        end
    end,"OP_st_d",__TRUE__)

    Control.inject_operator = function(pre_tab,priority, is_unary)--function to inject common operators fast
        --init locals
        local lvl,i,cdt,b,st,sp =L[#L],#CD --level; index; breaket; curent_cdata,stack_tab,start_pos
        cdt,st,pre_tab=CD[i],lvl.OP_st or{},pre_tab or{}
        sp=#st>0 and st[#st][4] or lvl.index --find start_position for while cycle

        --trace back cycle
        if not is_unary then
            while i>sp and not(cdt[1]==__OPERATOR__ and cdt[2]<priority)do
                i=(L.data[Control.Result[i]]or pht)[2] and cdt[2] or i-1
                --if cdt[1]==__OPERATOR__ and cdt[2]==0 then end --TODO: EMIT ERROR!!! statement_end detected!!!!
                cdt=CD[i]
            end --after that cycle i will contain index where we need to place the start of our operator
        end
        if i<sp then Control.error("OP_STACK Unexpected error!")end
        i=i+1 --increment i (index correction)
        --iject data before
        Control.inject(i,"(",__OPEN_BREAKET__)--insert open breaket
        for k=#pre_tab,1 do --insert caller function/construct if exist
            Control.inject(i,unpack(pre_tab[k]))
        end

        insert(lvl.OP_st,{#CD,priority,i,i+#pre_tab})--new element in stack to finalize
        lvl.OP_st=st--save table (if unsaved)
    end
end