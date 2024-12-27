local match,insert,remove,unpack,type,native_load,placeholder_func = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_TYPE__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__)
--code parceing system

local lvl, opt, kwrd, ll, cl= C:load_libs"text.dual_queue" --invoke loader and open dirs "text.dual_queue" (as one 'dir')
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

	ll(--continue loading
		"cdata",opt,lvl,placeholder_func)()-- empty call -> go back to main dir ""
	.common --open dir "common"
		"event"(
	    "level",lvl)
ll=nil -- destroy loader so GC can remove it

-- in Lua5.1 weird "Ambigoius syntax error" exist that forces me to 
--		"event"( --it's very important to place "(" right after '"event"' without any `\n`. Or else error will happen! Same for other "("
--		"level",lvl)

-- single lib loading example:
-- C:load_lib"text.dual_queue.base"

--code editing basic api
cl={inject = function(id,obj,tp,...)
		if"string"~=type(id)then insert(Result,id,obj) Cdata.reg(tp,id,...) --id exist
		else insert(Result,id) Cdata.reg(obj,nil,tp,...)end --id is #Result
	end,
	eject = function(id)
		return {remove(Result,id),unpack(remove(Cdata,id))}
	end}
C.Cssc=cl

--important lua code markers
local meta_reg = C:load_lib("code.lua.meta_opt",
	function(mark)
		--temporaly remove last text element
		local temp = remove(Result)
		--insert markers
		cl.inject("" --@@DEBUG .."--[["..(mark>0 and"cl"or"st").." mrk]]"
		,__OPERATOR__,mark>0 and opt[":"][1] or 0)

		--init events
		Event.run(__OPERATOR__,"",__OPERATOR__)
		Event.run("all","",__OPERATOR__)

		--return prewious text element back
		insert(Result,temp)
	end)

--core setup
--DEPRECATED: local t={__WORD__,__KEYWORD__,__NUMBER__,__STRING__,__VALUE__}
local tb=Cdata.skip_tb
--t=t_swap(t)
C.Core=function(tp,obj)--type_of_text_object,object_it_self
	local id_prew,c_prew,spifc=Cdata.tb_while(tb)
	--if c_prew[1]==__KEYWORD__ and match(Control.Result[id_prew],"^end") then print(id_prew,c_prew[2],Control.Result[id_prew],Control.Result[c_prew[2]])end
	spifc = c_prew[1]==__KEYWORD__ and match(Result[id_prew]or"","^end") and match(Result[c_prew[2]]or"","^function")
	meta_reg(c_prew[1],tp,spifc)--reg *call*/*stat_end* operator markers (injects before last registered CData)
	Cdata.run(obj,tp)--reg previous result CData

	Event.run(tp,obj,tp)--single event for single struct
	--DEPRECATED: if t[tp]then Control.Event.run("text",obj,tp)end --for any text code values
	Event.run("all",obj,tp)-- event for all structs
	
	Level.ctrl(obj)--level ctrl
end

insert(PostRun,function()
	cl.inject("",__OPERATOR__,0)
	Event.run(__OPERATOR__,"",__OPERATOR__)
	Event.run("all","",__OPERATOR__)
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


