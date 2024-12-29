local match,format,insert,remove,unpack,error,tostring,setmetatable,native_load,placeholder_func,t_swap=ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_ERROR__,__ENV_TOSTRING__,__ENV_SETMETATABLE__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__,__ENV_T_SWAP__)

local placeholder_table,skipper_tab,def_arg_meta,l_typeof,err_text = 
{},
Cdata.skip_tb,
setmetatable({},{__index=function(s,i)return i end}),
C:load_libs"code.cssc""runtime""typeof"(2),
"Unexpected '%s' in function argument type definition! Function argument type must be set using single name or string!"

Runtime.build("func.def_arg",function(da_data)-- arg_struct (arg_number,arg_value,arg_type,default_arg)
    local res,value,value_tp,default_arg,type_check={}
    for i=1,#da_data,4 do
        value=da_data[i+1]
        default_arg=da_data[i+3]
        if value==nil and default_arg then insert(res,default_arg)--arg not inited, replace with default
        else
            type_check=da_data[i+2]
            if type_check then --type check
                value_tp=l_typeof(value) --actual typeof
                type_check=type_check==__TRUE__ and {[l_typeof(default_arg)]=1} or t_swap{(native_load("return "..type_check,"DA_type_loader",nil,def_arg_meta)or placeholder_func)()}--> dynamic type! must be equal to def_arg type OR parce type value
                type_check=not type_check[value_tp] and error(format("bad argument #%d (%s expected, got %s)",da_data[i],da_data[i+2],value_tp),2)
            end
            insert(res,value)
        end
    end
    return unpack(res)
end)

Event.reg("lvl_open",function(Lvl)-- def_arg initer
    if Lvl.type=="function" then Lvl.DA_np=__TRUE__ end --set Def_Args_next_posible true
    if Lvl.type=="(" and Level[#Level].DA_np then Lvl.DA_d={c_a=1} end--init Def_Args_data for "()" level
    Level[#Level].DA_np=nil--set Def_Args_next_posible false
end,"DA_lo",__TRUE__)

--DEF ARG DATA STRUCT: {strict_typeing, start_of_def_arg,end_of_def_arg, name_of_arg}
Event.reg(__OPERATOR__,function(obj)
    local da_tab,i,err=Level[#Level].DA_d
    if da_tab then i=da_tab.c_a --DA data found
        if obj==":"then
            da_tab[i]=da_tab[i]or{[4]=Result[Cdata.tb_while(skipper_tab,#Cdata-1)]}
            if not da_tab[i][2]then --block if inside def_arg
                err,da_tab[i][1]=da_tab[i][1],#Cdata--this arg has strict typing!
            end
        elseif obj=="="then da_tab[i]=da_tab[i]or{[4]=Result[Cdata.tb_while(skipper_tab,#Cdata-1)]} err,da_tab[i][2]=da_tab[i][2],#Cdata--def arg start
        elseif obj==","then da_tab.c_a=da_tab.c_a+1 (da_tab[i]or placeholder_table)[3]=#Cdata-1 --next possible arg; arg state end
        elseif not da_tab[i] or not da_tab[i][2] then err=__TRUE__ end
        if err then
            C.error("Unexpected '%s' operator in function arguments defenition.",obj)
            Level[#Level].DA_d=nil--delete defective DA
        end
    end
end,"DA_op",__TRUE__)

--DEF ARG DATA STRUCT: {strict_typeing, start_of_def_arg,end_of_def_arg, name_of_arg}
Event.reg("lvl_close",function(lvl)-- def_arg injector
    if lvl.DA_d then --level had default_args
        local da_tab,build_arr,name,comma_obj,da_data,obj,strict_type_def,arg_len=lvl.DA_d,{},{},{",",__OPERATOR__,Cdata.opts[","][1]}
        for i=da_tab.c_a,1,-1 do --parce args
            if da_tab[i]then --def_arg exist
                da_data,arg_len,strict_type_def=da_tab[i],0

                insert(name,{da_data[4],__WORD__}) insert(name,comma_obj)--insert arg name
                
                if not da_data[2] then --no def_arg -> insert nil -> type only
                    insert(build_arr,{"nil",__VALUE__}) insert(build_arr,comma_obj)
                end 
                
                da_data[3]=da_data[3]or#Result-1 --if end of arg was not specified (last arg is def_arg)
                
                --cycle to eject def arg data from function ( *data* ) breakets 
                for j=da_data[3],da_data[1]or da_data[2],-1 do --to minimum value
                    obj=Cssc.eject(j) --get code data object
                    if j==da_data[2] or j==da_data[1] then 
                        insert(build_arr,comma_obj) --comma replace (':' or '=' located)
                    elseif da_data[2]and j>da_data[2] then--def_arg located
                        insert(build_arr,obj)
                        arg_len=not skipper_tab[obj[2]] and arg_len+1 or arg_len
                    elseif not skipper_tab[obj[2]] then--strict_type(da_data[1] - 100% exist -> da_data[2] already parced and things to parce still exist)
                        if not(obj[2]==__WORD__ or obj[2]==__STRING__ or match(obj[1],"^nil")) or strict_type_def then 
                            C.error(err_text,obj[1])--dual type_def or corrupted type def
                        else
                            if obj[2]==__WORD__ then obj={"'"..match(obj[1],"%S*").."'",__STRING__} end
                            insert(build_arr,obj)
                            --TODO: REWORK STRICT MULTY-TYPING SYSTEM 
                            --move string parceing system from runtime to compile section (part with native_load)
                            strict_type_def=__TRUE__
                        end
                    end
                end

                if da_data[2] and arg_len<1 then C.error("Expected default argument after '%s'",da_data[2]and"="or":")end
                arg_len=not strict_type_def and da_data[1]

                if arg_len or not da_data[1] then --no strict type inset nil
                    remove(arg_len and build_arr or placeholder_table) 
                    insert(build_arr,{arg_len and"1"or "nil",__VALUE__}) 
                    insert(build_arr,comma_obj) 
                end 

                insert(build_arr,{da_data[4],__WORD__}) insert(build_arr,comma_obj) --insert arg name
                insert(build_arr,{tostring(i),__VALUE__}) insert(build_arr,comma_obj)--insert arg index
            end
        end
        if not obj then return end --obj works as marker that something was found

        Runtime.reg("__cssc__def_arg","func.def_arg")
        remove(name)
        for i=#name,1,-1 do Cssc.inject(unpack(remove(name)))end
        Cssc.inject("=",__OPERATOR__,Cdata.opts["="][1])
        Cssc.inject("__cssc__def_arg",__WORD__)--TODO: replace with api function
        Cssc.inject("{",__OPEN_BREAKET__)

        da_data=#Result
        remove(build_arr)--remove last comma
        for i=#build_arr,1,-1 do --inject args ([1]="," - is coma, so not needed)
            Cssc.inject( unpack(remove(build_arr)))--TODO: mark internal contents as CSSC-data for other funcs to ignore
        end
        Cssc.inject("}",__CLOSE_BREAKET__,da_data)
        --TODO: try keep leveling offset (probably need to rework injector [Cssc.inject])
        Cssc.inject("",__OPERATOR__,0)--zero priority -> statement_end
    end
end,"DA_lc",__TRUE__)