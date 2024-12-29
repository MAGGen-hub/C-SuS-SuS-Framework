local Sm,Sg,Ss,Ti,Tc,Gp=ENV(2,5,6,7,8,13)local colors,rep,print,term=_G.colors,_G.string.rep,_G.print,_G.term
local mod,arg=...
if"string"~=Gt(_G._HOST)or not Sm(_G._HOST,"^ComputerCraft")then
Control.error("Attempt to load debug hilighting module outside of CraftOS environment!")return
end
local rep=string.rep
local blit_ctrl={space={colors.toBlit(colors.white)," "},[3]={colors.toBlit(colors.white)," "},[4]={colors.toBlit(colors.yellow)," "},[2]={colors.toBlit(colors.lightBlue)," "},[1]={colors.toBlit(colors.lightBlue)," "},[11]={colors.toBlit(colors.green)," "},[8]={colors.toBlit(colors.cyan)," "},[9]={colors.toBlit(colors.magenta)," "},[10]={colors.toBlit(colors.magenta)," "},[6]={colors.toBlit(colors.lime)," "},[7]={colors.toBlit(colors.red)," "},[12]={colors.toBlit(colors.purple)," "},}Control.BlitBack={}Control.BlitFront={}local burn_blit=function(tp,len)tp=blit_ctrl[tp]or{" "," "}len=len or#Control.Result[#Control.Result]Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)end
Control:load_lib"text.dual_queue.base"Control:load_lib"text.dual_queue.parcer"Control:load_lib"text.dual_queue.iterator"Control:load_lib"text.dual_queue.space_handler"for _,v in Gp(arg or{})do
if v=="lua"then
Control:load_lib("code.lua.base",Control.Operators,Control.Words)Control:load_lib"code.lua.struct"end
end
local sp_h=Tr(Control.Struct,1)Ti(Control.Struct,1,function()local pl=#Control.Result[#Control.Result]sp_h(Control)burn_blit("space",#Control.Result[#Control.Result]-pl)end)Control.Core=function(tp)local len=#Control.Result[#Control.Result]if(to==9)then print(br)end
burn_blit(tp)end
Control.BlitData={}Ti(Control.PostRun,function()Control.BlitData={}local rez,blit,back=Tc(Control.Result).."\n",Tc(Control.BlitFront).." ",Tc(Control.BlitBack).." "rez=Ss(rez,-1)=="\n"and rez or rez.."\n"Sg(rez,"()(.-()\n)",function(st,con,nd)Ti(Control.BlitData,{Sg(con,".$","\x14"),Ss(blit,st,nd-1)..colors.toBlit(colors.lightBlue),Ss(back,st,nd)})end)end)local min=function(a,b)return a<b and a or b end
Control.debug_highlight=function(st,nd)local fn=#Control.BlitData
nd=min(nd or fn,fn)st=(st or 0)>0 and st or 1
for i=st,nd do
term.blit(Tu(Control.BlitData[i]))print()end
end
Control.Return=function()if(Control.args[1]=="l_now")then Control.debug_highlight()end return Control.BlitData end
Ti(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)