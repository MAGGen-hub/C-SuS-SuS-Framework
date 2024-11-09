function(Control,opts_hash,level_hash)--API to save code data to specific table
    local c,clr
    clr=function()
        c={opts=c.opts,lvl=c.lvl,run=c.run,reg=c.reg,del=c.del,tb_until=c.tb_until,tb_while=c.tb_while, {__COMMENT__}}
        Control.Cdata=c
    end
    c={opts=opts_hash,lvl=level_hash,
    run=function(obj,tp)--to call from core
        local lh,rez=c.lvl[obj]
        if obj=="(" then print(lh,rez) end
        if lh and lh[2] then --object with lvl props
            rez=Control.Level[#Control.Level]
            rez ={tp,rez.ends[obj] and rez.index}
        elseif tp==__OPERATOR__ then
            local pd,lt,un = c.opts[obj],c[#c][1]--priority_data,last_type,is_unary
            un = pd[2] and (not pd[1] or not (lt==__OPERATOR__ or  lt==__KEYWORD__ or lt==__OPEN_BREAKET__))--unary or binary
            rez={tp,not un and pd[1],un and pd[2]}--inser operator data handle
        else
            rez={tp}
        end
        c[#c+1]=rez --TODO: AFFECT/IGNORE
    end,
    reg=function(tp,id,...)--reg custom value in specific field
        local rez = args and {tp,...} or {tp}
        insert(c,id or #c+1,rez)
    end,
    del=function(id)--del specific value from index
        return remove(c,id or #c+1)
    end,
    tb_until=function(type_tab,i)--thaceback_until:
        i=i or#c+1
        repeat i=i-1 until i<1 or type_tab[c[i][1]]
        return i,c[i]
    end,
    tb_while=function(type_tab,i)--thaceback_while:
        i=i or#c
        while i>0 and type_tab[c[i][1]]do i=i-1 end
        return i,c[i]
    end, {__COMMENT__}
    }
    Control.Cdata=c
    insert(Control.Clear,clr)
end