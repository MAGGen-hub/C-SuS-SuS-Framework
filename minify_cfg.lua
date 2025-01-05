-- Minified description:
-- G* -> methods from _G table setmetatable/getmetatable for example
-- S* -> methods from string lib
-- T* -> methods form table lib (+ additions)
-- C* -> methods created and used by C SuS SuS
-- l* -> local variables (important)
-- 
local tmp=function(s)return 
    function(a,b) if a..b~="A(,E)" and not b:sub(1,1):match"[%w_]" and not a:sub(2,2):match"[%w_%.]" then 
        return a..s..b 
    end end 
end
local tmP=function(s)return 
    function(a,b) if a~="T."and a~="S." and not a:sub(2,2):match"[%w_]" and not b:match"[%w_]" then 
            return a..s..b 
    end end 
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
    "Ge=GS"                 ,             "error=GS", --error object fix in new_base.lua
    "l_ctrl_str"            ,                    "X",
    "cur_aliases"           ,                    "A",
    "l_loaded"              ,                    "L",
    "path_prt"              ,                    "o",
    "aliases"               ,                    "a",
    "rez_tp"                ,                    "t",
    "l_path"                ,                    "P",
    "l_mod"                 ,                    "m",
    "l_arg"                 ,                    "a",
    "main"                  ,                    "M",
    "subm"                  ,                    "S",
    "_arg"                  ,                    "z",
    "Obj"                   ,                    "O",
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
    
        'type="main"',    '__KEEP_TM__', --for /features/common/level.lua and it's type object
        'type=obj',       '__KEEP_TO__',
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
        '__KEEP_TM__',    'type="main"',
        '__KEEP_TO__',       'type=obj',
    
        "t_copy"  ,"TC",-- t_copy   -> TC --table lib additions
        "t_swap"  ,"TS",-- t_swap   -> TS
    
        "env_load"        ,"Ce",-- env_load -> Cl --CSSC framework
        "placeholder_func","Cp",
    },
    --this minifications are specific for each file in project
    for_each={
        ["cssf__craft_os.lua"]=base_module,
        ["cssf__lua51.lua"]=base_module,
        ["cssf__lua52.lua"]=base_module,
        --#region Modules
        ["modules/cssc/NC.lua"]={
            "runtime_dual_func","R",
            "runtime_dual_meta","M",
            "runtime_func"     ,"r",
            "runtime_meta"     ,"m",
            "check"            ,"c",
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
            "l_data"       , "d",
        },
        ["modules/cssc/DA.lua"]={
            "placeholder_table" ,  "p",
            "strict_type_def"   ,  "s",
            "def_arg_meta"      ,  "m",
            "default_arg"       ,  "d",
            "skipper_tab"       ,  "S",
            "type_check"        ,  "T",
            "build_arr"         ,  "b",
            "comma_obj"         ,  "c",
            "value_tp"          ,  "V",
            "err_text"          ,  "E",
            "arg_len"           ,  "a",
            "da_data"           ,  "D",
            "da_tab"            ,  "d",
            "l_typeof"          ,  "t",
            "value"             ,  "v",
            "name"              ,  "n",
            "res"               ,  "r",
            "Lvl"               ,  "l",
            "([^%w_])err"       ,"%1e",
            "obj"               ,  "o",
        },
        ["modules/cssc/LF.lua"]={
            "state_ctrl"  , "s",
            "skipper_tab" , "S",
            "func_kwrd"   , "f",
            "index"       , "i",
            "l_data"      , "d",
            "is_corrupt"  , "c",
            "breaket"     , "b",
        },
        ["modules/cssc/BO.lua"]={-- i a b k v 
            "cur_priority"     , "P",
            "bitwize_opts"     , "B",
            "inject_table"     , "I",
            "un_priority"      , "p",
            "skipper_tab"      , "S",
            "func_part1"       , "F",
            "func_part2"       , "f",
            "idiv_func"        , "x",
            "make_err"         , "e",
            "loc_base"         , "l",
            "run_err"          , "r",
            "direct"           , "D",
            "l_opts"           , "O",
            "has_un"           , "u",
            "l_data"           , "d",
            "obj_tp"           , "t",
            "is_un"            , "U",
            "check"            , "c",
            "index"            , "i",
            "stx"              , "s",
            "obj"              , "o",
        },
        ["modules/cssc/CA.lua"]={
            "runtime_func_name" , "R",
            "prohibited_area"   , "P",
            "bitwize_opts"      , "B",
            "skipper_tab"       , "S",
            "coma_prior"        , "c",
            "actual_op"         , "a",
            "cur_index"         , "I",
            "cur_data"          , "D",
            "loc_base"          , "b",
            "index"             , "i",
            "last"              , "l",
            "Lvl"               , "L",
            "stx"               , "s",
        },
        ["modules/cssc/NF.lua"]={
            "number_data"   , "N",
            "exponenta"     , "e",
            "err_text"      , "E",
            "m_data"        , "d",
            "float"         , "f",
            "mode"          , "M",
            "base"          , "B",
            "full"          , "F",
            "nan"           , "n",
        },
        ["modules/cssc.lua"]={
            "local_cssc"    , "c",
            "lib_loader"    , "L",
            "meta_reg"      , "M",
            "id_prew"       , "P",
            "c_prew"        , "p",
            "spifc"         , "s",
            "index"         , "i",
            "l_obj"         , "o",
            "l_lvl"         , "l",
            "l_opt"         , "O",
            "l_tp"          , "t",
            "mark"          , "m",
            "temp"          , "T",
            "kwrd"          , "K",
        },
        ["modules/minify.lua"]={
            "l_make_react"  , "m",
            "obj_tp"        , "t",
            "prew2"         , "P",
            "prew1"         , "p",
            "arg"           , "a",
            "obj"           , "o",
        },
        --#endregion Modules
        
        --#region Features
        ["features/common/event.lua"]={
            "clear_func"    , "c",
            "del_marked"    , "d",
            "is_global"     , "g",
            "ev_func"       , "f",
            "index"         , "i",
            "list"          , "l",
            "name"          , "n",
        },
        ["features/common/level.lua"]={
            "clear_func"    , "c",
            "no_close"      , "n",
            "fin_obj"       , "F",
            "l_ends"        , "e",
            "is_fin"        , "f",
            "Lvl"           , "L",
            "obj"           , "o",
        },
        ["features/code/cdata.lua"]={
            "priority_data" ,   "p",
            "([^%.])index"  , "%1i",
            "clear_func"    ,   "E",
            "last_type"     ,   "L",
            "type_tab"      ,   "T",
            "lvl_obj"       ,   "l",
            "obj_tp"        ,   "t",
            "is_un"         ,   "u",
            "unary"         ,   "u",
            "check"         ,   "x",
            "obj"           ,   "o",
        },
        ["features/code/syntax_loader.lua"]={
            --already minified locals
        },
        ["features/code/cssc/op_stack.lua"]={
            "skipper_tab"   , "t",
            "start_pos"     , "p",
            "priority"      , "P",
            "is_unary"      , "U",
            "now_end"       , "N",
            "skip_fb"       , "S",
            "pre_tab"       , "T",
            "cdt_obj"       , "c",
            "stack"         , "s",
            "l_id"          , "i",
            "Lvl"           , "l",
        },
        ["features/code/cssc/runtime.lua"]={
            "clear_func", "c",
            "l_name"    , "n",
            "m_name"    , "m",
            "l_func"    , "f",
        },
        ["features/code/cssc/typeof.lua"]={
            --already minified locals
        },
        ["features/code/lua/base.lua"]={
            "libruary_loader"   , "M",
            "l_make_react"      , "m",
            "lua51"             , "L",
            "kwrd"              , "K",
            "l_kw"              , "y",
            "lvl"               , "l",
            "opt"               , "x",
        },
        ["features/code/lua/meta_opt.lua"]={
            "stat_end_prew" , "S",
            "stat_end_nxt"  , "s",
            "place_mark"    , "p",
            "call_prew"     , "P",
            "call_nxt"      , "N",
            "spifc"         , "y",
            "prew"          , "x",
            "nxt"           , "n",
        },
        ["features/code/lua/struct.lua"]={
            "get_number"    , "N",
            "exponenta"     , "E",
            "num_data"      , "n",
            "comment"       , "c",
            "str_obj"       , "s",
            "m_data"        , "D",
            "mode"          , "m",
            "dot"           , "d",
            "rez"           , "r",
            "Lvl"           , "l",
        },
        ["features/text/dual_queue/base.lua"]={
            "queue" , "s",
            "data"  , "d",
        },
        ["features/text/dual_queue/iterator.lua"]={
            "seq","S",
        },
        ["features/text/dual_queue/make_react.lua"]={
            --already minified locals
        },
        ["features/text/dual_queue/parcer.lua"]={
            "posible_obj"   , "p",
            "react_obj"     , "r",
            "obj_type"      , "t",
            "l_func"        , "f",
            "queue"         , "q",
        },
        ["features/text/dual_queue/space_handler.lua"]={
            "space" , "s",
            "temp"  , "t",
        }
        --#endregion Features
    }
}