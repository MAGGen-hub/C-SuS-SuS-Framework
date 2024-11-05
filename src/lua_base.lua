local lua51=[[K
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
,
=
or
and
< > <= >= ~= ==




..
+ -
* / // %
not # -
^
. : [ ( { "
]]
local lua52=function(str)return gsub(str,"B","goto\nB")end--TODO: inject ::label:: structure
local lua53=function(str)return gsub(gsub(str,"\n\n\n\n\n","\n|\n~\n&\n<< >>\n"),"(\n)^"," ~\n")end

local lvl={}
local kwrd={}
local kw={}
local opt={}
local t={}
local p=1
local f={
     K=function(k,...)--keyword parce
        kw[#kw+1]=k
        local t=lvl[k]or{}
        for k,v in pairs{...}do
            v=tonumber(v)--or error("Expected number got: "..v)
            t[1]=t[1]or{}--open lvl
            t[1][kw[v]]=1--expected end
            lvl[kw[v]][2]=1--closing lvl
        end
        kwrd[k]=1
        lvl[k]=t
        Control.Words[k]=make_react(c,__KEYWORD__)
    end,
    B=function(o,c)--breaket parce
        lvl[o]={{[c]=1}}--open with exepected end == c
        lvl[c]={nil,1}--closing
        Control.Operators[o]=make_react(o,__OPEN_BREAKET__)
        Control.Operators[c]=make_react(c,__CLOSE_BREAKET__)
    end,
    V=function(v)--value parce
        Control[match(v,"%w")and"Words"or"Operators"][v]=make_react(v,__VALUE__)
    end,
    O=function(...)--opt parce
        for k,v in pairs{...}do if""~=v then
            opt[v]=opt[v]and{opt[v][1],p}or{p}
            Control.Operators[v]=make_react(v,__OPERATOR__)
        end end
        p=p+1--increade priority
    end
}
load_stx=function(str,f)
    local mode,t=function()end,{}
    for o,s in gmatch(str,"(.-)(%s)")do
        t[#t+1]=o
        if s=="\n"then
            mode=#t==1 and f[o]or mode(unpack(t))or mode
            t={}
        end
    end
end
