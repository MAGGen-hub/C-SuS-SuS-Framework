local e,nan,gmatch,match,sub,insert,concat,tostring,tonumber="Number '%s' isn't a valid number!",-(0/0),ENV(1,2,6,7,8,16,17)

-- _ENV == Control

local fin_num=function(nd,c)
	nd=concat(nd)
	local f,s,ex,r=match(nd,"..(%d*)%.?(%d*)(.*)")
	if match(ex,"^[Ee]") then C.error(e,nd) end --Ee exponenta is prohibited!
	c=(c=="b" or c=="B") and 2 or 8 --bin/oct
	f=tonumber(#f>0 and f or 0,c)--base
	if #s>0 then --float
		r=0
		for i,k in gmatch(s,"()(.)") do
			if tonumber(k)>=c then s=nan break end  --if number is weird
			r=r+k*c^(#s-i)
		end
		s=s==s and tostring(r/c^#s)
	else s=0 end
	ex=tonumber(#ex>0 and sub(ex,2) or 0,10)--exp
	nd =(f and s==s and ex)and ""..(f+s)*(2^ex)or C.error(e,nd)or nd
	insert(Result,nd)
	Core(6,nd)
end

insert(Struct,2,function()--this stuff must run before lua_struct and after space_handler parts.
	local c =#C.operator<1 and match(C.word,"^0([OoBb])%d")
	if c then
		local num_data,f = {},{0 ..c.."%d","PpEe"}
		if Text.get_num_prt(num_data,f)then fin_num(num_data,c)return true end
		Iterator()
		if C.operator=="."then
			num_data[#num_data+1]="."
			f[1]="%d"
			Text.get_num_prt(num_data,f)
		end
		fin_num(num_data,c)
		return true
	end
end)
--return 1