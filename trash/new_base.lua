Configs = {cssc="lua.cssc=M.KS.IS.N.CA.DA.NF.LF"}
Libruarys = {
    sys={modules={
        err={init=function(Ctrl)
            Ctrl.Finaliser.err=function()
                if Ctrl.err then Ctrl.rt=1 return nil,Ctrl.err end
            end
        end},

--Preload feature
        pre={init=function(Ctrl,script_id,x,name,mode,env)
            if not __PROJECT_NAME__.preload then __PROJECT_NAME__.preload={}end
            local P=__PROJECT_NAME__.preload
            if P[script_id] then return native_load(P[script_id],name,mode,env)end
                Ctrl.Finaliser.pre=function()
                P[script_id]=concat(Ctrl.Result) 
            end
        end},
        dbg={init=function(Ctrl,Value) -- V - argument
            local v=Value
            Ctrl.Finaliser.dbg=function(x,n,m)
                if v=="p"then print(concat(Ctrl.Result))end
                if m=="c"then
                    Ctrl.rt=1
                    return Ctrl.Result
                elseif m=="s"then
                    Ctrl.rt=1
                    return concat(Ctrl.Result)
                end
            end
        end}
}}

-- PREPROCESSOR BASE MODULE
__PROJECT_NAME__.preprocess=function(x,mode,...)
    if"string"==type(x)then error(format("bad argument #1 (expected string, got %s)",type(x))) end
    if mode~=nil and"string"==type(mode)then error(format("bad argument #2 (expected string, got %s)",type(mode))) end
    
    --CONTROL STRING DETECT
    local control_string,temp=match(x,"^<(.-)>(.*)")--locate and remove control_strin from string/file
    x=temp or x
    temp=match(mode,"^<(.-)>") --override control string using mode parameter if 
    control_string=temp or control_string
    mode=temp and match(mode,">(.*)")or mode
    if not control_string then error"control string not found!"end--control string exists!
        
    --INITIALISE LOCALS
    local Control,loaded_string,req_func={}
    Control={
        src=x,
        mode=mode,
        args={...},
        Result={""},
        Operators={},
        max_op_len=3,
        Words={},
        PostLoad={},
        PostRun={},
        Iterator="()([%s!-/:-@[-^{-~`]*)([%P_]*)",
        Struct=placeholder_func,
        Core=placeholder_func,
        line=1} -- initialise control tablet for special functions call
    
    --CONTROL STRING LOAD
    func=function(str,l,e)
        l,e=native_load(gsub(format("return{%s}",str),"([{,])(.-%..-)=","%1[%2]="),"ctrl_str",nil,setmetatable({},{__index=function(s,i)return setmetatable({i},{__index=function(s,i)s[#s+1]=i return s end}) end}))
        l=e and error(format("Invalid control string: <%s>",str))or l()
        e=l.config
        e=Configs["table"==type(e)and concat{e} or e or{}]
        return e and func(e)or l
    end
    loaded_string=read_ctrl(control_string)
    --loaded_string,e=native_load(gsub(format("return{%s}",control_string),"([{,])(.-%..-)=","%1[%2]="),"ctrl_str",nil,setmetatable({},{__index=function(s,i)return setmetatable({i},{__index=function(s,i)s[#s+1]=i return s end}) end}))
    --loaded_string=e and error(format("Invalid control string: <%s>",control_string))or loaded_string()
    
    --LOAD MODULES
    func=function(loaded_table,nxt,path)
        local path_part,mod=remove(loaded_table[1],1)
        mod=(nxt or Libruarys)[md_part]or{}--error"Module not found!"
        path = path.."."..md_part
        Control.Loaded[path],e=pcall(function()
            if not Control.Loaded[path]then --prevent double load
                for k,v in pairs(mod.operators or{})do Control.Operators[k]=v end --load operators
                for k,v in pairs(mod.words or{})do Control.Words[k]=v end    --load words
                (mod.init or placeholder_func)(Control,path,unpack(loaded_table))--mod.modules and {}or loaded_table))          --launch init function
            end
        end)
        e=e and error(format('Error loading module "%s": %s',path,e))
        if mod.modules then  --load sub_modules
            if#loaded_table[1]>0 then
                func(loaded_table,mod.modules,path)
            else for k,v in pairs(loaded_table[2]or{})do
                func("number"==type(k)and{v}or{k,v},mod.modules,path)
            end end
        end
    end
    for k,v in pairs(loaded_string)do
        func("number"==type(k)and{v}or{k,v},nil,"@")
    end
    for k,v in pairs(Control.PostLoad)do v(Control)end --AFTERLOAD SEGMENT
    
    --MAKE PARCE FUNC
    func=function(object_react,t,j,i)
        Control.Result[#Control.Result+1]="string"==type(object_react)or object_react or object_react(Control)
        if not Control.custom_react then
            Control[t]=sub(Control[t],j+1)
            Control.index=Control.index+j
            Control.Core(i)
        end
    end
    
    --COMPILE
    Control.Iterator="string"==type(Control.Iterator)and gmatch(x,Control.Iterator)or Control.Iterator
    Control.index,Control.operator,Control.word=Control.Iterator()
    while Control.index do
        while #Control.operator>0 or #Control.word>0 do
            --Control.struct_mode=Control.Struct()--STRUCTURE PROCCESOR (base overrider and space handler)
            if not Control.Struct() then   --STRUCTURE PROCESSOR (base overrider and space handler)
                if Control.operator>0 then --OPERATOR PROCESSOR
                    for j=Control.max_op_len,1-1 do --split the operator_seq
                        posible_object=sub(Control.operator,1,j)
                        object_react=Control.Operators[posible_object]or j<2 and posible_object
                        if object_react then
                            func(object_react,"operator",j,__OPERATOR__)
                            --Control.Result[#Control.Result+1]="string"==type(object_react)and object_react or object_react(Control) --,j)
                            --if not Control.custom_react then
                            --    Control.operator=sub(Control.operator,j+1)
                            --    Control.index=Control.index+j
                            --    Control.Core(__OPERATOR__)
                            --end
                            break
                        end
                    end
                elseif#Control.word>0 then--WORD PROCESSOR
                    posible_object,temp=match(Control.word,"^%(S+)()") --split the word_seq temp=#posible_object
                    object_react=Control.Words[posible_object]or posible_object
                    func(object_react,"word",#posible_object,__WORD__)
                    --Control.Result[#Control.Result+1]="string"==type(object_react)and object_react or object_react(Control) --,#posible_object)
                    --if not Control.custom_react then
                    --    Control.word=sub(Control.word,temp)
                    --    Control.index=Control.index+temp-1
                    --    Control.Core(__WORD__)
                    --end
                end
                Control.custom_react=false
            end
        end
        Control.index,Control.operator,Control.word=Control.Iterator()
    end
    
    --FINISH COMPILE
    for k,v in pairs(Control.PostRun)do 
        v(Control)
        if Control.Return then return unpack(Control.Return)end
    end
    return concat(Result)
end
