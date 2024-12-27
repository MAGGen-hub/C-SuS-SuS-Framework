local insert,type,error,t_swap=ENV(__ENV_INSERT__,__ENV_TYPE__,__ENV_ERROR__,__ENV_T_SWAP__)

local ltpof=C:load_libs"code.cssc""runtime""op_stack""typeof"(3)
--C:load_lib"code.cssc.runtime"
--C:load_lib"code.cssc.op_stack" --typeof func -> Control.typeof
--local ltpof=C:load_lib"code.cssc.typeof"
local IS_func=function(obj,comp)
    local md,tp,rez = type(comp),ltpof(obj),false --mode,type,rez
    if md=="string"then rez=tp==comp
    elseif md=="table"then for i=1,#comp do rez=rez or tp==comp[i]end
    else error("bad argument #2 to 'is' operator (got '"..md.."', expected 'table' or 'string')",2)end
    return rez
end
local tab,used={{" ",__SPACE__},{"__cssc__kw_is",__WORD__}}

local tb = Cdata.skip_tb
local check = t_swap{__OPERATOR__,__OPEN_BREAKET__,__KEYWORD__}
local after = t_swap{__KEYWORD__,__CLOSE_BREAKET__}
Runtime.build("kwrd.is",IS_func)
Words["is"]=function()
    Runtime.reg("__cssc__kw_is","kwrd.is")
    --if not used then Control.Runtime.reg("__cssc__kw_is","kwrd.is") used=__TRUE__ end

    local i,d=Cdata.tb_while(tb)
    if check[d[1]] then Control.error("Unexpected 'is' after '%s'!",Result[i])end--error check before

    Cssc.inject(",",__OPERATOR__,Cdata.opts["^"][1])
    Text.split_seq(nil,2,__TRUE__)
    Event.run(__OPERATOR__,"is",__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
    Event.run("all","is",__OPERATOR__,__TRUE__)

    Event.reg("all",function(obj,tp)--error check after
        if after[tp] or tp==__OPERATOR__ and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after 'is'!",obj) end
        return not tb[tp] and __TRUE__ 
    end)

    Cssc.op_conf(tab,Cdata.opts["^"][1])
end
--return __TRUE__