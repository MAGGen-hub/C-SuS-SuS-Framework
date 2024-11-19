{[_init]=function(Ctrl,mod,value)
	--require"cc.pretty".pretty_print(value)
	local l=Ctrl.Loaded
	l= pairs(l)(l) and insert(Ctrl.Log,"Warning: Log wasn't the first loaded module! First logs may disapear!")
	l=Ctrl.log~=placeholder_func and insert(Ctrl.Log,"Waning: Log system override! Errors may apear!")
	Ctrl.log=function(str,...) insert(Ctrl.Log,format(str,...))end
end}
