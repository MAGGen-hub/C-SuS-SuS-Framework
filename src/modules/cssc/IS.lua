local insert,type,error,t_swap=ENV(__ENV_INSERT__,__ENV_TYPE__,__ENV_ERROR__,__ENV_T_SWAP__)

local l_typeof,skipper_tab,check,after,inject_tab=
C:load_libs"code.cssc""runtime""op_stack""typeof"(3),
Cdata.skip_tb,
t_swap{__OPERATOR__,__OPEN_BREAKET__,__KEYWORD__},
t_swap{__KEYWORD__,__CLOSE_BREAKET__},
{{" ",__SPACE__},{"__cssc__kw_is",__WORD__}}

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

    Cssc.inject(",",__OPERATOR__,Cdata.opts["^"][1])
    Text.split_seq(nil,2,__TRUE__)
    Event.run(__OPERATOR__,"is",__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
    Event.run("all","is",__OPERATOR__,__TRUE__)

    Event.reg("all",function(obj,tp)--error check after
        if after[tp] or tp==__OPERATOR__ and not Cdata[#Cdata][3] then C.error("Unexpected '%s' after 'is'!",obj) end
        return not skipper_tab[tp] and __TRUE__ 
    end)

    Cssc.op_conf(inject_tab,Cdata.opts["^"][1])
end
--return __TRUE__