{[_init]=function(Ctrl)--TODO: rework
	Ctrl.Finaliser.err=function()
		if Ctrl.err then Ctrl.rt=1 return nil,Ctrl.err end
	end
end}