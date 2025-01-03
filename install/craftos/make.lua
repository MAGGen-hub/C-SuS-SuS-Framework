
-- Basic file loader
local err_codes={[-2]="Broken URL",[-3]="No responce",[-4]="No result"}
local try_get_git_file= function(url)
	local res,rez = http.checkURL(url)
	if not res then return -2 end
	res = http.get(url)
	if not res then return -3 end
	rez=res.readAll()
	res.close()
	return rez or -4
end

-- Load files right from git
local make_git_require = function(repo_url,display_name,log)
    display_name=display_name or"X"
    local s,Print,Write,f,w=""
    Print=log and function()end or print
    Write=log or write
    f = function(obj)
        local res,out = pcall(require,obj)
        if res then return out end
        if w then Print"Loading..."end Write(s.."GitR["..display_name.."]:"..obj..".lua - ")
        w=true
        s=s.."    "
        local git_file = try_get_git_file(repo_url..obj..".lua")
        if err_codes[git_file] then Print"Failure" error("Cant reach["..git_file.."]: "..repo_url..obj..".lua")end
        func,err = load(git_file,"@git:"..obj..".lua",nil,setmetatable({require=f},{__index=_G}))
        if err then  Print"Failure" error("Git err:"..err)end
        res,out=pcall(func)
        if not res then  Print"Failure" error("Git err"..out) end
        package.loaded[obj]=out Print("Success"..(w and""or(": "..obj..".lua")))
        s=s:sub(1,-5)
        w=false
        return out
    end
    return f
end

--load PrimeUI
if not PrimeUI then
    write("@PrimeUI:0/22")
    local PrimeUI_repo,i = "https://raw.githubusercontent.com/MCJack123/PrimeUI/refs/heads/master/",1
    local PrimeUI_require = make_git_require(PrimeUI_repo,"PrimeUI",function()
        local x,y = term.getCursorPos()
        term.setCursorPos(10,y)
        write(i.."/22")i=i+1
    end)
    local PrimeUI = PrimeUI_require("init")
    _G.PrimeUI=PrimeUI print()
end
 

