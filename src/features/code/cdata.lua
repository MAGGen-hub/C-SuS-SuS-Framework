function(Control,opts_hash,level_hash,affect_func)--API to save code data to specific table
    local c,clr,skip
    c={opts=opts_hash,lvl=level_hash,affect=affect_func,
    run=function(obj,tp)--to call from core
        local lh,rez=lvl[obj]
        if lh and lh[2] then --object with lvl props
            rez=Control.Level[#Control.Level]
            rez ={tp,rez.ends[lh[2]] and rez.index}
        elseif tp==__OPERATOR__ then
            local pd,lt,un = c.opts[obj],c[#c][1]--priority_data,last_type,is_unary
            un = pd[2] and (not pd[1] or not (lt==__OPERATOR__ or  lt==__KEYWORD__ or lt==__OPEN_BREAKET__))--unary or binary
            rez={tp,not un and pd[1],un and pd[2]}--inser operator data handle
        else
            rez={tp}
        end
        c[#c+1]=rez --TODO: insert val
    end,
    reg=function(tp,id,...)--reg custom value in specific field
        local rez = args and {tp,...} or {tp}
        insert(c,id or #c+1,rez)
    end,
    del=function(id)--del specific value from index
        return remove(c,id or #c+1)
    end, {__OPEN_BREAKET__}
    }
    Control.Cdata=c
end