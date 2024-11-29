-- Lua5.2 load mimicry
local native_load,native_loadfile
do
local loadstring,load,setfenv,loadfile=A(loadstring,E),A(load,E),A(setfenv,E),A(loadfile,E)
    native_load = function(x,name,mode,env)
        local r,e=(type(x)=="string"and loadstring or load)(x,name)
        if env and r then setfenv(r,env)end
        return r,e
    end
    native_loadfile=function(filename,mode,env)
        local r,e=loadfile(filename)
        if env and r then setfenv(r,env)end
        return r,e
    end
end