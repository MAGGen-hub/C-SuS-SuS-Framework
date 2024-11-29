local gmatch,unpack,placeholder_func = ENV(1,10,23)
--simple function to load syntax data
return 2,function(str,f)
	local mode,t=placeholder_func,{}
	for o,s in gmatch(str,"(.-)(%s)")do
		t[#t+1]=o
		if s=="\n"then
			mode=#t==1 and f[o]or mode(unpack(t))or mode
			t={}
		end
	end
end