function(Control)
	--code parceing system
	Control:load_lib"text.dual_queue.base"
	Control:load_lib"text.dual_queue.parcer"
	Control:load_lib"text.dual_queue.iterator"
	Control:load_lib"text.dual_queue.space_handler"
	
	--base lua data (structs/operators/keywords)
	local lvl, opt, kwrd = Control:load_lib("code.lua.base",Control.Operators,Control.Words)
	Control.get_num_prt,Control.split_seq=Control:load_lib"code.lua.struct"
	
	--load analisys systems

	Control:load_lib("code.cdata",opt,lvl,placeholder_func)
	Control:load_lib("common.event")
	Control:load_lib("common.level",lvl)
	Control.inject = function(id,obj,type,...)
		if id then insert(Control.Result,id,obj) else insert(Control.Result,obj)end
		Control.Cdata.reg(type,id,...)
	end
	Control.eject = function(id)
		return {remove(Control.Result,id),unpack(remove(Control.Cdata,id))}
	end
	--core setup
	local t={__WORD__,__KEYWORD__,__NUMBER__,__STRING__,__VALUE__}
	t=t_swap(t)
	Control.Core=function(tp,obj)--type_of_text_object,object_it_self
		
		Control.Cdata.run(obj,tp)
		Control.Event.run(tp,obj,tp)--single event for single struct
		if t[tp]then Control.Event.run("text",obj,tp)end --for any text code values
		Control.Event.run("all",obj,tp)-- event for all structs
		
		--Control.Priority.run(obj,tp)--priority ctrl
		Control.Level.ctrl(obj)--level ctrl
	end
end
