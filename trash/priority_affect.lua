function(Control)
	local l = Control.Level
            return __RESULTABLE__, function(p,obj,tp)
            	--require"cc.pretty".pretty_print(l[#l].pr_seq)
                local pt,pi=unpack(l[#l].pr_seq.prew) --TODO! INJECT CALLS AND INDEXES!!!
                if pt~=__OPERATOR__ and(tp==__VALUE__ or tp==__WORD__)or(pt==__VALUE__ or pt==__NUMBER__)and(tp==__OPEN_BREAKET__ or tp==__STRING__)then
                    p.reg(1,1,1) --mark end of statement
                    Control.Event.run("stat_end",obj,tp,pt,pi)
                end
                if(pt==__WORD__ or pt==__STRING__ or pt==__OPEN_BREAKET__)and(tp==__STRING__ or tp==__OPEN_BREAKET__) then
                	p.reg(Control.Priority.data["."],1)
                end
            end
        end