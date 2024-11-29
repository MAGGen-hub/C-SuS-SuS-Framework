function(Control)--default initer placer (has no Control)
	return 2,function(Control,mod)
		Control:load_lib"text.dual_queue.base"
		for k,v in pairs(mod.operators or{})do
			Control.Operators[k]=v
		end
		for k,v in pairs(mod.words or{})do
			Control.Words[k]=v
		end
	end
end