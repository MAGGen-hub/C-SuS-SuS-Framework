local format = string.format
local gsub = string.gsub
local native_load=load
local concat=table.concat

local Configs = {cssc="maggen.cssc=Lambda.Condition.DefArgs.Peprocess ,sys={pre,dbg},dbg"}

local p=require"cc.pretty".pretty_print
local func
func=function(s)
    local c,t,l,e={"config"}--config mark!
    l,e=native_load(gsub(format("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,setmetatable({},{__index=function(s,i)return setmetatable(i==c[1]and c or{i},{__index=function(s,i)s=s==c and{c[1]}or s s[#s+1]=i return s end}) end}))
    l=e and error(format("Invalid control string: <%s> -> %s",s,e))or l()
    s,l[c]=l[c]
    t,e=pcall(concat,s)
    e=Configs[t and e or s]
    for k,v in pairs(e and func(e)or{})do l["number"==type(k)and#l+1 or k]=v end
    return l
end

local t = func"config=cssc,A,B,C={N,R,C},A=a,F.F.F.F={config,A}"
p(t)
print("--||--")
t = func"A,B,C={N,R,C},A,config={cssc}"
--print(pcall(concat,{{}}))
p(t)
_G.func=func
