-- LUA LANGUAGE SYNTAX AND DATA API
-- provides: keywords
-- code blocks (leveling) data
-- operators priority
local match,format,unpack,pairs,tonumber = ENV(2,3,10,14,17)
local O,W=...-- O - Control.Operators or other table; W - Control.Words or other table (depends on current text parceing system)
--BASE LUA SYNTAX STRING (keywords/operators/breakets/values)
local lvl,kw,kwrd,opt,t,p,lua51,make_react,ll={},{},{},{},{},1,
[[K
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
]],-- [ ( { "
C:load_libs"text.dual_queue""make_react"(1,-1)
--TODO: INSERT VERSION DIFF
ll"base"().code"syntax_loader"(3)(lua51,{
     K=function(k,...)--keyword parce
        kw[#kw+1]=k
        t=lvl[k]or{}
        for k,v in pairs{...}do
            v=tonumber(v)--or error("Expected number got: "..v)
            t[1]=t[1]or{}--open lvl
            t[1][kw[v]]=1--expected end
            lvl[kw[v]][2]=1--closing lvl
        end
        kwrd[k]=1
        lvl[k]=t
        W[k]=make_react(k,4)
    end,
    B=function(o,c)--breaket parce
        lvl[o]={{[c]=1}}--open with exepected end == c
        lvl[c]={nil,1}--closing
        O[o]=make_react(o,9)
        O[c]=make_react(c,10)
    end,
    V=function(v)--value parce
        (match(v,"%w")and W or O)[v]=make_react(v,8)
    end,
    O=function(...)--opt parce
        for k,v in pairs{...}do if""~=v then
            opt[v]=opt[v]and{opt[v][1],p}or{p}
            if match(v,"%w")then W[v]=W[v] or make_react(v,2)
            else O[v]=O[v] or v end
        end end
        p=p+1--increade priority
    end
})
lvl["do"][3],ll=1 --do can be standalone level and init block on it's own
opt["not"]={nil,opt["not"][1]}--unary opts fix
opt["#"]={nil,opt["#"][1]}

return 1,lvl,opt,kwrd--(leveling_hash,operator_hash<with_priority>,keywrod_hash)