
local Sm,SF,Tu,Gp,Gn=ENV(2,3,10,13,16)local O,W=...
local l,y,K,x,t,p,L,m,M={},{},{},{},{},1,[[K
end
else 1
elseif
then 1 2 3
do 1
in 5
until
if 4
function 1
for 5 6
while 5
repeat 7
elseif 4
local
return
break
B
{ }
[ ]
( )
V
...
nil
true
false
O
;
=
,
or
and
< > <= >= ~= ==




..
+ -
* / %
not # -
^
. :
]],C:load_libs"text.dual_queue""make_react"(1,-1)M"base"().code"syntax_loader"(3)(L,{K=function(k,...)y[#y+1]=k
t=l[k]or{}for k,v in Gp{...}do
v=Gn(v)t[1]=t[1]or{}t[1][y[v]]=1
l[y[v]][2]=1
end
K[k]=1
l[k]=t
W[k]=m(k,4)end,B=function(o,c)l[o]={{[c]=1}}l[c]={nil,1}O[o]=m(o,9)O[c]=m(c,10)end,V=function(v)(Sm(v,"%w")and W or O)[v]=m(v,8)end,O=function(...)for k,v in Gp{...}do if""~=v then
x[v]=x[v]and{x[v][1],p}or{p}if Sm(v,"%w")then W[v]=W[v]or m(v,2)else O[v]=O[v]or v end
end end
p=p+1
end})l["do"][3],M=1
x["not"]={nil,x["not"][1]}x["#"]={nil,x["#"][1]}return 1,l,x,K