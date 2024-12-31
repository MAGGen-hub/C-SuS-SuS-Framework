local Ti,Tr,Gt,Gp,c,e=ENV(7,9,12,13)c=function()e.temp={}end
e={main={},reg=function(n,f,i,g)local l=g and e.temp[n]or e.main[n]or{}i=i or#l+1
if"number"==Gt(i)then Ti(l,i,f)else l[i]=f end
e[g and"main"or"temp"][n]=l
return i
end,run=function(n,...)local l,d=e.temp[n]or{},{}for k,v in Gp(e.main[n]or{})do v(...)end
for k,v in Gp(l)do d[k]=v(...)end
for k in Gp(d)do
if"number"==Gt(k)then Tr(l,k)else l[k]=nil end
end
end}c()C.Event=e
Ti(Clear,c)