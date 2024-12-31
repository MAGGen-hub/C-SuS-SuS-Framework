local name   = "C_SuS_SuS_Framework"
local branch = "master"
local repo   = "https://raw.githubusercontent.com/MAGGen-hub/"..name.."/refs/heads/"..branch.."/"
local err_codes={
	[-2]="Broken URL",
	[-3]="No responce",
	[-4]="No result",
}

--#region All Files
local af = {
    op_stack = "features/code/cssc/op_stack.lua"
    runtime  = "features/code/cssc/runtime.lua"
    typeof   = "features/code/cssc/typeof.lua"

    lua_base = "features/code/lua/base.lua"
    meta_opt = "features/code/lua/meta_opt.lua"
    struct   = "features/code/lua/struct.lua"

    cdata         = "features/code/cdata.lua"
    syntax_loader = "features/code/syntax_loader.lua"

    level = "features/common/level.lua"
    event = "features/common/event.lua"

    dq_base       = "features/text/dual_queue/base.lua"
    iterator      = "features/text/dual_queue/iterator.lua"
    make_react    = "features/text/dual_queue/make_react.lua"
    parcer        = "features/text/dual_queue/parcer.lua"
    space_handler = "features/text/dual_queue/space_handler.lua"

	BO  = {
        name = "Lua 5.3 Backport operators",
        path = "modules/cssc/BO.lua",
        desc = "",
        dependecies="runtime,op_stack,cssc"},
	CA  = {
        name = "C Additional assignment",
        path = "modules/cssc/CA.lua",
        desc = "",
        dependecies="runtime,op_stack,cssc"},
	DA  = {
        name = "Default function arguments",
        path = "modules/cssc/DA.lua",
        desc = "",
        dependecies="runtime,typeof,cssc"},
	IS  = {
        name = "IS Keyword",
        path = "modules/cssc/IS.lua",
        desc = "",
        dependecies="runtime,op_stack,typeof,cssc"},
	KS  = {
        name = "Keyword Sortcuts",
        path = "modules/cssc/KS.lua",
        desc = "",
        dependecies="cssc"},
	LF  = {
        name= "Lambda functions",
        path= "modules/cssc/LF.lua",
        desc= "",
        dependecies="cssc"},
	NC  = {
        name= "Nil checking operators",
        path= "modules/cssc/NC.lua",
        desc= "",
        dependecies="runtime,op_stack,cssc"},
	ncbf= {
        name = "Number concatenation bug fix",
        path = "modules/cssc/ncbf.lua",
        desc = "From 'Lua 5.1' to 'Lua5.4' there is a weid bug exist.\n"..
               "If you type ` 1..1` concatenation will not be recognised as operator,\n"..
               "and will be parced as broken floating point, produceing compilation error\n"..
               "This little macros turns evry `*num*..*obj*` into `*num* ..*obj*`.\n"..
               "Not very useful, but why not?",
        dependecies="cssc"},
	NF  = {
        name = "Number Formats Module",
        path = "modules/cssc/NF.lua",
        desc = "Module that adds new number formats: binary and octal.\n"..
               "Example usage:\n"..
               "    local a,b,c = 0B101, 0b101.1, 0b1P-3 -- a,b,c = 5, 5.5, 0.125\n"..
               "    local d,e = 0o21.1, 0O0.12P1 -- local d,e = 17.125, 20\n\n"..
               "Formats have full suport of floating point and binary exponenta.",
        dependecies="cssc"},

	cssc= {
        name="C SuS SuS Language Core",
        path="modules/cssc.lua",
        desc="C SuS SuS Programming Language(Very Suspicious C++)\n..
             "    - pseudo coding language based on Lua 5.1.\n\n"..
             "The main purpouse of this \"Language\" is to expand default Lua functional and\n"..
             "make coding in Lua a bit more comfy than it was before."
             "This module injects new operators and syntax construction into Lua syntax pool.\n\n"..
             "The main reason why this project called \"C SuS SuS Framework\".\n\n"..
             "P.S. Module have no support for `goto` and `:: label ::` from Lua 5.2\n"..
             "so better not to place any custom syntax near it (at least for now).",
        dependecies="dq_base,iterator,parcer,space_handler,lua_base,struct,cdata,event,level,framework"},

	dbg_hl  = {
        name="Debug Highlight",
        path="modules/sys/dbg_hl.lua",
        desc="Specific module. Still in development, can highlight code.",
        dependecies="dq_base,iterator,parcer,space_handler,lua_base,struct,sys"},

	err     = {
        name = "Error Detection",
        path = "modules/sys/err.lua",
        desc = "Errors are logged by framework by default, but it will not stop it's work, or inform you about them.\n"..
               "This system blocks compilation after firs error detected. Recomended to use!",
        dependecies="sys"},

	sys     = { 
        name="Sys",
        path="modules/sys.lua",
        desc=[[Handler for service and debug modules]],
        dependecies="framework"},

        minify = {
        name = "Basic Minify",
        path = "modules/minify.lua",
        desc = "Standalone module used to remove unnesesary spaces and comments from code.\n"..
               "Good for systems where every byte matters.",
        dependecies ="dq_base,iterator,make_react,parcer,space_handler,struct,framework"},

    framework = {
        name = "C SuS SuS Framework",
        path = "cssc__craft_os__original.lua",
        desc = "Main project module.\n"..
               "Data processing framework used to work with any data.\n"..
               "Combines and loads modules.",
        dependecies=""}
}
--#endregion All Files

local try_get_file= function(url)
	local res,rez = http.checkURL(url)
	if not res then return -2 end
	res = http.get(url)
	if not res then return -3 end
	rez=res.readAll()
	res.close()
	return rez or -4
end

for k,v in pairs(files)do
	local r=try_get_file(repo..v)
	print(v)
	print()
	print(err_codes[r]or r)
end