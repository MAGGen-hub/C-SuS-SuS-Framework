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
	Control:load_lib"common.event"
	Control:load_lib("common.level",lvl) --auto-loaded with "code.priority"
	Control:load_lib("code.priority",opt,Control:load_lib"code.lua.priority_affect")
	
	--core setup
	local t={__WORD__,__KEYWORD__,__NUMBER__,__STRING__,__VALUE__}
	t=swap(t)
	Control.Core=function(tp,obj)--type_of_text_object,object_it_self
		
		Control.Event.run(tp,obj,tp)--single event for single struct
		if t[tp]then Control.Event.run("text",obj,tp)end --for any text code values
		Control.Event.run("all",obj,tp)-- event for all structs
		
		Control.Priority.run(obj,tp)--priority ctrl
		Control.Level.ctrl(obj)--level ctrl
	end
end
