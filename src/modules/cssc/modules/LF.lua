{[_init]=function(Control)
	local pl --posible lambda
	Control.Event.reg("lvl_close",function(lvl)pl=lvl.type=="(" and lvl.index end,"LF",1)
	Control.Event.reg("all",function(o,tp)pl=tp==__COMMENT__ and pl end,"LF",1)
	Control.Operators["->"]=function(Control)
		if pl then insert(Control.Result,pl,"function")-- "(*code*)" located before "->"
		else--default lambda mode
			local pr,ac_pr,i=Control.Level[#Control.Level].pr_seq,Control.Priority.data[","][1]
			i=#pr while pr[i][1]==ac_pr do i,pr[i]=i-1 end
			insert(Control.Result,pr[i][2]+1,"function(")
			insert(Control.Result,")")
		end --TODO: debug "a[dfs],a ->"
		Control.Level.ctrl("function")--open new level as function
		if"-"==sub(Control.operator,1,1)then insert(Control.Result,"return ") Control.Priority.reg(1,1)end
		Control.split_seq(nil,2)
	end
	Control.Operators["=>"]=Control.Operators["->"]
	
end}