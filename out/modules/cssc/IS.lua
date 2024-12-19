local insert,type,error,t_swap=ENV(7,13,15,24)

C:load_lib"code.cssc.runtime"
C:load_lib"code.cssc.op_stack" --typeof func -> Control.typeof
local ltpof=C:load_lib"code.cssc.typeof"
local IS_func=function(obj,comp)
    local md,tp,rez = type(comp),ltpof(obj),false --mode,type,rez
    if md=="string"then rez=tp==comp
    elseif md=="table"then for i=1,#comp do rez=rez or tp==comp[i]end
    else error("bad argument #2 to 'is' operator (got '"..md.."', expected 'table' or 'string')",2)end
    return rez
end
local tab,used={{" ",5},{"__cssc__kw_is",3}}

local tb = Cdata.skip_tb
local check = t_swap{2,9,4}
local after = t_swap{4,10}
Runtime.build("kwrd.is",IS_func)
Words["is"]=function()
    Runtime.reg("__cssc__kw_is","kwrd.is")
    --if not used then Control.Runtime.reg("__cssc__kw_is","kwrd.is") used=1 end

    local i,d=Cdata.tb_while(tb)
    if check[d[1]] then Control.error("Unexpected 'is' after '%s'!",Result[i])end--error check before

    Control.inject(nil,",",2,Cdata.opts["^"][1])
    Text.split_seq(nil,2,1)
    Event.run(2,"is",2,1)--send events to fin opts in OP_st
    Event.run("all","is",2,1)

    Event.reg("all",function(obj,tp)--error check after
        if after[tp] or tp==2 and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after 'is'!",obj) end
        return not tb[tp] and 1 
    end)

    Control.configure_operator(tab,Cdata.opts["^"][1])
end
--return 1