local match,format,insert,concat,unpack,pairs,error,setmetatable,tostring = ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_CONCAT__,__ENV_UNPACK__,__ENV_PAIRS__,__ENV_ERROR__,__ENV_SETMETATABLE__,__ENV_TOSTRING__)
local P,d,p,clear_func=...
--api to inject locals form Control table right into code
p={path=P or "____PROJECT_NAME____runtime", locals={}, modules={}, loc_names={},
    data=d or setmetatable({},{__call=function(s,...)
        local t={}
        for _,v in pairs{...}do
            insert(t,s[v] or error(format("Unable to load '%s' run-time module!",v)))
        end
        return unpack(t)
    end}),
    reg = function(l_name,m_name) --local name/module name
        if p.loc_names[l_name] then return end
        p.loc_names[l_name]=__TRUE__
        insert(p.locals,l_name)
        insert(p.modules,"'"..m_name.."'")
    end,
    build=function(m_name,l_func)--TODO: REWORK!
        if (not p.data[m_name] or C.error("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name)) then 
            p.data[m_name]=l_func 
        end
    end,
    is_done=false,
    mk_env=function(t)
        t=t or {}
        if #p.locals>0 then
            if t[p.path] then C.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,tostring(t))end
            t[p.path]=p.data 
        end
        return t
    end
}
insert(PostRun,function()
    if not p.is_done and #p.locals>0 then
        insert(Result,1,"local "..concat(p.locals,",").."="..p.path.."("..concat(p.modules,",")..");")
    end
    p.is_done=true
end)
clear_func = function()
    p.locals={}
    p.modules={}
    p.loc_names={}
    p.is_done=false
end
C.Runtime=p
insert(Clear,clear_func)