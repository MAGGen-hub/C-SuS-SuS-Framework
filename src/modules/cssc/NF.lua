local gmatch,match,sub,insert,concat,tostring,tonumber=ENV(__ENV_GMATCH__,__ENV_MATCH__,__ENV_SUB__,__ENV_INSERT__,__ENV_CONCAT__,__ENV_TOSTRING__,__ENV_TONUMBER__)

local e,nan="Number '%s' isn't a valid number!",-(0/0)
local fin_num=function(nd,c)
	nd=concat(nd)
	local f,s,ex=match(nd,"..(%d*)%.?(%d*)(.*)")
	if match(ex,"^[Ee]") then Control.error(e,nd) end --Ee exponenta is prohibited!
	c=(c=="b" or c=="B") and 2 or 8 --bin/oct
	f=tonumber(#f>0 and f or 0,c)--base
	if #s>0 then --float
		local r=0
		for i,k in gmatch(s,"()(.)") do
			if tonumber(k)>=c then s=nan break end  --if number is weird
			r=r+k*c^(#s-i)
		end
		s=s==s and tostring(r/c^#s)
	else s=0 end
	ex=tonumber(#ex>0 and sub(ex,2) or 0,10)--exp
	nd =(f and s==s and ex)and ""..(f+s)*(2^ex)or Control.error(e,nd)or nd
	insert(Control.Result,nd)
	Control.Core(__NUMBER__,nd)
end

insert(Control.Struct,2,function()--this stuff must run before lua_struct and after space_handler parts.
	local c =#Control.operator<1 and match(Control.word,"^0([OoBb])%d")
	if c then
		local num_data,f = {},{0 ..c.."%d","PpEe"}
		if Control.Text.get_num_prt(num_data,f)then fin_num(num_data,c)return true end
		Control.Iterator()
		if Control.operator=="."then
			num_data[#num_data+1]="."
			f[1]="%d"
			Control.Text.get_num_prt(num_data,f)
		end
		fin_num(num_data,c)
		return true
	end
end)
--return __TRUE__