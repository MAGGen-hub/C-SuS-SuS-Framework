local type_string='string'
local keywords_base = {}
local keywords_ids = {}
for k in string.gmatch("if function for while repeat elseif else do then end until local return in break ","%S+")do keywords_base[#keywords_base+1]=k end
-- {open_lvl,close_lvl,level_ends}
for k,v,e in pairs(keywords_base) do
    e = keywords_base[({9,10,8,8,11,9,10,10})[k]or 0]
    keywords_ids[v]={k==9 and{["else"]=1,["elseif"]=1,["end"]=1}or e and {[e]=1} or nil,k>5 and k<12}
end --data_struct = {open_lvl_with_ends,close_lvl}

require"cc.pretty".pretty_print(keywords_ids)

local opts_base = {}
local opts_ids = {}
local i = 0
for k,v in string.gmatch([[;
,
=
or
and
< > <= >= ~= ==
|
~
&
<< >>
..
+ -
* / // %
not # - ~
^
. : [ ( { " ]],'(%S+)(.)')do --basic operator pull
    opts_base[i] = opts_base[i] or {}
    opts_base[i][#opts_base[i]+1]=k
    opts_ids[k]= opts_ids[k] and {opts_ids[k][1],i} or {i}
    i = v=="\n"and i+1 or i
end --data_struct = {priority,unary_priority or -1}   if unary_priority==-1 that means -> only unary operator exist
opts_ids["not"][2]=-1
opts_ids["#"][2]=-1

require"cc.pretty".pretty_print(opts_base)

--comment and string detector
local cstd = function(x,mk_err,err)
    local data,max = {},0
    local func = function(i,c)
        gsub(c,"()\0",function(j)return remove(data,i+j)end)
        data[i]=c
        max=i>max and i or max
        local new_data,ml = {},-#c+1
        for k,v in pairs(data)do new_data[k>i and k-ml or k]=v end
        data=new_data
        return"\0"
    end
    gsub(x,"()\0",function(x)data[x]="\0"end)--zeros
    gsub(x,"()((-?)%3(%[(=*)%[.-%]%3%]))",func)--long comments and strings
    gsub(x,"()(-%-[^\n]+\n?)",func)            --small comments
    gsub(x,[[()((["']).-[^\](\-)%4%3))]],func) --small string
    
    gsub(x,"()(['\"].-)",func)--unfinished strings/comments
    gsub(x,"()((-?)%3(%[(=*)%[.-$)",func)
    
    return x
end


