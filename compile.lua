-- #region Desctiption
-- CSSC_LUA-MC_COMPILLER1.1 (L-make)
-- Required System Parameters:
--
-- LinuxOS 
-- IntelCoreI3
-- RAM 4Gb
-- -- or other with same or gather computing power
-- 
-- Required Libs (depends on version)
-- lua-Jit
-- lua5.1
-- lua5.2
-- lua5.3
-- lua5.4
-- craftos-pc
-- craftos-pc-data
-- bit32-lua51
-- bitop-lua51
-- libcompat51 --for tests
-- libcompat52
-- os.execute-plugin --for craft os related tests
--
-- Required compilling/testing ENV/IDE: CraftOS-pc - latest
-- #endregion

--PROJECT DATA
local project_name = "cssc_beta"
local version	  = "4.5-beta"
local version_num  = 4.5

--COMPILE DATA
local work_dir	 = "/cssc_final"
local src_dir	  = fs.combine(work_dir,"src")
local out_dir	  = fs.combine(work_dir,"out")
local protect_src  = fs.combine(src_dir ,"protection_and_variable_layer.lua")
local base_src	 = fs.combine(src_dir ,"new_base.lua")
local features_src = fs.combine(src_dir ,"features")
local modules_src  = fs.combine(src_dir ,"modules")
local macro_src	= fs.combine(src_dir ,"common_macro.csv")
local test_src	 = "tests/tests.lua"
local lzss_src	 = "lzss_lib/lzss.lua"
local lzss_sep_src = "lzss_lib/sep_make.lua"
local macro={
	--Bit32/bit
	"__BIT32_LIBRUARY_VERSION_MACRO__",
	"__BIT32_LIBRUARY_VERSION_MACRO_MINIFIED_LOAD_PART__",
	"__BIT32_LIBRUARY_VERSION_MACRO_MINIFIED_VARIABLE_NAME__",
	"__BIT32_LIBRUARY_VERSION_MACRO_MINIFIED_VARIABLE_VALUE__",
	--Native Load
	"__NATIVE_LOAD_VERSION_MACRO__",
	"__NATIVE_LOAD_VERSION_MACRO_MINIFIED__",
	--Unpack Method
	"__UNPACK_MACRO__",
	"__UNPACK_MACRO_MINIFIED__",
}

--COMPILE CONFIG
local config ={
	--minification function to decrase code size
	minify={--WARNING!: temporaly unavaliable. 
		locals_minify = true, --turns local variables and some other stuff into unredable mess but saves a lot of space
		basic_minify  = true, --remove comments and unnesesary spaces
	},
	--compilation function
	compile = {
		craft_os = true,  --default C SuS SuS for CraftOS
		lua51   = true, --optimised for specific Lua version use
		lua52   = true, 
		--[==[
		lua53   = false, 
		lua54   = false,
		Lua_Jit  = false]==]
	}, 
	debug=true --if true then @@DEBUG macro will be compilled and inserted in code (required some times)
}
-- #region Undone Features
--[===[ 
--lzss archiver function to decrase code size
local compile_lzss = {--WARNING!: temporaly unavaliable. 
	pre_compress = false, -- Replace common stuff with bytes before compressing
	default	  = false, -- Default LZSS version
	SEP		  = false} -- Self extracting program

--testing function
local run_tests = {--WARNING!: temporaly unavaliable. (other test system setup)
	craft_os = true,
	lua51   = false,
	lua52   = false,
	lua53   = false,
	lua54   = false,
	Lua_Jit  = false}]===]
-- #endregion

--OUTPUT_FILE_NAME_DEFINE:  <__PROJECT_NAME__>_api<version_number>.<minification_type>.<compile_type>.<extension>

-- #region COMPILATOR FUNCS
local function get_src(src)
	local file = fs.open(src,"r")
	local str = file.readAll()
	file.close()
	return str
end
local function set_out(out,data)
	local file,err = fs.open(out,"w")
	file.write(data)
	file.close()
end

local compile_macros=function(code_name,code)
	--COMPILE MACROS
	if code_name then
		for k,v in pairs(macro)do
			code=code:gsub(v,get_src(fs.combine(src_dir,code_name,v..".lua")))
		end
	end
	get_src(macro_src):sub(16):gsub("\n+(.-),(.-),.-",function(name,value)code=code:gsub(name,value)end)
	--SET PROJECT NAME
	code=code:gsub("__PROJECT_NAME__",project_name)
	return code
