local Sm,Ti,Tr,Tu=ENV(2,7,9,10)local placeholder_table,t={},Cdata.skip_tb
Event.reg("lvl_close",function(l)if l.OP_st then
local i=#Cdata
for k=#l.OP_st,1,-1 do
Cssc.inject(i,")",10,l.OP_st[k][4])end
end
end,"OP_st_f",1)Event.reg(2,function()local l,c,s=Level[#Level],Cdata[#Cdata]s=l.OP_st
if s and c[2]then
while#s>0 and c[2]<=s[#s][2]do
Cssc.inject(#Cdata,")",10,Tr(s)[4])end
end
end,"OP_st_d",1)Cssc.op_conf=function(T,P,U,S,N,i)local l,c,s,p=Level[#Level]i=i or#Cdata
c,s,T=Cdata[i],l.OP_st or{},T or{}p=#s>0 and s[#s][4]or l.index
if not U then
while i>p and not(c[1]==2 and(c[2]or c[3])<P)do
i=(Level.data[Sm(Result[i],"%S+")]or placeholder_table)[2]and c[2]or i-1
c=Cdata[i]end
else
_,c=Cdata.tb_while(t,i-1)end
if i<p then C.error("OP_STACK Unexpected Ge!")end
i=i+1
if not S then
Cssc.inject(i,"(",9)if#T>0 then
Cssc.inject(i,"",2,Cdata.opts[":"][1])end
for k=#T,1,-1 do
Cssc.inject(i,Tu(T[k]))end
end
if N then
Cssc.inject(")",10)return i-1,c
end
Ti(s,{#Cdata,P,i,i+#T})l.OP_st=s
return i-1,c
end