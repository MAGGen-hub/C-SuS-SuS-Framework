local match,insert,remove,t_swap =ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_T_SWAP__)
--code parceing system
C:load_lib"text.dual_queue.base"
C:load_lib"text.dual_queue.parcer"
C:load_lib"text.dual_queue.iterator"
C:load_lib"text.dual_queue.space_handler"

C:load_lib"code.lua.struct"

Operators[".."]=".." -- need to locate this
Operators["..."]=function()
    insert(Result,"...")
    C.operator=sub(C.operator,j+1)
    C.index=C.index+j
    Core(__WORD__,"...") --by default "..." is __VALUE but __WORD__ is enought for this module
end -- need to locate this

local prew2 = __SPACE__
local prew1 = __SPACE__
C.Core=function(tp,obj)
    if tp==__COMMENT__ then --remove comments
        remove(Result)
        if prew1==__SPACE__ then if match(obj,"\n") then Result[#Result]="\n" end return end
        insert(Result," ")
        tp=__SPACE__
    end
    if tp==__SPACE__ then
        remove(Result)
        if prew1==__SPACE__ then if match(obj,"\n") then Result[#Result]="\n" end return end
        insert(Result,match(obj,"\n") and "\n" or " ")
    end
    if prew2==__NUMBER__ and prew1==__SPACE__ and obj==".." then return end --concatenation bug fix
    tp=tp==__OPERATOR__ and __SYMBOL__ or tp --type redefine parce operator as symbol
    tp=tp==__NUMBER__ and __WORD__ or tp --type redefine parce number as word
    if prew1==__SPACE__ then
        if prew2==__STRING__ or prew2==__SYMBOL__ or (prew2==__WORD__ and (tp==__SYMBOL__ or tp==__STRING__)) then
            remove(Result,#Result-1)--space not required
        end
    end

    end
    prew2=prew1
    prew1=tp
end