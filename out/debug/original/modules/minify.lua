-- C SuS SuS Framework - Minification module
local l_make_react,sub,match,insert,remove,t_swap =
C:load_libs"text.dual_queue"--code parceing system
    "base""parser""iterator""make_react""space_handler"()
    "code.lua.struct"(4),ENV(6,2,7,9,23)

local prew2,prew1,_,arg,K,k,r=5,5,...
Operators[".."]=l_make_react("..",1)
Operators["..."]=l_make_react("...",6)
arg=t_swap(arg or{})
K,k=arg.keep_comms,arg.keep_lines

C.Core=function(obj_tp,obj)
    --remove comments
    if obj_tp==11 then
        if K then obj_tp=1 --redefine comments as symbols
        else
            remove(Result)
            if prew1==5 then if match(obj,"\n")then Result[#Result]="\n"end return end
            insert(Result," ")
            obj_tp=5
        end
    end
    --minify spaces
    if obj_tp==5 then
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
    if prew1==5 and(prew2==7 or prew2==1 or(prew2==3 or prew2==6)and(obj_tp==1 or obj_tp==7)) then
        if not(k and Result[#Result-1]=="\n") then remove(Result,#Result-1)end --space not required
    end
    prew2=prew1--save two previous values
    prew1=obj_tp
end
User.info="C SuS SuS Basic minify"
User.version="1.4-beta"
--remove last space
insert(PostRun,function()if prew1==5 then remove(Result)end end)
insert(Clear,function()prew1=5 prew2=5 end)