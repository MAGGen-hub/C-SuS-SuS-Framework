local gmatch,unpack,placeholder_func = ENV(1,10,22)
--simple function to load syntax data
return 2,function(s,f)
	local m,t=placeholder_func,{}
	for o,s in gmatch(s,"(.-)(%s)")do
		t[#t+1]=o
		if s=="\n"then
			m=#t==1 and f[o]or m(unpack(t))or m
			t={}
		end
	end
end