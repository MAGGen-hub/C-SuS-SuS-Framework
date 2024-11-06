function(Control,opts_hash,affect_func)--API to save code data to specific table
    local c,clr,skip
    Control.Event.reg("lvl_close",function(lvl,obj)end)
    c={data=opts_hash,affect=affect_func,
    run=function(obj,tp)--to call from core
        if tp==__OPERATOR__ then
            local pd,lt,pr = c.data[obj],c[#c][1]--priority_dtat,last_type,priority
            --calculate priority
            pr = 0>pd[2] and -pd[1] or (lt==__OPERATOR__ or  lt==__KEYWORD__ or lt==__OPEN_BREAKET__) and -pd[2] or pd[1]
            c[#c+1]={tp,pr}
        elseif 
        c[#c+1]= --TODO: insert val
    end,
    reg=function(tp,args,id)--reg custom value in specific field
        if args then --TODO: insert args
        end
    end,
    del=function(id)--del specific value from index
    end, {__OPEN_BREAKET__}
    }
    Control.Cdata=c
end--System TODO: level auto indexing
-- {type,}
-- {__OPERATOR__, }