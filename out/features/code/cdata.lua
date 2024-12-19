--CODE DATA API 
local insert,remove,t_swap=ENV(7,9,24)
--local opts_hash,level_hash,keywords_hash=...
--API to save code data to specific table
local check,c,clr=t_swap{2,4,9}
clr=function() for i=1,#c do c[i]=nil end c[1]={2,0}end
c={--opts=opts_hash,lvl=level_hash,kwrd=keywords_hash,
    run=function(obj,tp)--to call from core
        local lh,rez=c.lvl[obj]
        --if obj=="(" then print(lh,rez) end
        if lh and lh[2] then --object with lvl props
            rez=Level[#Level] --TODO: temporal solution! REWORK!!!
            rez ={tp,rez.ends[obj] and rez.index}
        elseif tp==2 then
            local pd,lt,un = c.opts[obj],c[#c][1]--priority_data,last_type,is_unary
            un = pd[2] and (not pd[1] or not check[lt])--unary or binary
            rez={tp,not un and pd[1],un and pd[2]}--insert operator data handle
        else
            rez={tp}
        end
        c[#c+1]=rez
    end,
    reg=function(tp,id,...)--reg custom value in specific field
        local rez = {tp,...}--args and {tp,...} or {tp}
        insert(c,id or #c+1,rez)
    end,
    del=function(id)--del specific value from index
        return remove(c,id or #c+1)
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
insert(Clear,clr)