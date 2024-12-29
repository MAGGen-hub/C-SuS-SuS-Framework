local Sm,Ti,Tr,Tu=ENV(2,7,9,10)local pht,tb={},Cdata.skip_tb
Event.reg("lvl_close",function(lvl)if lvl.OP_st then
local i=#Cdata
for k=#lvl.OP_st,1,-1 do
Cssc.inject(i,")",10,lvl.OP_st[k][4])end
end
end,"OP_st_f",1)Event.reg(2,function(obj,tp)local lvl,cdt,st,cst=Level[#Level],Cdata[#Cdata]st=lvl.OP_st
if st and cdt[2]then
while#st>0 and cdt[2]<=st[#st][2]do
cst=Tr(st)Cssc.inject(#Cdata,")",10,cst[4])end
end
end,"OP_st_d",1)Cssc.op_conf=function(pre_tab,priority,is_unary,skip_fb,now_end,id)local lvl,i,cdt,b,st,sp,last=Level[#Level],id or#Cdata
cdt,st,pre_tab=Cdata[i],lvl.OP_st or{},pre_tab or{}sp=#st>0 and st[#st][4]or lvl.index
if not is_unary then
while i>sp and not(cdt[1]==2 and(cdt[2]or cdt[3])<priority)do
i=(Level.data[Sm(Result[i],"%S+")]or pht)[2]and cdt[2]or i-1
cdt=Cdata[i]end
last=cdt
else
_,last=Cdata.tb_while(tb,i-1)end
if i<sp then Control.error("OP_STACK Unexpected Ge!")end
i=i+1
if not skip_fb then
Cssc.inject(i,"(",9)if#pre_tab>0 then
Cssc.inject(i,"",2,Cdata.opts[":"][1])end
for k=#pre_tab,1,-1 do
Cssc.inject(i,Tu(pre_tab[k]))end
end
if now_end then
Cssc.inject(")",10)return i-1,last
end
Ti(st,{#Cdata,priority,i,i+#pre_tab})lvl.OP_st=st
return i-1,last
end