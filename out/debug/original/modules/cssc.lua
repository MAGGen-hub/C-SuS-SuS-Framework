local match,insert,remove,unpack,type,native_load,placeholder_func = ENV(2,7,9,10,12,20,22)
--code parceing system

local l_lvl, l_opt, kwrd, lib_loader, local_cssc, meta_reg=C:load_libs"text.dual_queue" --invoke loader and open dirs "text.dual_queue" (as one 'dir')
		"base"
		"parcer"
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
local meta_reg = C:load_lib("code.lua.meta_opt",
	function(mark,temp)--temporaly remove last text element
		temp = remove(Result)
		--insert markers
		local_cssc.inject("" --@@DEBUG .."--[["..(mark>0 and"cl"or"st").." mrk]]"
		,2,mark>0 and l_opt[":"][1] or 0)

		--init events
		Event.run(2,"",2)
		Event.run("all","",2)

		--return prewious text element back
		insert(Result,temp)
	end)

--core setup
--t=t_swap(t)
C.Core=function(l_tp,l_obj)--type_of_text_object,object_it_self
	local id_prew,c_prew,spifc=Cdata.tb_while(Cdata.skip_tb)
	--if c_prew[1]==4 and match(Control.Result[id_prew],"^end") then print(id_prew,c_prew[2],Control.Result[id_prew],Control.Result[c_prew[2]])end
	spifc = c_prew[1]==4 and match(Result[id_prew]or"","^end") and match(Result[c_prew[2]]or"","^function")
	meta_reg(c_prew[1],l_tp,spifc)--reg *call*/*stat_end* operator markers (injects before last registered CData)
	Cdata.run(l_obj,l_tp)--reg previous result CData

	Event.run(l_tp,l_obj,l_tp)--single event for single struct
	Event.run("all",l_obj,l_tp)-- event for all structs
	
	Level.ctrl(l_obj)--level ctrl
end

insert(PostRun,function()
	local_cssc.inject("",2,0)
	Event.run(2,"",2)
	Event.run("all","",2)
	Level.fin()
end)--fin level

User.info="C SuS SuS Compiller object"
User.load=function(x,name,mode,env)
	x=x==User and Return()or x
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


