
local Ti,Tr,TS=ENV(7,9,23)local check,c,clr=TS{2,4,9}clr=function()for i=1,#c do c[i]=nil end c[1]={2,0}end
c={run=function(obj,tp)local lh,rez=c.lvl[obj]if lh and lh[2]then
rez=Level[#Level]rez={tp,rez.ends[obj]and rez.index}elseif tp==2 then
local pd,lt,un=c.opts[obj],c[#c][1]un=pd[2]and(not pd[1]or not check[lt])rez={tp,not un and pd[1],un and pd[2]}else
rez={tp}end
c[#c+1]=rez
end,reg=function(tp,id,...)local rez={tp,...}Ti(c,id or#c+1,rez)end,del=function(id)return Tr(c,id or#c+1)end,skip_tb=TS{11,5},tb_until=function(type_tab,i)i=i or#c+1
repeat i=i-1 until i<1 or type_tab[c[i][1]]return i,c[i]end,tb_while=function(type_tab,i)i=i or#c
while i>0 and type_tab[c[i][1]]do i=i-1 end
return i,c[i]end,get_priority=function(obj,unary)return(c.opts[obj]or{})[unary and 2 or 1]end,is_keyword=function(obj)return c.kwrd[obj]end,{2,0}}c.opts,c.lvl,c.kwrd=...
C.Cdata=c
Ti(Clear,clr)