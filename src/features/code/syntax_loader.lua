local gmatch,unpack,placeholder_func = ENV(__ENV_GMATCH__,__ENV_UNPACK__,__ENV_PLACEHOLDER_FUNC__)
--simple function to load syntax data
return __RESULTABLE__,function(s,f)
	local m,t=placeholder_func,{}
	for o,s in gmatch(s,"(.-)(%s)")do
		t[#t+1]=o
		if s=="\n"then
			m=#t==1 and f[o]or m(unpack(t))or m
			t={}
		end
	end
end