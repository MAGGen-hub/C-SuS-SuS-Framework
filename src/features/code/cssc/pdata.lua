function(Control,path,dt)--api to inject locals form Control table right into code
    local p,clr
    p={path=path or "__PROJECT_NAME__.runtime", locals={}, modules={}, 
        data=dt or setmetatable({},{__call=function(self,...)
            local t={}
            for _,v in pairs{...}do
                insert(t,self[v] or error("Unable to load '%s' run-time module!",v))
            end
            return unpack(t)
        end}),
        reg = function(l_name,m_name,func,force) --local name/module name
            insert(p.locals,l_name)
            insert(p.modules,"'"..m_name.."'")
            if func and force or (not p.data[m_name] or p.data[m_name]==func or Control.error("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name)) then p.libs[m_name]=func end
        end
    }
    insert(Control.PostRun,function()
        insert(Control.Result,1,"local "..concat(p.locals,",").."=" p.path.."("..concat(p.modules,",")..");")
    end)
    clr = function()
        p.locals={}
        p.modules={}
    end
    Control.Runtime=p
    insert(Control.Clear,clr)
end