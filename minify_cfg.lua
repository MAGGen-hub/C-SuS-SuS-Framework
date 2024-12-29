-- Minified description:
-- G* -> methods from _G table setmetatable/getmetatable for example
-- S* -> methods from string lib
-- T* -> methods form table lib (+ additions)
-- C* -> methods created and used by C SuS SuS
-- l* -> local variables (important)
-- 
local tmp=function(s)return 
    function(a,b) if a..b~="A(,E)" and not b:sub(1,1):match"[%w_]" and not a:sub(2,2):match"[%w_]" then 
        return a..s..b 
    end end 
end
local tmP=function(s)return 
    function(a,b) if a~="T."and a~="S." and not a:sub(2,2):match"[%w_]" and not b:match"[%w_]" then 
            return a..s..b 
    end end 
end
local tmError=function(a,b) 
    if a..b~="A(,E)" and b~="=se" and a:sub(2,2)~="." then 
        return a.."Ge"..b 
    end 
end

local base_module = {
	"A%(T%.unpack or Tu,E%)","A(T.unpack or unpack,E)", --fix unpack
	"A%(Tu,E%)"             ,"A(unpack,E)"            , --fix unpack

    "load_libs=load_libs"   ,"__KEEP_LL__=load_libs", --load_libs minification
    "load_lib=load_lib"     ,  "__KEEP_L__=load_lib",
    "load_libs"             ,                   "CL",
    "load_lib"              ,                   "Cl",
    "__KEEP_LL__"           ,            "load_libs",
    "__KEEP_L__"            ,             "load_lib",
    "Control=Control"       ,   "__KEEP_C__=Control",-- Control minification
    "Control"               ,                    "C",
    "__KEEP_C__"            ,              "Control",
    "load_control_string"   ,                   "Cs",--loaders/readers/runners
    "read_control_string"   ,                   "CS",
    "tab_run"               ,                   "Cr",
}

return {
    --this kind of minification runs for every file in project
    for_all={
        "(..)gmatch(.)",tmP"SG",-- gmatch -> SG
        "(..)match(.)" ,tmP"Sm",-- match  -> Sm
        "(..)format(.)",tmP"SF",-- format -> SF
        "(..)find(.)"  ,tmP"Sf",-- find   -> Sf
        "(..)gsub(.)"  ,tmP"Sg",-- match  -> Sg
        "(..)sub(.)"   ,tmP"Ss",-- match  -> Ss
    
        "(..)insert(.)",tmP"Ti",-- insert -> Ti
        "(..)concat(.)",tmP"Tc",-- concat -> Tc
        "(..)remove(.)",tmP"Tr",-- remove -> Tr
        "(..)unpack(.)",tmP"Tu",-- unpack -> Tu
    
        "(..)type(...)"        ,tmp"Gt",-- type         -> Gt
        "(..)pairs(...)"       ,tmp"Gp",-- pairs        -> Gp
        "(..)error(...)"       ,tmp"Ge",-- error        -> Ge
        "(..)tostring(...)"    ,tmp"Gs",-- tostring     -> Gs
        "(..)tonumber(...)"    ,tmp"Gn",-- tonumber     -> Gn
        "(..)getmetatable(...)",tmp"GG",-- getmetatable -> GG
        "(..)setmetatable(...)",tmp"GS",-- setmetatable -> GS
        "(..)pcall(...)"       ,tmp"GP",-- pcall        -> Gp
        "native_loadfile"      ,   "Gf",-- pcall        -> Gp
        "native_load"          ,   "Gl",-- pcall        -> Gp
    
        "t_copy"  ,"TC",-- t_copy   -> TC --table lib additions
        "t_swap"  ,"TS",-- t_swap   -> TS
    
        "env_load"        ,"Ce",-- env_load -> Cl --CSSC framework
        "placeholder_func","Cp",
    },
    --this minifications are specific for each file in project
    for_each={
        ["cssc_beta__craft_os__original.lua"]=base_module,
        ["cssc_beta__lua51__original.lua"]=base_module,
        ["cssc_beta__lua52__original.lua"]=base_module,
        ["modules/cssc/NC.lua"]={
            "runtime_dual_func","lR",
            "runtime_func"     ,"lr",
            "runtime_dual_meta","lM",
            "runtime_meta"     ,"lm",
            "check"            ,"lc",
        },
        ["modules/cssc/KS.lua"]={
            "make_react"       ,"r",
            "arg"              ,"a",
            "stx"              ,"s",
        },
        ["modules/cssc/IS.lua"]={
            "l_typeof"   , "T",
            "skipper_tab", "S",
            "check"      , "c",
            "after"      , "a",
            "inject_tab" , "I",
            "work_mode"  , "w",
            "obj_tp"     , "t",
            "rez"        , "r",
            "id"         , "i",
            "data"       , "d",
        },
        ["modules/cssc/DA.lua"]={
            "placeholder_table" , "p",
            "strict_type_def"   , "s",
            "def_arg_meta"      , "m",
            "default_arg"       , "d",
            "skipper_tab"       , "S",
            "type_check"        , "T",
            "build_arr"         , "b",
            "comma_obj"         , "c",
            "value_tp"          , "V",
            "err_text"          , "E",
            "arg_len"           , "a",
            "da_data"           , "D",
            "da_tab"            , "d",
            "l_typeof"          , "t",
            "value"             , "v",
            "name"              , "n",
            "res"               , "r",
            "Lvl"               , "l",
            "err"               , "e",
            "obj"               , "o",
        },
    }
}