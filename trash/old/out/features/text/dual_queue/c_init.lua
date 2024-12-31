function(Control)return 2,function(Control,mod)Control:load_lib"text.dual_queue.base"for k,v in Gp(mod.operators or{})do
Control.Operators[k]=v
end
for k,v in Gp(mod.words or{})do
Control.Words[k]=v
end
end
end