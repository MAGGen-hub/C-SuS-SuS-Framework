local match,insert,remove,unpack,type,native_load,placeholder_func,pcall,error = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_TYPE__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__,__ENV_PCALL__,__ENV_ERROR__)
--code parceing system

local l_lvl, l_opt, kwrd, lib_loader, local_cssc, meta_reg, run=C:load_libs"text.dual_queue" --invoke loader and open dirs "text.dual_queue" (as one 'dir')
		"base"
		"parser"
		"iterator"
		"space_handler"() -- empty call -> go back to main dir ""
	.code
		.lua( --open dir code then open dir lua (separately as two 'dirs')
			"base",Operators,Words)
			"struct"()(5,-1) -- empty call -> go back to dir "code"
 -- call with numbers: Close loader and return unpacked result of libruary numbers (5, ...) in loading order. 
 --if number is 0 -> full result table will be returned, -1 (or any other negative val) -> returns loader

 lib_loader(--continue loading
		"cdata",l_opt,l_lvl,placeholder_func)()-- empty call -> go back to main dir ""
	.common --open dir "common"
		"event"(
	    "level",l_lvl)
lib_loader=nil -- destroy loader so GC can remove it

-- in Lua5.1 weird "Ambigoius syntax error" exist that forces me to 
--		"event"( --it's very important to place "(" right after '"event"' without any `\n`. Or else error will happen! Same for other "("
--		"level",lvl)

-- single lib loading example:
-- C:load_lib"text.dual_queue.base"

--code editing basic api
local_cssc={inject = function(index,l_obj,l_tp,...)
		if"string"~=type(index)then insert(Result,index,l_obj) Cdata.reg(l_tp,index,...) --index exist
		else insert(Result,index) Cdata.reg(l_obj,nil,l_tp,...)end --index is #Result
	end,
	eject = function(index)
		return {remove(Result,index),unpack(remove(Cdata,index))}
	end}
C.Cssc=local_cssc

--important lua code markers
meta_reg = C:load_lib("code.lua.meta_opt",
	function(mark,temp)--temporaly remove last text element
		temp = remove(Result)
		--insert markers
		local_cssc.inject("" --@@DEBUG .."--[["..(mark>0 and"cl"or"st").." mrk]]"
		,__OPERATOR__,mark>0 and l_opt[":"][1] or 0)

		--init events
		Event.run(__OPERATOR__,"",__OPERATOR__)
		Event.run("all","",__OPERATOR__)

		--return prewious text element back
		insert(Result,temp)
	end)

--core setup
--t=t_swap(t)
C.Core=function(l_tp,l_obj)--type_of_text_object,object_it_self
	local id_prew,c_prew,spifc=Cdata.tb_while(Cdata.skip_tb)
	--if c_prew[1]==__KEYWORD__ and match(Control.Result[id_prew],"^end") then print(id_prew,c_prew[2],Control.Result[id_prew],Control.Result[c_prew[2]])end
	spifc = c_prew[1]==__KEYWORD__ and match(Result[id_prew]or"","^end") and match(Result[c_prew[2]]or"","^function")
	meta_reg(c_prew[1],l_tp,spifc)--reg *call*/*stat_end* operator markers (injects before last registered CData)
	Cdata.run(l_obj,l_tp)--reg previous result CData

	Event.run(l_tp,l_obj,l_tp)--single event for single struct
	Event.run("all",l_obj,l_tp)-- event for all structs
	
	Level.ctrl(l_obj)--level ctrl
end

insert(PostRun,function()
	local_cssc.inject("",__OPERATOR__,0)
	Event.run(__OPERATOR__,"",__OPERATOR__)
	Event.run("all","",__OPERATOR__)
	Level.fin()
end)--fin level

--override user object functions
User.info="C SuS SuS Compiller"
User.version="4.2-beta"
run,User.run=User.run --replace run with compile
User.compile = function(...)return run(User,...)end
User.load=function(x,name,mode,env)
	if x==User then x=Return()
	elseif not match(x,"^\x1B\x4C") and mode~="c" then --not bytecode and not compilled before -> compilling
		local r r,x=pcall(run,User,x) --compile and redirect compilation errors
		r=not r and error(x,2)--quick err-check
	end
	mode=mode~="c" and mode or nil
	env=Runtime and Runtime.mk_env(env) or env --Runtime Env support
	return native_load(x,name,mode,env)
end

return {--module aliases (and names)
	backport_operators="BO",
	back_opts="BO",
	bitwizes="BO",
	additional_assignment="CA",
	c_like_assignment="CA",
	AA="CA",
	defautl_arguments="DA",
	def_args="DA",
	is_keyword="IS",
	keyword_shortcuts="KS",
	sort_keywords="KS",
	lambda_functions="LF",
	lambda_funcs="LF",
	nil_forgiving="NC",
	nil_checking="NC",
	number_formats="NF",
	number_concat_bug_fix="ncbf"
}


