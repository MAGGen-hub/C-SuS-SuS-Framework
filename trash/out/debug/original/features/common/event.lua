local insert,remove,type,pairs,clear_func,e=ENV(7,9,12,13)
--EVENT SYSTEM
clear_func=function()e.temp={}end
e={main={},
reg=function(name,ev_func,index,is_global)--index here to control order
	local list=is_global and e.temp[name] or e.main[name] or{}
	index=index or#list+1
	if"number"==type(index)then insert(list,index,ev_func)else list[index]=ev_func end
	e[is_global and"main"or"temp"][name]=list
	return index
end,
run=function(name,...)--run all registered functions with args
	local list,del_marked=e.temp[name]or{},{}
	for k,v in pairs(e.main[name]or{})do v(...)end--global events
	for k,v in pairs(list)do del_marked[k]=v(...)end--local events
	for k in pairs(del_marked)do 
		if"number"==type(k)then remove(list,k)else list[k]=nil end--events cleanup
	end
end}
clear_func()--make temp event table
C.Event=e
insert(Clear,clear_func)
