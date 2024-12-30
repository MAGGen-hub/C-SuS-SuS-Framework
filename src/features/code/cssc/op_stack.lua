local match,insert,remove,unpack = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__)
--cssc feature to process and stack unfinished operators (turned into function calls) in current level data field. (op_st - field name) 
--Control.OStack
--OP_stack feature: {OP_index,OP_priority,OP_start,OP_breaket}
local placeholder_table,skipper_tab = {},Cdata.skip_tb

--fin all unfinished operators
Event.reg("lvl_close",function(Lvl)
    if Lvl.OP_st then
        local i = #Cdata
        for k=#Lvl.OP_st,1,-1 do
            Cssc.inject(i,")",__CLOSE_BREAKET__,Lvl.OP_st[k][4])--fin all unfinished
        end
    end
end,"OP_st_f",__TRUE__)

--priority check
Event.reg(__OPERATOR__,function()--obj,tp
    local Lvl,cdt_obj,stack = Level[#Level],Cdata[#Cdata]
    stack=Lvl.OP_st
    if stack and cdt_obj[2] then --level has OP_stack and current op is binary (unary opts has no affection on opts before them)
        --TODO: add for cycle for all that lower!!!!
        while #stack>0 and cdt_obj[2] <= stack[#stack][2] do--priority of CSSC operator is highter or equal -> inject closing breaket
            --cst=remove(stack)--del last
            Cssc.inject(#Cdata,")",__CLOSE_BREAKET__,remove(stack)[4])--insert breaket before current operator
        end
    end
end,"OP_st_d",__TRUE__)

--control.configure_operator
Cssc.op_conf = function(pre_tab,priority,is_unary,skip_fb,now_end,l_id)--function to inject common operators fast
    --init locals
    local Lvl,cdt_obj,stack,start_pos=Level[#Level]
    l_id=l_id or #Cdata --level; index; breaket; curent_cdata,stack_tab,start_pos
    cdt_obj,stack,pre_tab=Cdata[l_id],Lvl.OP_st or{},pre_tab or{}
    start_pos=#stack>0 and stack[#stack][4] or Lvl.index --find start_position for while cycle
    
    --trace back cycle
    if not is_unary then
        while l_id>start_pos and not(cdt_obj[1]==__OPERATOR__ and (cdt_obj[2]or cdt_obj[3])<priority)do
            l_id=(Level.data[match(Result[l_id],"%S+")]or placeholder_table)[2] and cdt_obj[2] or l_id-1
            --if cdt_obj[1]==__OPERATOR__ and cdt_obj[2]==0 then end --TODO: EMIT ERROR!!! statement_end detected!!!!
            cdt_obj=Cdata[l_id]
        end --after that cycle l_id will contain index where we need to place the start of our operator
    else
        _,cdt_obj=Cdata.tb_while(skipper_tab,l_id-1)
    end

    if l_id<start_pos then C.error("OP_STACK Unexpected error!")end
    l_id=l_id+1 --increment l_id (index correction)
    --iject data before
    if not skip_fb then
        Cssc.inject(l_id,"(",__OPEN_BREAKET__)--insert open breaket
        if #pre_tab>0 then
            Cssc.inject(l_id,"" --@@DEBUG .."--[[cl mrk]]"
            ,__OPERATOR__,Cdata.opts[":"][1])--call mark
        end
        for k=#pre_tab,1,-1 do --insert caller function/construct if exist
            Cssc.inject(l_id,unpack(pre_tab[k]))
        end
    end
    if now_end then--inject fin breaket imidiatly
        Cssc.inject(")",__CLOSE_BREAKET__)
        return l_id-1,cdt_obj
    end
    insert(stack,{#Cdata,priority,l_id,l_id+#pre_tab})--new element in stack to finalize
    Lvl.OP_st=stack--save table (if unsaved)
    return l_id-1,cdt_obj
end