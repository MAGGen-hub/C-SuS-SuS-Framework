--CODE DATA API 
local insert,remove,t_swap=ENV(7,9,23)
--local opts_hash,level_hash,keywords_hash=...
--API to save code data to specific table
local check,c,clear_func=t_swap{2,4,9}
clear_func=function() for i=1,#c do c[i]=nil end c[1]={2,0}end
c={--opts=opts_hash,lvl=level_hash,kwrd=keywords_hash,
    run=function(obj,obj_tp)--to call from core
        local lvl_obj,rez=c.lvl[obj]
        if lvl_obj and lvl_obj[2] then --object with lvl props
            rez=Level[#Level] --TODO: temporal solution! REWORK!!!
            rez ={obj_tp,rez.ends[obj] and rez.index}
        elseif obj_tp==2 then
            local priority_data,last_type,is_un = c.opts[obj],c[#c][1]--last_type,is_unary
            is_un = priority_data[2] and (not priority_data[1] or not check[last_type])--unary or binary
            rez={obj_tp,not is_un and priority_data[1],is_un and priority_data[2]}--insert operator data handle
        else
            rez={obj_tp}
        end
        c[#c+1]=rez
    end,
    reg=function(obj_tp,index,...)--reg custom value in specific field
        local rez = {obj_tp,...}--args and {tp,...} or {tp}
        insert(c,index or #c+1,rez)
    end,
    del=function(index)--del specific value from index
        return remove(c,index or #c+1)
    end,
    skip_tb=t_swap{11,5}, --specific table with non esentual values (by default)
    tb_until=function(type_tab,i)--thaceback_until:
        i=i or#c+1
        repeat i=i-1 until i<1 or type_tab[c[i][1]]
        return i,c[i]
    end,
    tb_while=function(type_tab,i)--thaceback_while:
        i=i or#c
        while i>0 and type_tab[c[i][1]]do i=i-1 end
        return i,c[i]
    end,
    get_priority=function(obj,unary)
        return (c.opts[obj]or{})[unary and 2 or 1]
    end,
    is_keyword=function(obj)
        return c.kwrd[obj]
    end,
     {2,0}
}
c.opts,c.lvl,c.kwrd=... --opts_hash,level_hash,keywords_hash
C.Cdata=c
insert(Clear,clear_func)