end
local compile_dir
compile_dir = function(src_dir,out_dir,sub_dir)
	local new_dir = fs.combine(out_dir,sub_dir)
	if not(fs.exists(new_dir) and fs.isDir(new_dir))then
		--if fs.exist(new_dir)then fs.delete() end
		fs.makeDir(new_dir)
	end
	for k,v in pairs(fs.list(src_dir))do --for each file/dir
		local obj = fs.combine(src_dir,v)
		if fs.isDir(obj) then compile_dir(obj,new_dir,v)--dir
		else
			local src = get_src(obj)--file
			src=compile_macros(nil,src)
			set_out(fs.combine(new_dir,v),src)
			--print("Compile:",fs.combine(new_dir,v))
		end
	end
end
local minify_dir,minifier
minify_dir = function(src_dir)
	for k,v in pairs(fs.list(src_dir))do
		local obj = fs.combine(src_dir,v)
		if fs.isDir(obj) then minify_dir(obj)
		else
			local src = get_src(obj)
			src=minifier(src,obj)
			set_out(obj,src)
			--print("Minify:",obj)
		end
	end
end
local size_dir
size_dir = function(src_dir)
	local sz=0
	for k,v in pairs(fs.list(src_dir))do
		local obj = fs.combine(src_dir,v)
		if fs.isDir(obj) then sz=sz + size_dir(obj)
		else
			local src = get_src(obj)
			sz=sz+#src
		end
	end
	return sz
end
-- #endregion COMPILATOR FUNCS

--COMPILE:

--MAKE_FEATURES
compile_dir(features_src,out_dir,"features")
--MAKE_MODULES
compile_dir(modules_src,out_dir,"modules")
--COMPILE BASE
for code_name,enabled in pairs(config.compile) do
	if enabled then
		--GET CODE
		local code = table.concat{get_src(protect_src),get_src(base_src)}--,get_src(cores_src),get_src(modules_src)}

		code=compile_macros(code_name,code)
		--REMOVE DEBUG
		if config.debug then
			code=code:gsub("@@DEBUG_START",""):gsub("@@DEBUG_END",""):gsub("@@DEBUG","")
		else
			code=code:gsub("@@DEBUG_START.-@@DEBUG_END",""):gsub("@@DEBUG.-\n","")
		end
		code=code:gsub("__BASE_PATH__",code_name=="craft_os" and"'/cssc_final/out/'" or "'/home/maggen/.local/share/craftos-pc/computer/0/cssc_final/out/'")
		code=code:gsub("__VERSION__",version)
		--SET OUT
		set_out(fs.combine(out_dir,table.concat({project_name,code_name,"original"},"__")..".lua"),code)
	end
end

shell.run("/cssc_final/out/cssc_beta__craft_os__original.lua")

--MINIFY_DIR
if config.minify.locals_minify then
	local minify_cfg,e =load(get_src(fs.combine(work_dir,"minify_cfg.lua")))
	--[[print(minify_cfg,e)]]
	minify_cfg=minify_cfg()
	local for_all,for_each = minify_cfg.for_all,minify_cfg.for_each
	minifier=function(s,path)
		for i=1,#for_all,2 do
			s=s:gsub(for_all[i],for_all[i+1])
		end
		path=path:gsub("^"..out_dir.."/","")
		path = for_each[path]or{}
		for i=1,#path,2 do
			s=s:gsub(path[i],path[i+1])
		end
		return s
	end
	minify_dir(out_dir)--advanced local minify
end
if config.minify.basic_minify then
	local comp1 = cssc_beta.make"minify"
	minifier= function(s)return comp1:run(s)end
	minify_dir(out_dir)--basic space/comments minify
end

-- calculate SIZE
local f_size = size_dir(out_dir,"features")
local m_size = size_dir(out_dir,"modules")
local size = (f_size + m_size) / 1024
print(string.format ("Libs size: %3.3f Kbs - %1.3f%% of 2Mbs",size,size/(1024*2)*100))
for code_name,enabled in pairs(config.compile) do
	if enabled then
		local name = table.concat({project_name,code_name,"original"},"__")..".lua"
		local size = fs.getSize(fs.combine(out_dir,name))/1024
		print(string.format ("%-35s size: %3.3f Kbs  - %1.3f%% of 2Mbs",name,size,size/(1024*2)*100))
	end
end
shell.run("/cssc_final/out/cssc_beta__craft_os__original.lua")