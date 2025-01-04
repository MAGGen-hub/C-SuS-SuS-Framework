local E,n,SG,Sm,Ss,Ti,Tc,Gs,Gn="Number '%s' isn't a valid number!",-(0/0),ENV(1,2,6,7,8,15,16)local fin_num=function(N,B)N=Tc(N)local F,f,e,r=Sm(N,"..(%d*)%.?(%d*)(.*)")if Sm(e,"^[Ee]")then C.error(E,N)end
B=(B=="b"or B=="B")and 2 or 8
F=Gn(#F>0 and F or 0,B)if#f>0 then
r=0
for i,k in SG(f,"()(.)")do
if Gn(k)>=B then f=n break end
r=r+k*B^(#f-i)end
f=f==f and Gs(r/B^#f)else f=0 end
e=Gn(#e>0 and Ss(e,2)or 0,10)N=(F and f==f and e)and""..(F+f)*(2^e)or C.error(E,N)or N
Ti(Result,N)Core(6,N)end
Ti(Struct,2,function()local M=#C.operator<1 and Sm(C.word,"^0([OoBb])%d")if M then
local N,d={},{0 ..M.."%d","PpEe"}if Text.get_num_prt(N,d)then fin_num(N,M)return true end
Iterator()if C.operator=="."then
N[#N+1]="."d[1]="%d"Text.get_num_prt(N,d)end
fin_num(N,M)return true
end
end)