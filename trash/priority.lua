function(Control,opts_hash,affect)--PRIORITY SYSTEM,priority value structure {priority, index in result table}
        --Control:load_lib("common.level",level_hash or{})
        local l,p=Control.Level
        Control.Event.reg("lvl_open",function(lvl)lvl.pr_seq={{1,lvl.index,1},prew={__OPERATOR__,1}}end,nil,1)--add field to lvl constructor
        p={data=opts_hash,lang_affect=affect,
        reg=function(prior,is_unary,off)insert(l[#l].pr_seq,{prior,#Control.Result-(off or 0),is_unary})end,--register new priority entity
        unary=function(op)return op[2]and(0>op[2]and op[1]or(l[#l].pr_seq.prew==__OPERATOR__ or l[#l].pr_seq.prew==__OPEN_BREAKET__)and op[2])end,--check curent operator type and return unary priority if exist
        run=function(obj,tp)
            if not p:lang_affect(obj,tp)then--affect priority sequecne using language statement rules
                if tp==__OPERATOR__ then
                    local op,u=p.data[obj]
                    u=p.unary(op)
                    p.reg(u or op[1],u)
                end
            end
            --TODO:set prew val (prewious) l[#l].pr_seq.prew
            l[#l].pr_seq.prew=tp~=__COMMENT__ and {tp,#Control.Result} or l[#l].pr_seq.prew
        end}
        Control.Priority=p
        Control.Level[1].pr_seq={{1,1,1},prew={__OPERATOR__,1}}
        insert(Control.Clear,function()Control.Level[1].pr_seq={{1,1,1},prew={__OPERATOR__,1}}end)
    end