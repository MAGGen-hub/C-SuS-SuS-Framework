
local Ti,Tr,TS=ENV(7,9,23)local x,c,E=TS{2,4,9}E=function()for i=1,#c do c[i]=nil end c[1]={2,0}end
c={run=function(o,t)local l,rez=c.lvl[o]if l and l[2]then
rez=Level[#Level]rez={t,rez.ends[o]and rez.index}elseif t==2 then
local p,L,u=c.opts[o],c[#c][1]u=p[2]and(not p[1]or not x[L])rez={t,not u and p[1],u and p[2]}else
rez={t}end
c[#c+1]=rez
end,reg=function(t,i,...)local rez={t,...}Ti(c,i or#c+1,rez)end,del=function(i)return Tr(c,i or#c+1)end,skip_tb=TS{11,5},tb_until=function(T,i)i=i or#c+1
repeat i=i-1 until i<1 or T[c[i][1]]return i,c[i]end,tb_while=function(T,i)i=i or#c
while i>0 and T[c[i][1]]do i=i-1 end
return i,c[i]end,get_priority=function(o,u)return(c.opts[o]or{})[u and 2 or 1]end,is_keyword=function(o)return c.kwrd[o]end,{2,0}}c.opts,c.lvl,c.kwrd=...
C.Cdata=c
Ti(Clear,E)