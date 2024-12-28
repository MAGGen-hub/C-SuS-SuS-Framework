
local Sm,SF,Tu,Gp,Gn=ENV(2,3,10,13,16)local O,W=...
local lvl,kw,kwrd,opt,t,p,lua51,make_react,ll={},{},{},{},{},1,[[K
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
]],C:load_libs"text.dual_queue""make_react"(1,-1)ll"base"().code"syntax_loader"(3)(lua51,{K=function(k,...)kw[#kw+1]=k
t=lvl[k]or{}for k,v in Gp{...}do
v=Gn(v)t[1]=t[1]or{}t[1][kw[v]]=1
lvl[kw[v]][2]=1
end
kwrd[k]=1
lvl[k]=t
W[k]=make_react(k,4)end,B=function(o,c)lvl[o]={{[c]=1}}lvl[c]={nil,1}O[o]=make_react(o,9)O[c]=make_react(c,10)end,V=function(v)(Sm(v,"%w")and W or O)[v]=make_react(v,8)end,O=function(...)for k,v in Gp{...}do if""~=v then
opt[v]=opt[v]and{opt[v][1],p}or{p}if Sm(v,"%w")then W[v]=W[v]or make_react(v,2)else O[v]=O[v]or v end
end end
p=p+1
end})lvl["do"][3],ll=1
opt["not"]={nil,opt["not"][1]}opt["#"]={nil,opt["#"][1]}return 1,lvl,opt,kwrd