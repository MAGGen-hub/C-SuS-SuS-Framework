local Sm,SF,Sg,Ss,Ti,Tc,Tu=ENV(2,3,5,6,7,8,10)Text.get_num_prt=function(n,D)local E
n[#n+1],E,C.word=Sm(C.word,SF("^(%s*([%s]?%%d*))(.*)",Tu(D)))C.operator=""if#C.word>0 or#E>1 then return 1 end
if#E>0 then
Iterator()E=Sm(C.operator or"","^[+-]$")if E then
n[#n+1]=E
n[#n+1],C.word=Sm(C.word,"^(%d*)(.*)")C.operator=""end
return 1
end
end
local N,split_seq=function()local m,d=Sm(C.word,"^0([Xx])")d=C.operator=="."and not m
if not Sm(C.word,"^%d")or not d and#C.operator>0 then return end
local n,D=d and{"."}or{},m and{"0"..m.."%x","Pp"}or{"%d","Ee"}if Text.get_num_prt(n,D)or"."==n[1]then return n end
Iterator()if C.operator=="."then
n[#n+1]="."D[1]=Ss(D[1],-2)Text.get_num_prt(n,D)end
return n
end,Text.split_seq
Ti(Struct,function()local c,r,m,l,s=#C.operator>0 and"operator"or"word"if#C.operator>0 then
r,c,l={},Sm(C.operator,"^(-?)%1%[(=*)%[")c=Sm(C.operator,"^-%-")s=Sm(C.operator,"^['\"]")if l then
l="%]"..l.."()%]"repeat
if split_seq(r,Sm(C.operator,l))then m=c and 11 or 7 break end
Ti(r,C.word)until Iterator()elseif s then
split_seq(r,1)s="(\\*()["..s.."\n])"while C.index do
c,m=Sm(C.operator,s)if split_seq(r,m)then
m=Sm(c,"\n$")l=l or m
if#c%2>0 then m=not m and 7 break end
else
if split_seq(r,Sm(C.word,"()\n"),1)then break end
Iterator()end
end
elseif c then
repeat
if split_seq(r,Sm(C.operator,"()\n"))or split_seq(r,Sm(C.word,"()\n"),1)then C.line=C.line+1 break end
until Iterator()m=11
else
r=N()m=r and 6
end
elseif#C.word>0 then
r=N()m=r and 6
end
if r then
r=Tc(r)if l then
r,c=Sg(r,"\n",{})C.line=C.line+c
end
Result[#Result+1]=r
Core(m or 12,r)return true
end
end)