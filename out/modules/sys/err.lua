local format,unpack,error = ENV(3,10,15) 
Control.error = function(str,...)
	local l={...}
	Control.Iterator=function()
		error("cssc_beta["..(Control.line or"X").."]:"..format(str,unpack(l)),3)
	end
end
return 1