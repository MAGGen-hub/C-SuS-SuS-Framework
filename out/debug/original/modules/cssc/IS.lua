local insert,type,error,t_swap=ENV(7,12,14,23)

local l_typeof,skipper_tab,check,after,inject_tab=
C:load_libs"code.cssc""runtime""op_stack""typeof"(3),
Cdata.skip_tb,
t_swap{2,9,4},
t_swap{4,10},
{{" ",5},{"__cssc__kw_is",3}}

Runtime.build("kwrd.is",function(obj,cmp)
    local work_mode,obj_tp,rez = type(cmp),l_typeof(obj),false --mode,type,rez
    if work_mode=="string"then rez=obj_tp==cmp
    elseif work_mode=="table"then for i=1,#cmp do rez=rez or obj_tp==cmp[i]end
    else error("bad argument #2 to 'is' operator (got '"..work_mode.."', expected 'table' or 'string')",2)end
    return rez
end)

Words["is"]=function()
    Runtime.reg("__cssc__kw_is","kwrd.is")

    local id,l_data=Cdata.tb_while(skipper_tab)
    if check[l_data[1]] then C.error("Unexpected 'is' after '%s'!",Result[id])end--error check before

    Cssc.inject(",",2,Cdata.opts["^"][1])
    Text.split_seq(nil,2,1)
    Event.run(2,"is",2,1)--send events to fin opts in OP_st
    Event.run("all","is",2,1)

    Event.reg("all",function(obj,tp)--error check after
        if after[tp] or tp==2 and not Cdata[#Cdata][3] then C.error("Unexpected '%s' after 'is'!",obj) end
        return not skipper_tab[tp] and 1 
    end)

    Cssc.op_conf(inject_tab,Cdata.opts["^"][1])
end
--return 1