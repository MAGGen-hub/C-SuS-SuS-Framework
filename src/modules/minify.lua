-- C SuS SuS Framework - Minification module
local sub,match,insert,remove,t_swap =ENV(__ENV_SUB__,__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_T_SWAP__)
--code parceing system
C:load_lib"text.dual_queue.base"
C:load_lib"text.dual_queue.parcer"
C:load_lib"text.dual_queue.iterator"
C:load_lib"text.dual_queue.space_handler"
C:load_lib"code.lua.struct"

local make_react,prew2,prew1,_,arg,kc,kl,r=C:load_lib"text.dual_queue.make_react",__SPACE__,__SPACE__,...
Operators[".."]=make_react("..",__SYMBOL__)
Operators["..."]=make_react("...",__NUMBER__)
arg=t_swap(arg or{})
kc=arg.keep_comms
kl=arg.keep_lines

C.Core=function(tp,obj)
    --remove comments
    if tp==__COMMENT__ then
        if kc then
            tp=__SYMBOL__ --redefine comments as symbols
        else
            remove(Result)
            if prew1==__SPACE__ then if match(obj,"\n")then Result[#Result]="\n"end return end
            insert(Result," ")
            tp=__SPACE__
        end
    end
    --minify spaces
    if tp==__SPACE__ then
        remove(Result)
        if prew1==__SPACE__ then if match(obj,"\n")then Result[#Result]="\n"end return end
        insert(Result,match(obj,"\n")and"\n"or" ")
    end
    --concatenation fix
    r = Result[#Result-2]
    if prew1==__SPACE__ and(obj==".."or"..."==obj)and(prew2==__NUMBER__ or r==".."or r=="...") then
        prew2=prew1 prew1=__SYMBOL__ return 
    end
    --remove unnesesary spaces
    if prew1==__SPACE__ then
        if prew2==__STRING__ or prew2==__SYMBOL__ or (prew2==__WORD__ or prew2==__NUMBER__) and (tp==__SYMBOL__ or tp==__STRING__) then
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
insert(PostRun,function()if prew1==__SPACE__ then remove(Result)end end)

insert(Clear,function()prew1=__SPACE__ prew2=__SPACE__ end)