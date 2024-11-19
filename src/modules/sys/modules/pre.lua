{[_init]=function(Ctrl,script_id,x,name,mode,env)--TODO: rework
	if not cssc_beta.preload then cssc_beta.preload={}end
	local P=cssc_beta.preload
	if P[script_id] then return native_load(P[script_id],name,mode,env)end
		Ctrl.Finaliser.pre=function()
		P[script_id]=concat(Ctrl.Result) 
	end
end}