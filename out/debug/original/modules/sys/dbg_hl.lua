local match,gsub,sub,insert,concat,pairs=ENV(2,5,6,7,8,13)
local colors,rep,print,term=_G.colors,_G.string.rep,_G.print,_G.term
local _, arg=...
--OperatorWordSystem-debug utilite
if "string"~=type(_G._HOST) or not match(_G._HOST,"^ComputerCraft") then
	--this module desingned only for CraftOS testing purposes! Loading it outside of CraftOS - prohibited!
	C.error("Attempt to load debug hilighting module outside of CraftOS environment!")
	return
end




--blit C
local rep,blit = string.rep,colors.toBlit --rep func import
local blit_ctrl={
space={blit(colors.white)," "},
[3]={blit(colors.white)," "},
[4]={blit(colors.yellow)," "},
[2]={blit(colors.lightBlue)," "},
[1]={blit(colors.lightBlue)," "},
[11]={blit(colors.green)," "},
[8]={blit(colors.cyan)," "},
[9]={blit(colors.magenta)," "},
[10]={blit(colors.magenta)," "},
[6]={blit(colors.lime)," "},
[7]={blit(colors.red)," "},
[12]={blit(colors.purple)," "},
}
C.BlitBack={}
C.BlitFront={}
local burn_blit=function(tp,len)
	tp=blit_ctrl[tp]or{" "," "}
	len=len or #C.Result[#C.Result]
	C.BlitFront[#C.BlitFront+1]=rep(tp[1],len)
	C.BlitBack[#C.BlitBack+1]=rep(tp[2],len)
end

--load base lib
C:load_libs"text.dual_queue""base""parser""iterator""space_handler"
--lua syntax loading
for _,v in pairs(arg or{})do
	if v=="lua" then
		C:load_libs"code.lua"("base",C.Operators,C.Words)"struct"
	end
end

--edit space handler
local sp_h=remove(C.Struct,1)
insert(C.Struct,1,function()
	local pl=#C.Result[#C.Result]
	sp_h(C)
	burn_blit("space",#C.Result[#C.Result]-pl)
end)
C.Core=function(tp)
	local len =#C.Result[#C.Result]
	if (to==9) then print(br)end
	burn_blit(tp)
end
C.BlitData={}
insert(C.PostRun,function()
	C.BlitData={}
	local rez,blit,back=concat(C.Result).."\n",concat(C.BlitFront).." ",concat(C.BlitBack).." "
	rez=sub(rez,-1)=="\n"and rez or rez.."\n"
	gsub(rez,"()(.-()\n)",function(st,con,nd)
		insert(C.BlitData,{gsub(con,".$","\x14"),
			sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),
			sub(back,st,nd)})--back color
	end)
end)
local min = function(a,b) return a<b and a or b end
C.debug_highlight=function(st,nd)
	local fn = #C.BlitData
	nd = min(nd or fn,fn)
	st = (st or 0)>0 and st or 1
	for i=st,nd do
		term.blit(unpack(C.BlitData[i]))
		print()--new line
	end
end
C.Return=function() if (C.args[1]=="l_now") then C.debug_highlight()end return C.BlitData end
insert(C.Clear,function()C.BlitBack={}C.BlitFront={}end)
--return 1