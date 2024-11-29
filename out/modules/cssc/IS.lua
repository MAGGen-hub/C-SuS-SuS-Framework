local insert,type,error,t_swap=ENV(7,13,15,24)

Control:load_lib"code.cssc.pdata"
Control:load_lib"code.cssc.op_stack"
Control:load_lib"code.cssc.typeof" --typeof func -> Control.typeof
local ltpof=Control.typeof
local IS_func=function(obj,comp)
    local md,tp,rez = type(comp),ltpof(obj),false --mode,type,rez
    if md=="string"then rez=tp==comp
    elseif md=="table"then for i=1,#comp do rez=rez or tp==comp[i]end
    else error("bad argument #2 to 'is' operator (got '"..md.."', expected 'table' or 'string')",2)end
    return rez
end
local tab,used={{" ",5},{"__cssc__kw_is",3}}

local tb = Control.Cdata.skip_tb
local check = t_swap{2,9,4}
local after = t_swap{4,10}
Control.Runtime.build("kwrd.is",IS_func)
Control.Words["is"]=function()
    if not used then Control.Runtime.reg("__cssc__kw_is","kwrd.is") end

    local i,d=Control.Cdata.tb_while(tb)
    if check[d[1]] then Control.error("Unexpected 'is' after '%s'!",Control.Result[i])end--error check before

    Control.inject(nil,",",2,Control.Cdata.opts["^"][1])
    Control.split_seq(nil,2,1)
    Control.Event.run(2,"is",2,1)--send events to fin opts in OP_st
    Control.Event.run("all","is",2,1)

    Control.Event.reg("all",function(obj,tp)--error check after
        if after[tp] or tp==2 and not Control.Cdata[#Control.Cdata][3] then Control.error("Unexpected '%s' after 'is'!",obj) end
        return not tb[tp] and 1 
    end)

    Control.inject_operator(tab,Control.Cdata.opts["^"][1])
    --local st=Control.Level[#Control.Level].OP_st
    --st[#st][2]=st[#st][2]-1

end
insert(Control.Clear,function()used=nil end)
return 1