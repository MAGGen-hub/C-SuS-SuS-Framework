local match,insert,remove,unpack,native_load,placeholder_func = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_REMOVE__,__ENV_UNPACK__,__ENV_LOAD__,__ENV_PLACEHOLDER_FUNC__)
--code parceing system
Control:load_lib"text.dual_queue.base"
Control:load_lib"text.dual_queue.parcer"
Control:load_lib"text.dual_queue.iterator"
Control:load_lib"text.dual_queue.space_handler"

--base lua data (structs/operators/keywords)
local lvl, opt, kwrd = Control:load_lib("code.lua.base",Control.Operators,Control.Words)
Control:load_lib"code.lua.struct"

--load analisys systems
Control:load_lib("code.cdata",opt,lvl,placeholder_func)
Control:load_lib("common.event")
Control:load_lib("common.level",lvl)

--code editing basic api
Control.inject = function(id,obj,type,...)
	if id then insert(Control.Result,id,obj) else insert(Control.Result,obj)end
	Control.Cdata.reg(type,id,...)
end
Control.eject = function(id)
	return {remove(Control.Result,id),unpack(remove(Control.Cdata,id))}
end

--important lua code markers
local meta_reg = Control:load_lib("code.lua.meta_opt",
	function(mark)
		--temporaly remove last text element
		local temp = remove(Control.Result)
		--insert markers
		Control.inject(nil,"" --@@DEBUG .."--[["..(mark>0 and"cl"or"st").." mrk]]"
		,__OPERATOR__,mark>0 and opt[":"][1] or 0)

		--init events
		Control.Event.run(__OPERATOR__,"",__OPERATOR__)
		Control.Event.run("all","",__OPERATOR__)

		--return prewious text element back
		insert(Control.Result,temp)
	end)

--core setup
--DEPRECATED: local t={__WORD__,__KEYWORD__,__NUMBER__,__STRING__,__VALUE__}
local tb=Control.Cdata.skip_tb
--t=t_swap(t)
Control.Core=function(tp,obj)--type_of_text_object,object_it_self
	local id_prew,c_prew,spifc=Control.Cdata.tb_while(tb)
	--if c_prew[1]==__KEYWORD__ and match(Control.Result[id_prew],"^end") then print(id_prew,c_prew[2],Control.Result[id_prew],Control.Result[c_prew[2]])end
	spifc = c_prew[1]==__KEYWORD__ and match(Control.Result[id_prew]or"","^end") and match(Control.Result[c_prew[2]]or"","^function")
	meta_reg(c_prew[1],tp,spifc)--reg *call*/*stat_end* operator markers (injects before last registered CData)
	Control.Cdata.run(obj,tp)--reg previous result CData

	Control.Event.run(tp,obj,tp)--single event for single struct
	--DEPRECATED: if t[tp]then Control.Event.run("text",obj,tp)end --for any text code values
	Control.Event.run("all",obj,tp)-- event for all structs
	
	Control.Level.ctrl(obj)--level ctrl
end

insert(Control.PostRun,function()
	Control.inject(nil,"",__OPERATOR__,0)
	Control.Event.run(__OPERATOR__,"",__OPERATOR__)
	Control.Event.run("all","",__OPERATOR__)
	Control.Level.fin()
end)--fin level

Control.cssc_load=function(x,name,mode,env)
	x=x==Control and Control.Return()or x
	env=Control.Runtime and Control.Runtime.mk_env(env) or env --Runtime Env support
	return native_load(x,name,mode,env)
end

return {--module aliases
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
	number_formats="NF"
}


