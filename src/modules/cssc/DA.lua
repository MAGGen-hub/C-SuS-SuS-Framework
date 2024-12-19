local match,format,insert,remove,unpack,error,tostring,setmetatable,native_load,placeholder_func,t_swap=ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_ERROR__,__ENV_TOSTRING__,__ENV_SETMETATABLE__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__,__ENV_T_SWAP__)

C:load_lib"code.cssc.runtime"
local l,pht,tb,mt,typeof,err_text = Level,{},Cdata.skip_tb,setmetatable({},{__index=function(s,i)return i end}),C:load_lib"code.cssc.typeof","Unexpected '%s' in function argument type definition! Function argument type must be set using single name or string!"

Runtime.build("func.def_arg",function(data)
    local res,val,tp,def,ch={}
    for i=1,#data,4 do
        val=data[i+1]
        def=data[i+3]
        if val==nil and def then insert(res,def)--arg not inited, replace with default
        else
            ch =data[i+2]
            if ch then --type check
                tp=typeof(val) --actual typeof
                ch=ch==__TRUE__ and {[typeof(def)]=1} or t_swap{(native_load("return "..ch,nil,nil,mt)or placeholder_func)()}--> dynamic type! must be equal to def_arg type OR parce type val
                ch=not ch[tp] and error(format("bad argument #%d (%s expected, got %s)",data[i],data[i+2],tp),2)
            end
            insert(res,val)
        end
    end
    return unpack(res)
end)

Event.reg("lvl_open",function(lvl)-- def_arg initer
    --print("DA lo")
    if lvl.type=="function" then lvl.DA_np=__TRUE__ end --set Def_Args_next_posible true
    if lvl.type=="(" and l[#l].DA_np then lvl.DA_d={c_a=1} end--init Def_Args_data for "()" level
    l[#l].DA_np=nil--set Def_Args_next_posible false
end,"DA_lo",__TRUE__)


--DEF ARG DATA STRUCT: {strict_typeing, start_of_def_arg,end_of_def_arg, name_of_arg}
Event.reg(__OPERATOR__,function(obj)
    --print("DA op")
    local da,i,err=l[#l].DA_d
    if da then i=da.c_a --DA data found
        if obj==":"then
            --Control.log("nm :'%s'",Control.Result[Control.Cdata.tb_while(tb,#Control.Cdata-1)])
            da[i]=da[i]or{[4]=Result[Cdata.tb_while(tb,#Cdata-1)]}
            if not da[i][2]then --block if inside def_arg
                err,da[i][1]=da[i][1],#Cdata--this arg has strict typing!
            end
        elseif obj=="="then da[i]=da[i]or{[4]=Result[Cdata.tb_while(tb,#Cdata-1)]} err,da[i][2]=da[i][2],#Cdata--def arg start
        elseif obj==","then da.c_a=da.c_a+1 (da[i]or pht)[3]=#Cdata-1 --next possible arg; arg state end
        elseif not da[i] or not da[i][2] then err=__TRUE__ end
        if err then
            Control.error("Unexpected '%s' operator in function arguments defenition.",obj)
            l[#l].DA_d=nil--delete defective DA
        end
    end
end,"DA_op",__TRUE__)

Event.reg("lvl_close",function(lvl)-- def_arg injector
    if lvl.DA_d then --level had default_args
        local da,arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Cdata.opts[","][1]
        for i=da.c_a,1,-1 do --parce args
            if da[i]then val=da[i] ac,tej=0,nil --def_arg exist
                insert(name,{val[4],__WORD__})insert(name,{",",__OPERATOR__,pr})
                if not val[2] then insert(arr,{"nil",__VALUE__}) insert(arr,{",",__OPERATOR__,pr}) end --no def_arg -> insert nil -> type only
                val[3]=val[3]or#Result-1
                --if val[3]-(val[2]or val[1])<1 then Control.error("Expected default argument after '%s'",Control.Result[val[2]or val[1]])end
                
                for j=val[3]or#Result-1,val[1]or val[2],-1 do --to minimum value
                    obj=Control.eject(j)
                    if j==val[2] or j==val[1] then 
                        insert(arr,{",",__OPERATOR__,pr}) --comma replace
                    elseif val[2]and j>val[2] then--def_arg
                        insert(arr,obj)
                        ac=not tb[obj[2]] and ac+1 or ac
                    elseif not tb[obj[2]] then--strict_type (val[1] - 100% exist) val[2]--already parced
                        if not(obj[2]==__WORD__ or obj[2]==__STRING__ or match(obj[1],"^nil"))then 
                            Control.error(err_text,obj[1])
                        elseif tej then 
                            Control.error(err_text,obj[1])
                        else
                            if obj[2]==__WORD__ then obj={"'"..match(obj[1],"%S+").."'",__STRING__} end
                            insert(arr,obj)
                            tej=__TRUE__
                        end
                    end
                end
                if val[2] and ac<1 then Control.error("Expected default argument after '%s'",val[2]and"="or":")end
                ac=not tej and val[1]
                if ac or not val[1] then remove(ac and arr or pht) insert(arr,{ac and"1"or "nil",__VALUE__}) insert(arr,{",",__OPERATOR__,pr}) end --no strict type inset nil
                insert(arr,{val[4],__WORD__}) insert(arr,{",",__OPERATOR__,pr})
                insert(arr,{tostring(i),__VALUE__}) insert(arr,{",",__OPERATOR__,pr})--insert index
            end
        end
        if not obj then return end --obj works as marker that something was found
        Runtime.reg("__cssc__def_arg","func.def_arg")
        remove(name)
        for i=#name,1,-1 do Control.inject(nil, unpack(remove(name)))end
        Control.inject(nil,"=",__OPERATOR__,Cdata.opts["="][1])
        Control.inject(nil,"__cssc__def_arg",__WORD__)--TODO: replace with api function
        Control.inject(nil,"{",__OPEN_BREAKET__)
        val=#Result
        remove(arr)--remove last comma
        for i=#arr,1,-1 do --inject args ([1]="," - is coma, so not needed)
            Control.inject(nil, unpack(remove(arr)))--TODO: mark internal contents as CSSC-data for other funcs to ignore
        end
        Control.inject(nil,"}",__CLOSE_BREAKET__,val)
        Control.inject(nil,"",__OPERATOR__,0)--zero priority -> statement_end
    end
end,"DA_lc",__TRUE__)
--return __TRUE__