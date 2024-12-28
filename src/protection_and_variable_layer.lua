-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.
local __PROJECT_NAME__,A,E,S,T,placeholder_func,base_path,E_ENV,_={},
assert,
"__PROJECT_NAME__ load failed because of missing libruary method!",
string,
table,
function()end,
__BASE_PATH__
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
function(s,o,f) for k,v in pairs(s)do o[k]=f and o[k]or v end end,
function(t,o)o=o or {}for k,v in pairs(t)do o[v]=k end return o end,
function(...)local r={}for k,v in pairs{...}do insert(r,E_ENV[v])end return unpack(r)end

--DO NOT CHANGE VARIABLE ORDER IN E_ENV TAB!
E_ENV = {gmatch,match,format,find,gsub,sub, --string functions
insert,concat,remove,unpack, --table function
assert,type,pairs,error,tostring,tonumber, --generic functions
getmetatable,setmetatable,pcall,native_load,bit32,
placeholder_func,t_swap,t_copy,
table,string,math,io,os,coroutine,debug,package,require
}--EMBED_ENV make
A,E,S,T=nil
-- BASE VARIABLES LAYER END
