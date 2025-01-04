local err_text,nan,gmatch,match,sub,insert,concat,tostring,tonumber="Number '%s' isn't a valid number!",-(0/0),ENV(1,2,6,7,8,15,16)

-- _ENV == Control

local fin_num=function(number_data,base)
	number_data=concat(number_data)
	local full,float,exponenta,r=match(number_data,"..(%d*)%.?(%d*)(.*)")
	if match(exponenta,"^[Ee]") then C.error(err_text,number_data) end --Ee exponenta is prohibited!
	base=(base=="b" or base=="B") and 2 or 8 --bin/oct
	full=tonumber(#full>0 and full or 0,base)--base
	if #float>0 then --float
		r=0
		for i,k in gmatch(float,"()(.)") do
			if tonumber(k)>=base then float=nan break end  --if number is weird
			r=r+k*base^(#float-i)
		end
		float=float==float and tostring(r/base^#float)
	else float=0 end
	exponenta=tonumber(#exponenta>0 and sub(exponenta,2) or 0,10)--exp
	number_data =(full and float==float and exponenta)and ""..(full+float)*(2^exponenta)or C.error(err_text,number_data)or number_data
	insert(Result,number_data)
	Core(6,number_data)
end

insert(Struct,2,function()--this stuff must run before lua_struct and after space_handler parts.
	local mode =#C.operator<1 and match(C.word,"^0([OoBb])%d")
	if mode then
		local number_data,m_data = {},{0 ..mode.."%d","PpEe"}
		if Text.get_num_prt(number_data,m_data)then fin_num(number_data,mode)return true end
		Iterator()
		if C.operator=="."then
			number_data[#number_data+1]="."
			m_data[1]="%d"
			Text.get_num_prt(number_data,m_data)
		end
		fin_num(number_data,mode)
		return true
	end
end)
--return 1