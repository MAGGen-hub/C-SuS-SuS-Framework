-- LUA LANGUAGE SYNTAX AND DATA API
-- provides: keywords
-- code blocks (leveling) data
-- operators priority
local match,format,unpack,pairs,tonumber = ENV(2,3,10,14,17)
local O,W=...-- O - Control.Operators or other table; W - Control.Words or other table (depends on current text parceing system)
--BASE LUA SYNTAX STRING (keywords/operators/breakets/values)
local make_react,lvl,kw,kwrd,opt,t,p,lua51=C:load_lib"text.dual_queue.make_react",{},{},{},{},{},1,
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
]]-- [ ( { "
--INSERT VERSION DIFF
C:load_lib"text.dual_queue.base"
C:load_lib"code.syntax_loader"(lua51,{
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
lvl["do"][3]=1 --do can be standalone level and init block on it's own
opt["not"]={nil,opt["not"][1]}--unary opts fix
opt["#"]={nil,opt["#"][1]}

Text.get_num_prt = function(nd,f) --function that collect number parts into num_data. 
	local ex                            --Returns 1 if end of number found or nil if floating point posible
	nd[#nd+1],ex,C.word=match(C.word,format("^(%s*([%s]?%%d*))(.*)",unpack(f)))--get number part
	C.operator="" -- dot-able number protection (reset operator)
	if#C.word>0 or#ex>1 then return 1 end--finished number or finished exponenta
	if#ex>0 then--unfinished exponenta #ex==1
		Iterator()-- update op_word_seq
		ex=match(C.operator or"","^[+-]$")
		if ex then
			nd[#nd+1]=ex
			nd[#nd+1],C.word=match(C.word,"^(%d*)(.*)")
			C.operator=""
		end --TODO: else push_error() end -> incorrect exponenta prohibited by lua
		return 1
	end --unfinished exponenta #ex==1
end

return 1,lvl,opt,kwrd--(leveling_hash,operator_hash<with_priority>,keywrod_hash)