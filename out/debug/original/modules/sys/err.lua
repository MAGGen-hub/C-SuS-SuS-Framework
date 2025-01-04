local format,unpack,error = ENV(3,10,14) 
Control.error = function(str,...)
	local l={...}
	Control.Iterator=function()
		error("cssf["..(Control.line or"X").."]:"..format(str,unpack(l)),3)
	end
end
--return 1