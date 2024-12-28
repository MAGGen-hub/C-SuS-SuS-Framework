local Sm,SF,Sg,Ss,Ti,Tc,Tu=ENV(2,3,5,6,7,8,10)Text.get_num_prt=function(nd,f)local ex
nd[#nd+1],ex,C.word=Sm(C.word,SF("^(%s*([%s]?%%d*))(.*)",Tu(f)))C.operator=""if#C.word>0 or#ex>1 then return 1 end
if#ex>0 then
Iterator()ex=Sm(C.operator or"","^[+-]$")if ex then
nd[#nd+1]=ex
nd[#nd+1],C.word=Sm(C.word,"^(%d*)(.*)")C.operator=""end
return 1
end
end
local get_number,split_seq=function()local c,d=Sm(C.word,"^0([Xx])")d=C.operator=="."and not c
if not Sm(C.word,"^%d")or not d and#C.operator>0 then return end
local num_data,f=d and{"."}or{},c and{"0"..c.."%x","Pp"}or{"%d","Ee"}if Text.get_num_prt(num_data,f)or"."==num_data[1]then return num_data end
Iterator()if C.operator=="."then
num_data[#num_data+1]="."f[1]=Ss(f[1],-2)Text.get_num_prt(num_data,f)end
return num_data
end,Text.split_seq
Ti(Struct,function()local com,rez,mode,lvl,str=#C.operator>0 and"operator"or"word"if#C.operator>0 then
rez,com,lvl={},Sm(C.operator,"^(-?)%1%[(=*)%[")com=Sm(C.operator,"^-%-")str=Sm(C.operator,"^['\"]")if lvl then
lvl="%]"..lvl.."()%]"repeat
if split_seq(rez,Sm(C.operator,lvl))then mode=com and 11 or 7 break end
Ti(rez,C.word)until Iterator()elseif str then
split_seq(rez,1)str="(\\*()["..str.."\n])"while C.index do
com,mode=Sm(C.operator,str)if split_seq(rez,mode)then
mode=Sm(com,"\n$")lvl=lvl or mode
if#com%2>0 then mode=not mode and 7 break end
else
if split_seq(rez,Sm(C.word,"()\n"),1)then break end
Iterator()end
end
elseif com then
repeat
if split_seq(rez,Sm(C.operator,"()\n"))or split_seq(rez,Sm(C.word,"()\n"),1)then C.line=C.line+1 break end
until Iterator()mode=11
else
rez=get_number()mode=rez and 6
end
elseif#C.word>0 then
rez=get_number()mode=rez and 6
end
if rez then
rez=Tc(rez)if lvl then
rez,com=Sg(rez,"\n",{})C.line=C.line+com
end
Result[#Result+1]=rez
Core(mode or 12,rez)return true
end
end)