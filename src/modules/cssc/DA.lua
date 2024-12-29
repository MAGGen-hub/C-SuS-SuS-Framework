local match,format,insert,remove,unpack,error,tostring,setmetatable,native_load,placeholder_func,t_swap=ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_ERROR__,__ENV_TOSTRING__,__ENV_SETMETATABLE__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__,__ENV_T_SWAP__)

local placeholder_table,skipper_tab,def_arg_meta,typeof,err_text = 
{},
Cdata.skip_tb,
setmetatable({},{__index=function(s,i)return i end}),
C:load_libs"code.cssc""runtime""typeof"(2),
"Unexpected '%s' in function argument type definition! Function argument type must be set using single name or string!"

Runtime.build("func.def_arg",function(data)-- arg_struct (arg_number,arg_value,arg_type,default_arg)
    local res,value,value_tp,default_arg,type_check={}
    for i=1,#data,4 do
        value=data[i+1]
        default_arg=data[i+3]
        if value==nil and default_arg then insert(res,default_arg)--arg not inited, replace with default
        else
            type_check=data[i+2]
            if type_check then --type check
                value_tp=typeof(value) --actual typeof
                type_check=type_check==__TRUE__ and {[typeof(default_arg)]=1} or t_swap{(native_load("return "..type_check,"DA_type_loader",nil,def_arg_meta)or placeholder_func)()}--> dynamic type! must be equal to def_arg type OR parce type value
                type_check=not type_check[value_tp] and error(format("bad argument #%d (%s expected, got %s)",data[i],data[i+2],value_tp),2)
            end
            insert(res,value)
        end
    end
    return unpack(res)
end)

Event.reg("lvl_open",function(lvl)-- def_arg initer
    if lvl.type=="function" then lvl.DA_np=__TRUE__ end --set Def_Args_next_posible true
    if lvl.type=="(" and Level[#Level].DA_np then lvl.DA_d={c_a=1} end--init Def_Args_data for "()" level
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
            Control.error("Unexpected '%s' operator in function arguments defenition.",obj)
            Level[#Level].DA_d=nil--delete defective DA
        end
    end
end,"DA_op",__TRUE__)

Event.reg("lvl_close",function(lvl)-- def_arg injector
    if lvl.DA_d then --level had default_args
        local da_tab,build_arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Cdata.opts[","][1]
        for i=da_tab.c_a,1,-1 do --parce args
            if da_tab[i]then --def_arg exist
                val,ac,tej=da_tab[i],0
                insert(name,{val[4],__WORD__})insert(name,{",",__OPERATOR__,pr})
                if not val[2] then insert(build_arr,{"nil",__VALUE__}) insert(build_arr,{",",__OPERATOR__,pr}) end --no def_arg -> insert nil -> type only
                val[3]=val[3]or#Result-1
                
                for j=val[3]or#Result-1,val[1]or val[2],-1 do --to minimum value
                    obj=Cssc.eject(j)
                    if j==val[2] or j==val[1] then 
                        insert(build_arr,{",",__OPERATOR__,pr}) --comma replace
                    elseif val[2]and j>val[2] then--def_arg
                        insert(build_arr,obj)
                        ac=not skipper_tab[obj[2]] and ac+1 or ac
                    elseif not skipper_tab[obj[2]] then--strict_type (val[1] - 100% exist) val[2]--already parced
                        if not(obj[2]==__WORD__ or obj[2]==__STRING__ or match(obj[1],"^nil"))then 
                            Control.error(err_text,obj[1])
                        elseif tej then 
                            Control.error(err_text,obj[1])
                        else
                            if obj[2]==__WORD__ then obj={"'"..match(obj[1],"%S+").."'",__STRING__} end
                            insert(build_arr,obj)
                            tej=__TRUE__
                        end
                    end
                end
                if val[2] and ac<1 then Control.error("Expected default argument after '%s'",val[2]and"="or":")end
                ac=not tej and val[1]
                if ac or not val[1] then remove(ac and build_arr or placeholder_table) insert(build_arr,{ac and"1"or "nil",__VALUE__}) insert(build_arr,{",",__OPERATOR__,pr}) end --no strict type inset nil
                insert(build_arr,{val[4],__WORD__}) insert(build_arr,{",",__OPERATOR__,pr})
                insert(build_arr,{tostring(i),__VALUE__}) insert(build_arr,{",",__OPERATOR__,pr})--insert index
            end
        end
        if not obj then return end --obj works as marker that something was found
        Runtime.reg("__cssc__def_arg","func.def_arg")
        remove(name)
        for i=#name,1,-1 do Cssc.inject(unpack(remove(name)))end
        Cssc.inject("=",__OPERATOR__,Cdata.opts["="][1])
        Cssc.inject("__cssc__def_arg",__WORD__)--TODO: replace with api function
        Cssc.inject("{",__OPEN_BREAKET__)
        val=#Result
        remove(build_arr)--remove last comma
        for i=#build_arr,1,-1 do --inject args ([1]="," - is coma, so not needed)
            Cssc.inject( unpack(remove(build_arr)))--TODO: mark internal contents as CSSC-data for other funcs to ignore
        end
        Cssc.inject("}",__CLOSE_BREAKET__,val)
        Cssc.inject("",__OPERATOR__,0)--zero priority -> statement_end
    end
end,"DA_lc",__TRUE__)