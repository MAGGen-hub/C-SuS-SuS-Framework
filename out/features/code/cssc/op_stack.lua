local match,insert,remove,unpack = ENV(2,7,9,10)
--cssc feature to process and stack unfinished operators (turned into function calls) in current level data field. (op_st - field name) 
--Control.OStack
--OP_stack feature: {OP_index,OP_priority,OP_start,OP_breaket}
local pht,tb = {},Cdata.skip_tb

--fin all unfinished operators
Event.reg("lvl_close",function(lvl)
    if lvl.OP_st then
        local i = #Cdata
        for k=#lvl.OP_st,1,-1 do
            Cssc.inject(i,")",10,lvl.OP_st[k][4])--fin all unfinished
        end
    end
end,"OP_st_f",1)

--priority check
Event.reg(2,function(obj,tp)
    local lvl,cdt,st,cst = Level[#Level],Cdata[#Cdata]
    st=lvl.OP_st
    if st and cdt[2] then --level has OP_stack and current op is binary (unary opts has no affection on opts before them)
        --TODO: add for cycle for all that lower!!!!
        while #st>0 and cdt[2] <= st[#st][2] do--priority of CSSC operator is highter or equal -> inject closing breaket
            --print(obj,cdt[2],st[#st][2])
            cst=remove(st)--del last
            Cssc.inject(#Cdata,")",10,cst[4])--insert breaket before current operator
        end
    end
end,"OP_st_d",1)

--control.configure_operator
Cssc.op_conf = function(pre_tab,priority, is_unary,skip_fb,now_end,id)--function to inject common operators fast
    --init locals
    local lvl,i,cdt,b,st,sp,last =Level[#Level],id or #Cdata --level; index; breaket; curent_cdata,stack_tab,start_pos
    cdt,st,pre_tab=Cdata[i],lvl.OP_st or{},pre_tab or{}
    sp=#st>0 and st[#st][4] or lvl.index --find start_position for while cycle
    --print(sp==lvl.index,lvl.OP_st)
    --trace back cycle
    if not is_unary then
        --print(i,sp,cdt,cdt[1],cdt[2])
        while i>sp and not(cdt[1]==2 and (cdt[2]or cdt[3])<priority)do
            i=(Level.data[match(Result[i],"%S+")]or pht)[2] and cdt[2] or i-1
            --if cdt[1]==2 and cdt[2]==0 then end --TODO: EMIT ERROR!!! statement_end detected!!!!
            cdt=Cdata[i]
        end --after that cycle i will contain index where we need to place the start of our operator
        --print("cdt:",cdt)
        last=cdt
    else
        _,last=Cdata.tb_while(tb,i-1)
    end
    if i<sp then Control.error("OP_STACK Unexpected error!")end
    i=i+1 --increment i (index correction)
    --iject data before
    if not skip_fb then
        Cssc.inject(i,"(",9)--insert open breaket
        if #pre_tab>0 then
            Cssc.inject(i,"" --@@DEBUG .."--[[cl mrk]]"
            ,2,Cdata.opts[":"][1])--call mark
        end
        for k=#pre_tab,1,-1 do --insert caller function/construct if exist
            Cssc.inject(i,unpack(pre_tab[k]))
        end
    end
    if now_end then--inject fin breaket imidiatly
        Cssc.inject(")",10)
        return i-1,last
    end
    insert(st,{#Cdata,priority,i,i+#pre_tab})--new element in stack to finalize
    lvl.OP_st=st--save table (if unsaved)
    return i-1,last
end