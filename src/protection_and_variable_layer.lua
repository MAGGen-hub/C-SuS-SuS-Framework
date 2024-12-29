-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.
local __PROJECT_NAME__,A,S,T,E,placeholder_func,base_path,E_ENV,_=
{},assert,string,table,"__PROJECT_NAME__ load failed because of missing libruary method!",
function()end,__BASE_PATH__

local gmatch,match,format,find,gsub,sub,insert,concat,remove,unpack,
type,pairs,error,tostring,tonumber,getmetatable,setmetatable,pcall=
    -- string.lib
    A(S.gmatch,E),
    A(S.match,E),
    A(S.format,E),
    A(S.find,E),
    A(S.gsub,E),
    A(S.sub,E),

    -- table.lib
    A(T.insert,E),
    A(T.concat,E),
    A(T.remove,E),
    A(__UNPACK_MACRO__,E),

    -- generic.lib
    A(type,E),
    A(pairs,E),
    A(error,E),
    A(tostring,E),
    A(tonumber,E),
    A(getmetatable,E),
    A(setmetatable,E),
    A(pcall,E)

__BIT32_LIBRUARY_VERSION_MACRO__

__NATIVE_LOAD_VERSION_MACRO__

local t_copy,t_swap,env_load=
function(s,o,f)o=o or{} for k,v in pairs(s)do o[k]=f and o[k]or v end return o end,
function(t,o)o=o or {}for k,v in pairs(t)do o[v]=k end return o end,
function(...)local r={}for k,v in pairs{...}do insert(r,E_ENV[v])end return unpack(r)end

--DO NOT CHANGE VARIABLE ORDER IN E_ENV TAB!
E_ENV = {gmatch,match,format,find,gsub,sub, --string functions
insert,concat,remove,unpack, --table function
A,type,pairs,error,tostring,tonumber, --generic functions
getmetatable,setmetatable,pcall,native_load,bit32,
placeholder_func,t_swap,t_copy,
t_copy(T),t_copy(S),t_copy(math),--t_copy(io),t_copy(os),t_copy(coroutine),t_copy(debug),package,require
}--EMBED_ENV make
A,E,S,T=nil
-- BASE VARIABLES LAYER END
