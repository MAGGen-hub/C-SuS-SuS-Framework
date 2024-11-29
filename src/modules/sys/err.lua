local format,unpack,error = ENV(__ENV_FORMAT__,__ENV_UNPACK__,__ENV_ERROR__) 
Control.error = function(str,...)
	local l={...}
	Control.Iterator=function()
		error("__PROJECT_NAME__["..(Control.line or"X").."]:"..format(str,unpack(l)),3)
	end
end
--return __TRUE__