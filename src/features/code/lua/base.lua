-- LUA LANGUAGE SYNTAX AND DATA API
-- provides: keywords
-- code blocks (leveling) data
-- operators priority
local match,format,unpack,pairs,tonumber = ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_UNPACK__,__ENV_PAIRS__,__ENV_TONUMBER__)
local O,W=...-- O - Control.Operators or other table; W - Control.Words or other table (depends on current text parceing system)
--BASE LUA SYNTAX STRING (keywords/operators/breakets/values)
local lvl,l_kw,kwrd,opt,t,p,lua51,l_make_react,libruary_loader={},{},{},{},{},1,
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
libruary_loader"base"().code"syntax_loader"(3)(lua51,{
     K=function(k,...)--keyword parce
        l_kw[#l_kw+1]=k
        t=lvl[k]or{}
        for k,v in pairs{...}do
            v=tonumber(v)--or error("Expected number got: "..v)
            t[1]=t[1]or{}--open lvl
            t[1][l_kw[v]]=1--expected end
            lvl[l_kw[v]][2]=1--closing lvl
        end
        kwrd[k]=1
        lvl[k]=t
        W[k]=l_make_react(k,__KEYWORD__)
    end,
    B=function(o,c)--breaket parce
        lvl[o]={{[c]=1}}--open with exepected end == c
        lvl[c]={nil,1}--closing
        O[o]=l_make_react(o,__OPEN_BREAKET__)
        O[c]=l_make_react(c,__CLOSE_BREAKET__)
    end,
    V=function(v)--value parce
        (match(v,"%w")and W or O)[v]=l_make_react(v,__VALUE__)
    end,
    O=function(...)--opt parce
        for k,v in pairs{...}do if""~=v then
            opt[v]=opt[v]and{opt[v][1],p}or{p}
            if match(v,"%w")then W[v]=W[v] or l_make_react(v,__OPERATOR__)
            else O[v]=O[v] or v end
        end end
        p=p+1--increade priority
    end
})
lvl["do"][3],libruary_loader=1 --do can be standalone level and init block on it's own
opt["not"]={nil,opt["not"][1]}--unary opts fix
opt["#"]={nil,opt["#"][1]}

return __RECALLABLE__,lvl,opt,kwrd--(leveling_hash,operator_hash<with_priority>,keywrod_hash)