--[====[
local cssc_repo
do
    local cssc_name   = "C_SuS_SuS_Framework"
    local cssc_branch = "master"
    cssc_repo   = 
end

--#region All C SuS SuS Files
local af = {
    op_stack = {
        name = "Custom operators stack system",
        path = "features/code/cssc/op_stack.lua",
        desc = "Libruary used to inject custom operators into code.\n"..
               "Turns custom operators into parcable by lua function calls.",
        dependecies="framework"},
    runtime  = {
        name = "Runtime functions",
        path = "features/code/cssc/runtime.lua",
        desc = "Librury to inject specific local functions into Lua script\n"..
               "to run them in runtime as parts of loaded script.",
        dependecies="framework"},
    typeof   = {
        name = "Custom type support",
        path = "features/code/cssc/typeof.lua",
        desc = "Provides function with custom types support.\n"..
               "Uses {__type} metamethod to work.",
        dependecies="framework"},

    lua_base = {
        name = "Lua base syntax",
        path = "features/code/lua/base.lua",
        desc = "Libruary with Lua 5.1 syntax and it's data.",
        dependecies="syntax_loader,framework"},
    meta_opt = {
        name = "Lua meta markers",
        path = "features/code/lua/meta_opt.lua",
        desc = "Specific libruary that detects markers\n"..
               "that usualy unseen by user:\n"..
               "    call marker, statment marker.\n",
        dependecies="framework"},
    struct   = {
        name = "Lua structures",
        path = "features/code/lua/struct.lua",
        desc = "Libruary that detects all Lua5.1 structures such as\n"..,
               "strings, numbers, comments, unfinished strings..."
        dependecies="framework"},

    cdata         = {
        name = "Code data system",
        path = "features/code/cdata.lua",
        desc = "Libruary used to store code data.\n"..
               "Text obj type, operators priority, code blocks makrers...",
        dependecies="framework"},
    syntax_loader = {
        name = "Syntax loader",
        path = "features/code/syntax_loader.lua",
        desc = "Helper libruary to load language syntax from single string.",
        dependecies="framework"},

    level = {
        name = "Basic structure tree",
        path = "features/common/level.lua",
        desc = "Libruary that used to mimic algoritmic tree,\n"..
               "that usualy can be meet in common parceing systems.\n"..
               "Probably can be used not only with text.",
        dependecies="framework"},
    event = {
        name = "Event handling system",
        path = "features/common/event.lua",
        desc = "Even reg/run system.\n"..
               "Probably can be used not only with text.",
        dependecies="framework"},

    dq_base       = {
        name = "Dual Queue - base constructor",
        path = "features/text/dual_queue/base.lua",
        desc = "Dual queue - text separation system.\n"..
               "Split text into two queues, one with words and numbers,\n"..
               "and one with symbols/punctuation.\n\n"..
               "Base part of this liburary.",
        dependecies="framework"},
    iterator      = {
        name = "Dual Queue - interator",
        path = "features/text/dual_queue/iterator.lua",
        desc = "Dual queue - text separation system.\n"..
               "Split text into two queues, one with words and numbers,\n"..
               "and one with symbols/punctuation.\n\n"..
               "Iterator block of this liburary.",
        dependecies="framework"},
    make_react    = {
        name = "Dual Queue - text object reaction constructor",
        path = "features/text/dual_queue/make_react.lua",
        desc = "Dual queue - text separation system.\n"..
               "Split text into two queues, one with words and numbers,\n"..
               "and one with symbols/punctuation.\n\n"..
               "Constructor to create reaction for found word/symbol.",
        dependecies="framework"},
    parcer        = {
        name = "Dual Queue - parcer"
        path = "features/text/dual_queue/parcer.lua"
        desc = "Dual queue - text separation system.\n"..
               "Split text into two queues, one with words and numbers,\n"..
               "and one with symbols/punctuation.\n\n"..
               "Parcer block of this libruary.",
        dependecies="framework"},
    space_handler = {
        name = "Dual Queue - space handler",
        path = "features/text/dual_queue/space_handler.lua",
        desc = "Dual queue - text separation system.\n"..
               "Split text into two queues, one with words and numbers,\n"..
               "and one with symbols/punctuation.\n\n"..
               "Block that detects and remove spaces from main queue.",
        dependecies="cssc"},

	BO  = {
        name = "Lua 5.3 Backport operators",
        path = "modules/cssc/BO.lua",
        desc = "Module that provides FULL support of Lua 5.3 operators:\n"..
               "    `>>`, `<<`, `|`, `&`, `~`, `unary~`, `//`\n"..
               "Can work in two modes ->\n"..
               "    Normal - with metamethods support\n"..
               "    Direct - faster, but with no metamethods\n"..
               "Thouse operators just a little bit slower than original Lua 5.3,\n"..
               "But it's realy hard to notice, especially in small projects\n"..
               "P.S. This module requres bit/bit32/bitop libruary to work. (choose one)",
        dependecies="runtime,op_stack,cssc"},
	CA  = {
        name = "C Additional assignment",
        path = "modules/cssc/CA.lua",
        desc = "Adds additional assignment with behaviour from C/C++.\n"..
               "    `+=`, `-=`, `/=`, `*=`, `..=`, `^=`, `||=`, `&&=`\n\n"..
               "This module aslo provides next set of operators\n"..
               "if `Backport operators` module was enabled before:\n"..
               "    `>>=`, `<<=`, `|=`, `&=`, `//=`\n"..
               "    (no `XOR` case `~=` is `NOT_EQUAL`)\n\n"..
               "This module also provides `?=` operator:\n"..
               "Sets value to variable ONLY if it has `nil` value before.\n\n"..
               "P.S. This module still have no support for lua multy-assignment,\n"..
               "So `a,b,c X= 1,2,3` is prohibited at this moment.",
        dependecies="runtime,op_stack,cssc"},
	DA  = {
        name = "Default function arguments",
        path = "modules/cssc/DA.lua",
        desc = "Module that adds strict typing and default arguments\n"..
               "to function constructor:\n"..
               "    function(a, b :string, c:'string,number' = 12) *code* end\n"..
               "This function has three args:\n"..
               "    b - can only be a string\n"..
               "    c - can be a string or number\n"..
               "        if c==nil - it will be replaced with value `12`\n"..
               "P.S. This module has custom types support.",
        dependecies="runtime,typeof,cssc"},
	IS  = {
        name = "IS Keyword",
        path = "modules/cssc/IS.lua",
        desc = "Module that provides IS keyword for type checking:\n"..
               "    foo = bar is 'string'\n"..
               "    foo = bar is {'string','number'}\n"..
               "First line checks if `bar` has `string` type,\n"..
               "Second line checks if `bar` has `string` or `number` type.",
        dependecies="runtime,op_stack,typeof,cssc"},
	KS  = {
        name = "Keyword Sortcuts",
        path = "modules/cssc/KS.lua",
        desc = "Experimental module. Provides symbolic shortcuts for common lua keyword.\n"..
               "    @  -> local\n"..
               "    !  -> not, || -> or, && -> and\n"..
               "    $  -> return\n"..
               "    ;  -> end, \\; -> ;\n"..
               "    /| -> if, ? -> then\n"..
               "    :| -> elseif \n"..
              "    \\| -> else\n"..
               "P.S. For a lot of people this feature looks VERY cursed, so\n"..
               "by default only `!`, `||`, `&&` are avaliable.",
        dependecies="cssc"},
	LF  = {
        name = "Lambda functions",
        path = "modules/cssc/LF.lua",
        desc = "Module that provides lambda functions:\n"..
               "    f1= a,b -> a,b end\n"..
               "    f2= (s) -> s..'str' end\n"..
               "    f3= ()  => return a end\n"..
               "Good for usage in functions like `string.gsub`, `string.gmatch`\n"..
               "P.S. It's recomended to use this module with `Keyword Sortcuts`\n"..
               "so lambdas can look like that: `local f = ()->'rez';`",
        dependecies="cssc"},
	NC  = {
        name = "Nil checking operators",
        path = "modules/cssc/NC.lua",
        desc = "Operators that used for auto nil checking.\n"..
               "    `obj?:func()` , `obj?.idx`, `obj?'str'`\n"..
               "    `obj?(*args*)`, `obj?{}`  , `obj?\"str\"`\n"..
               "if `obj==nil` next call/index will not produce\n"..
               "`attempt to *action* 'nil'` error and just return nil."
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

	cssc = {
        name = "C SuS SuS Language Core",
        path = "modules/cssc.lua",
        desc = "C SuS SuS Programming Language(Very Suspicious C++)\n..
              "    - pseudo coding language based on Lua 5.1.\n\n"..
              "The main purpouse of this \"Language\" is to expand default Lua functional and\n"..
              "make coding in Lua a bit more comfy than it was before."
              "This module injects new operators and syntax construction into Lua syntax pool.\n\n"..
              "The main reason why this project called \"C SuS SuS Framework\".\n\n"..
              "P.S. Module have no support for `goto` and `:: label ::` from Lua 5.2\n"..
              "so better not to place any custom syntax near it (at least for now).",
        dependecies="dq_base,iterator,parcer,space_handler,lua_base,meta_opt,struct,cdata,event,level,framework"},

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



for k,v in pairs(files)do
	local r=try_get_file(repo..v)
	print(v)
	print()
	print(err_codes[r]or r)
end]====]