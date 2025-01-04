local sub,insert,remove,pairs=ENV(6,7,9,13)
--LEVELING SYSTEM
local fin_obj,clear_func,l={["main"]=1}
clear_func=function()for i=1,#l do l[i]=nil end l[1]={type="main",index=1,ends=fin_obj}end

l={{type="main",index=1,ends=fin_obj},
	data=..., --first argument must be level hash
	fin=function()
		if#l<2 then l.close("main",nil,fin_obj)
		else C.error("Can't close 'main' level! Found (%d) unfinished levels!",#l-1)end
	end,
	close=function(obj,no_close,is_fin)
		is_fin=is_fin==fin_obj and fin_obj or{}
		local Lvl,l_ends,r=remove(l)
		if is_fin~=fin_obj and#l<1 then C.error("Attempt to close 'main'(%d) level with '%s'!",#l+1,obj) insert(l,Lvl) return end
		l_ends=Lvl.ends or is_fin--setup level ends/fins
		if l_ends[obj]then Event.run("lvl_close",Lvl,obj)return --Level end found! Invoke close event and return!
		elseif no_close then return end -- level is standalone [like "do" kwrd] and can be opened without closeing prewious
		--Unexpected end! Push error
		r="'"for k in pairs(l_ends)do r=r..k.."' or '"end r=sub(r,1,-6)
		C.error(#r>0 and"Expected %s to close '%s' but got '%s'!"or"Attempt to close level with no ends!",r,Lvl.type,obj)
	end,
	open=function(obj,ends,l_index)
		if#l<1 then C.error("Attempt to open new level '%s' after closing 'main'!",obj)return end
		local Lvl={type=obj,index=l_index or #Result,ends=ends or(l.data[obj]or{})[1]}
		Event.run("lvl_open",Lvl)
		insert(l,Lvl)
	end,
	ctrl=function(obj)
		local t=l.data[obj]
		_=t and(t[2]and l.close(obj,t[3])or t[1]and l.open(obj,t[1]))
		if not t and l[#l].ends[obj]then l.close(obj)end --custom ends
	end
}
C.Level=l
clear_func()

insert(Clear,clear_func)
