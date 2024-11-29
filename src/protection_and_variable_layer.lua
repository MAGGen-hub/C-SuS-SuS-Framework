-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.
local A,E=assert,"__PROJECT_NAME__ load failed because of missing libruary method!"
local base_path="/cssc_final/out/"
-- string.lib
local gmatch = A(string.gmatch,E)
local match  = A(string.match,E)
local format = A(string.format,E)
local find   = A(string.find,E)
local gsub   = A(string.gsub,E)
local sub    = A(string.sub,E)

-- table.lib
local insert = A(table.insert,E)
local concat = A(table.concat,E)
local remove = A(table.remove,E)
local unpack = A(__UNPACK_MACRO__,E)

-- math.lib
local floor = A(math.floor,E)

-- generic.lib
local assert       = A
local type         = A(type,E)
local pairs        = A(pairs,E)
local error        = A(error,E)
local tostring     = A(tostring,E)
local tonumber     = A(tonumber,E)
local getmetatable = A(getmetatable,E)
local setmetatable = A(setmetatable,E)
local pcall        = A(pcall,E)
local _ --WASTE (dev null)
__BIT32_LIBRUARY_VERSION_MACRO__

__NATIVE_LOAD_VERSION_MACRO__

A,E=nil
local __PROJECT_NAME__ = {}
local placeholder_func = function()end

local t_copy,t_swap=	
    function(s,o,f) for k,v in pairs(s)do o[k]=f and o[k]or v end end,
    function(t,o)o=o or {}for k,v in pairs(t)do o[v]=k end return o end

local E_ENV
local env_load = function(...)
    local rez = {}
    for k,v in pairs{...}do insert(rez,E_ENV[v]) end
    return unpack(rez)
end
--DO NOT CHANGE VARIABLE ORDER IN E_ENV TAB!
E_ENV = {gmatch,match,format,find,gsub,sub, --string functions
insert,concat,remove,unpack, --table function
floor, --math functions
assert,type,pairs,error,tostring,tonumber, --generic functions
getmetatable,setmetatable,pcall,native_load,bit32,
placeholder_func,t_swap,t_copy

}
--EMBED_ENV make

-- BASE VARIABLES LAYER END
