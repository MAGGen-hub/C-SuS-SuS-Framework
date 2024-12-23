-- C SuS SuS Framework - Minification module
local sub,match,insert,remove,t_swap =ENV(6,2,7,9,24)
--code parceing system
C:load_lib"text.dual_queue.base"
C:load_lib"text.dual_queue.parcer"
C:load_lib"text.dual_queue.iterator"
C:load_lib"text.dual_queue.space_handler"
C:load_lib"code.lua.struct"

local make_react,prew2,prew1,_,arg,kc,kl,r=C:load_lib"text.dual_queue.make_react",5,5,...
Operators[".."]=make_react("..",1)
Operators["..."]=make_react("...",6)
arg=t_swap(arg or{})
kc=arg.keep_comms
kl=arg.keep_lines

C.Core=function(tp,obj)
    --remove comments
    if tp==11 then
        if kc then
            tp=1 --redefine comments as symbols
        else
            remove(Result)
            if prew1==5 then if match(obj,"\n")then Result[#Result]="\n"end return end
            insert(Result," ")
            tp=5
        end
    end
    --minify spaces
    if tp==5 then
        remove(Result)
        if prew1==5 then if match(obj,"\n")then Result[#Result]="\n"end return end
        insert(Result,match(obj,"\n")and"\n"or" ")
    end
    --concatenation fix
    r = Result[#Result-2]
    if prew1==5 and(obj==".."or"..."==obj)and(prew2==6 or r==".."or r=="...") then
        prew2=prew1 prew1=1 return 
    end
    --remove unnesesary spaces
    if prew1==5 then
        if prew2==7 or prew2==1 or (prew2==3 or prew2==6) and (tp==1 or tp==7) then
            if not(kl and Result[#Result-1]=="\n") then
                remove(Result,#Result-1) --space not required
            end
        end
    end
    --save two previous values
    prew2=prew1
    prew1=tp
end
--remove last space
insert(PostRun,function()if prew1==5 then remove(Result)end end)

insert(Clear,function()prew1=5 prew2=5 end)