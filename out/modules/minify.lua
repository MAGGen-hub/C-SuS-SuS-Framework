
local make_react,Ss,Sm,Ti,Tr,TS=C:load_libs"text.dual_queue""base""parcer""iterator""make_react""space_handler"()"code.lua.struct"(4),ENV(6,2,7,9,23)local prew2,prew1,_,arg,kc,kl,r=5,5,...
Operators[".."]=make_react("..",1)Operators["..."]=make_react("...",6)arg=TS(arg or{})kc,kl=arg.keep_comms,arg.keep_lines
C.Core=function(tp,obj)if tp==11 then
if kc then tp=1
else
Tr(Result)if prew1==5 then if Sm(obj,"\n")then Result[#Result]="\n"end return end
Ti(Result," ")tp=5
end
end
if tp==5 then
Tr(Result)if prew1==5 then if Sm(obj,"\n")then Result[#Result]="\n"end return end
Ti(Result,Sm(obj,"\n")and"\n"or" ")end
r=Result[#Result-2]if prew1==5 and(obj==".."or"..."==obj)and(prew2==6 or r==".."or r=="...")then
prew2=prew1 prew1=1 return
end
if prew1==5 and(prew2==7 or prew2==1 or(prew2==3 or prew2==6)and(tp==1 or tp==7))then
if not(kl and Result[#Result-1]=="\n")then Tr(Result,#Result-1)end
end
prew2=prew1
prew1=tp
end
Ti(PostRun,function()if prew1==5 then Tr(Result)end end)Ti(Clear,function()prew1=5 prew2=5 end)