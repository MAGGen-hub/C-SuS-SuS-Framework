-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.
local A,E=assert,"__PROJECT_NAME__ load failed because of missing libruary method!"

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
local unpack = A(unpack,E)

-- math.lib
local floor = A(math.floor,E)

-- generic.lib
local type         = A(type,E)
local pairs        = A(pairs,E)
local error        = A(error,E)
local tostring     = A(tostring,E)
local getmetatable = A(getmetatable,E)
local setmetatable = A(setmetatable,E)
local bit32        = bit32 or pcall(require,"bit32")and require"bit32"or print"Warning! Bit32 libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
    local b = {}
    for k,v in pairs(bit32)do b32[k]=v end
    b.shl=b.lshift
    b.shr=b.rshift
    b.lshift,brshift=nil --optimisation
    bit32=b
end

-- Lua5.2 load mimicry
local native_load
do
local loadstring,load,setfenv=A(loadstring,E),A(load,E),A(setfenv,E)
    native_load = function(x,name,mode,env)
        local r,e=(type(x)=="string"and loadstring or load)(x,name)
        if env and r then setfenv(r,env)end
        return r,e
    end
end

A,E=nil
-- PROTECTION LAYER END

-- BASE VARIABLES LAYER
local Features = {}
local lua_mc = {} 
local keywords_string = "if function for while repeat elseif else do then end until local return in break "
local keywords_base = {}
local keywords_ids = {}
local placeholder_func = function()end


gsub(keywords_string,"(%S+)( )", --fill tables with values
    function(w,s)
        keywords_base[#keywords_base+1]=s..w..s
        keywords_ids[w]=#keywords_base
    end)
-- BASE VARIABLES LAYER END
