local e,nan,SG,Sm,Ss,Ti,Tc,Gs,Gn="Number '%s' isn't a valid number!",-(0/0),ENV(1,2,6,7,8,15,16)local fin_num=function(nd,c)nd=Tc(nd)local f,s,ex,r=Sm(nd,"..(%d*)%.?(%d*)(.*)")if Sm(ex,"^[Ee]")then C.Ge(e,nd)end
c=(c=="b"or c=="B")and 2 or 8
f=Gn(#f>0 and f or 0,c)if#s>0 then
r=0
for i,k in SG(s,"()(.)")do
if Gn(k)>=c then s=nan break end
r=r+k*c^(#s-i)end
s=s==s and Gs(r/c^#s)else s=0 end
ex=Gn(#ex>0 and Ss(ex,2)or 0,10)nd=(f and s==s and ex)and""..(f+s)*(2^ex)or C.Ge(e,nd)or nd
Ti(Result,nd)Core(6,nd)end
Ti(Struct,2,function()local c=#C.operator<1 and Sm(C.word,"^0([OoBb])%d")if c then
local num_data,f={},{0 ..c.."%d","PpEe"}if Text.get_num_prt(num_data,f)then fin_num(num_data,c)return true end
Iterator()if C.operator=="."then
num_data[#num_data+1]="."f[1]="%d"Text.get_num_prt(num_data,f)end
fin_num(num_data,c)return true
end
end)