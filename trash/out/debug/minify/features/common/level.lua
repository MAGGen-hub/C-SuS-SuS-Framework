local Ss,Ti,Tr,Gp=ENV(6,7,9,13)local F,c,l={["main"]=1}c=function()for i=1,#l do l[i]=nil end l[1]={type="main",index=1,ends=F}end
l={{type="main",index=1,ends=F},data=...,fin=function()if#l<2 then l.close("main",nil,F)else C.error("Can't close 'main' level! Found (%d) unfinished levels!",#l-1)end
end,close=function(o,n,f)f=f==F and F or{}local L,e,r=Tr(l)if f~=F and#l<1 then C.error("Attempt to close 'main'(%d) level with '%s'!",#l+1,o)Ti(l,L)return end
e=L.ends or f
if e[o]then Event.run("lvl_close",L,o)return
elseif n then return end
r="'"for k in Gp(e)do r=r..k.."' or '"end r=Ss(r,1,-6)C.error(#r>0 and"Expected %s to close '%s' but got '%s'!"or"Attempt to close level with no ends!",r,L.type,o)end,open=function(o,ends,l_index)if#l<1 then C.error("Attempt to open new level '%s' after closing 'main'!",o)return end
local L={type=o,index=l_index or#Result,ends=ends or(l.data[o]or{})[1]}Event.run("lvl_open",L)Ti(l,L)end,ctrl=function(o)local t=l.data[o]_=t and(t[2]and l.close(o,t[3])or t[1]and l.open(o,t[1]))if not t and l[#l].ends[o]then l.close(o)end
end}C.Level=l
c()Ti(Clear,c)