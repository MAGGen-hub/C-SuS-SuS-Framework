local match,format,insert,concat,unpack,pairs,error,setmetatable,tostring = ENV(__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_CONCAT__,__ENV_UNPACK__,__ENV_PAIRS__,__ENV_ERROR__,__ENV_SETMETATABLE__,__ENV_TOSTRING__)
local path,dt=...
--api to inject locals form Control table right into code
local p,clr
p={path=path or "____PROJECT_NAME____runtime", locals={}, modules={}, loc_names={},
    data=dt or setmetatable({},{__call=function(self,...)
        local t={}
        for _,v in pairs{...}do
            insert(t,self[v] or error(format("Unable to load '%s' run-time module!",v)))
        end
        return unpack(t)
    end}),
    reg = function(l_name,m_name) --local name/module name
        if p.loc_names[l_name] then return end
        p.loc_names[l_name]=__TRUE__
        insert(p.locals,l_name)
        insert(p.modules,"'"..m_name.."'")
    end,
    build=function(m_name,func)--TODO: REWORK!
        if (not p.data[m_name] or Control.error("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name)) then p.data[m_name]=func end
    end,
    is_done=false,
    mk_env=function(tb)
        tb=tb or {}
        if #p.locals>0 then
            if tb[p.path] then Control.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,tostring(tb))end
            tb[p.path]=p.data 
        end
        return tb
    end
}
insert(Control.PostRun,function()
    if not p.is_done and #p.locals>0 then
        insert(Control.Result,1,"local "..concat(p.locals,",").."="..p.path.."("..concat(p.modules,",")..");")
    end
    p.is_done=true
end)
clr = function()
    p.locals={}
    p.modules={}
    p.loc_names={}
    p.is_done=false
end
Control.Runtime=p
insert(Control.Clear,clr)