local Ti,Tr,Gt,Gp=ENV(7,9,12,13)local clr,e
clr=function()e.temp={}end
e={main={},reg=function(name,func,id,gl)local l=gl and e.temp[name]or e.main[name]or{}id=id or#l+1
if"number"==Gt(id)then Ti(l,id,func)else l[id]=func end
e[gl and"main"or"temp"][name]=l
return id
end,run=function(name,...)local l,rm=e.temp[name]or{},{}for k,v in Gp(e.main[name]or{})do v(...)end
for k,v in Gp(l)do rm[k]=v(...)end
for k in Gp(rm)do
if"number"==Gt(k)then Tr(l,k)else l[k]=nil end
end
end}clr()C.Event=e
Ti(Clear,clr)