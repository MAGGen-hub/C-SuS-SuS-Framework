{[_init]=function(Ctrl,Value) -- V - argument
	local v=Value
	Ctrl.Finaliser.dbg=function(x,n,m)
		if v=="p"then print(concat(Ctrl.Result))end
		if m=="c"then
			Ctrl.rt=1
			return Ctrl.Result
		elseif m=="s"then
			Ctrl.rt=1
			return concat(Ctrl.Result)
		end
	end
end}