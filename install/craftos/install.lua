

local PrimeUI,PrimeUI_borderBox
local license
local path,install_prog,st_path
--#region GitLoader
local err_codes={[-2]="Broken URL",[-3]="No responce",[-4]="No result"}
local try_get_git_file= function(url)
	local res,rez = http.checkURL(url)
	if not res then return -2 end
	res = http.get(url)
	if not res then return -3 end
	rez=res.readAll()
	res.close()
	return rez or -4
end
--#endregion GitLoader

local install = function()
	--#region C SuS SuS Files
	local files = {
		"features/code/cssc/op_stack.lua",
		"features/code/cssc/runtime.lua",
		"features/code/cssc/typeof.lua",
		--
		"features/code/lua/base.lua",
		"features/code/lua/meta_opt.lua",
		"features/code/lua/struct.lua",
		--
		"features/code/cdata.lua",
		"features/code/syntax_loader.lua",

		"features/common/level.lua",
		"features/common/event.lua",

		"features/text/dual_queue/base.lua",
		"features/text/dual_queue/iterator.lua",
		"features/text/dual_queue/make_react.lua",
		"features/text/dual_queue/parcer.lua",
		"features/text/dual_queue/space_handler.lua",


		"modules/cssc/BO.lua",
		"modules/cssc/CA.lua",
		"modules/cssc/DA.lua",
		"modules/cssc/IS.lua",
		"modules/cssc/KS.lua",
		"modules/cssc/LF.lua",
		"modules/cssc/NC.lua",
		"modules/cssc/ncbf.lua",
		"modules/cssc/NF.lua",
		"modules/cssc.lua",

		"modules/minify.lua",

		"modules/sys/dbg_hl.lua",
		"modules/sys/err.lua",
		"modules/sys.lua",


		"cssc__craft_os__original.lua"
	}
	--#endregion C SuS SuS Files
	local cssc_repo = "https://raw.githubusercontent.com/MAGGen-hub/C-SuS-SuS-Framework/refs/heads/master/"
end
--#region Animation API
local blit_pic=function(pic,x,y,font,back)
	font,back=font or function()end,back or function()end
	for i=1,#pic,3 do
		term.setCursorPos(x,y+i/3)
		term.blit(pic[i],font(pic[i+1]),back(pic[i+2]))
	end
end

local pal_ctrl=function(pal)
	if pal then for i=0,15 do term.setPaletteColor(2^i,unpack(pal[2^i]))end
	else pal={} for i=0,15 do pal[2^i]={term.getPaletteColor(2^i)}end return pal end
end

local color_animate=function(clr,time,steps,r,g,b)
	local R,G,B=term.getPaletteColor(clr)
	local s={r=(r-R)/steps,g=(g-G)/steps,b=(b-B)/steps}
	time=time/steps
	for i=1,steps do
		R,G,B=R+s.r,G+s.g,B+s.b sleep(time)
		term.setPaletteColor(clr,R,G,B)
	end
end

-- Keep pal ctrl

function rainbowPrintEffect(text,delay)
	local next,fg,bg,X,Y,prev=0,term.getTextColor(),term.getBackgroundColor()
	for char in (text.." "):gmatch"."do
		if prev then term.setCursorPos(X-1,Y) term.write(prev) prev=nil end
		if char:find"%s" then  term.write(char)
		else
			repeat next=(next+1)%16 until 2^next ~= fg and 2^next ~= bg
			term.blit(char,colors.toBlit(2^next),colors.toBlit(bg))
			prev=char
			sleep(delay or 0.4)
		end
		X,Y=term.getCursorPos()
	end
end

local pal=pal_ctrl() --variable to keep default pallete unchanged 
local max_x,max_y=term.getSize()

--#endregion Animation API

--#region Splash Screen
local Splash_Screen = function()
	-- Animate background
	term.setPaletteColor(colors.lightBlue,0,0,0) -- lBlue - Set black color for animation
	term.setBackgroundColor(colors.lightBlue)
	term.clear()
	color_animate(colors.lightBlue,1.5,50,unpack(pal[colors.lightBlue]))

	-- Animate "W E L C O M E" message
	term.setCursorPos((max_x-13)/2,max_y/2-4)
	term.setTextColor(colors.red)
	rainbowPrintEffect("W E L C O M E",0.3)

	sleep(0.3) --small delay

	--Animate "t o" message
	term.setCursorPos((max_x-3)/2,max_y/2-2)
	term.setTextColor(colors.blue)
	textutils.slowWrite("t o",5)

	-- Animate C_SuS_SuS splash
	local C_SuS_SuS_print={
		"\x98\x8C\x9B  \x98\x8C\x9B \x20\x20\x20 \x98\x8C\x9B  \x98\x8C\x9B \x20\x20\x20 \x98\x8C\x9B","bb*  ee*     ee*  ee*     ee*","  b    e       e    e       e",
		"\x95\x20\x20  \x89\x8C\x9B \x95\x20\x95 \x89\x8C\x9B  \x89\x8C\x9B \x95\x20\x95 \x89\x8C\x9B","bbb  ee* ee* ee*  ee* ee* ee*","       e   e   e    e   e   e",
		"\x89\x8C\x86  \x89\x8C\x86 \x89\x8C\x86 \x89\x8C\x86  \x89\x8C\x86 \x89\x8C\x86 \x89\x8C\x86","bbb  eee eee eee  eee eee eee","                             "}
	term.setPaletteColor(colors.green,unpack(pal[colors.lightBlue])) -- Green - used as process color
	term.setPaletteColor(colors.lime ,unpack(pal[colors.lightBlue])) -- Lime  - used as process color
	blit_pic(C_SuS_SuS_print,(max_x-28.5)/2,max_y/2,function(a)return a:gsub("*","3"):gsub("b","5"):gsub("e","d") end,function(a)return a:gsub(" ","3"):gsub("b","5"):gsub("e","d") end)
	color_animate(colors.lime ,1,50,unpack(pal[colors.blue]))
	color_animate(colors.green,1,50,unpack(pal[colors.red]))
	blit_pic(C_SuS_SuS_print,(max_x-28.5)/2,max_y/2,function(a)return a:gsub("*","3") end,function(a)return a:gsub(" ","3") end)

	sleep(0.3) --small delay

	-- Hide colors 
	parallel.waitForAll(
		function()color_animate(colors.blue,1.2,40,unpack(pal[colors.lightBlue]))end,
		function()color_animate(colors.red ,1.2,40,unpack(pal[colors.lightBlue]))end)
	term.clear()
end
--#endregion Splash Screen

--#region End Screen
local exit_animation = function()
	parallel.waitForAny(
		function()
			repeat  local ev,key=os.pullEvent"key" 
			if key==keys.space or key==keys.enter then break end
			until false
		end,
		function()
			parallel.waitForAny(
				function()color_animate(colors.blue  ,0.5,50,unpack(pal[colors.lightBlue]))end,
				function()color_animate(colors.cyan  ,0.5,50,unpack(pal[colors.lightBlue]))end,
				function()color_animate(colors.orange,0.5,50,unpack(pal[colors.lightBlue]))end,
				function()color_animate(colors.red   ,0.5,50,unpack(pal[colors.lightBlue]))end)
			term.setBackgroundColor(colors.lightBlue)
			term.clear()
			color_animate(colors.lightBlue,1,50,unpack(pal[colors.black]))
		end)
	pal_ctrl(pal)
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
end
--#endregion End Screen

--#region Download_PrimeUI
-- Load files right from git
local make_git_require = function(repo_url,display_name,log)
    display_name=display_name or"X"
    local s,Print,Write,f,w=""
    Print=log and function()end or print
    Write=log or write
    f = function(obj)
        local res,out = pcall(require,obj)
        if res then return out end
        if w then Print"Loading..."end Write(s.."GitR["..display_name.."]:"..obj..".lua - ")
        w=true
        s=s.."    "
        local git_file = try_get_git_file(repo_url..obj..".lua")
        if err_codes[git_file] then Print"Failure" error("Cant reach["..git_file.."]: "..repo_url..obj..".lua")end
        func,err = load(git_file,"@git:"..obj..".lua",nil,setmetatable({require=f},{__index=_G}))
        if err then  Print"Failure" error("Git err:"..err)end
        res,out=pcall(func)
        if not res then  Print"Failure" error("Git err"..out) end
        package.loaded[obj]=out Print("Success"..(w and""or(": "..obj..".lua")))
        s=s:sub(1,-5)
        w=false
        return out
    end
    return f
end
local Download_PrimeUI = function()
	license = try_get_git_file(cssc_repo.."LICENSE")
	local expect = require"cc.expect".expect
	PrimeUI_borderBox = function(win, x, y, width, height, fgColor, bgColor)
		expect(1, win, "table")
		expect(2, x, "number")
		expect(3, y, "number")
		expect(4, width, "number")
		expect(5, height, "number")
		fgColor = expect(6, fgColor, "number", "nil") or colors.white
		bgColor = expect(7, bgColor, "number", "nil") or colors.black
		-- Draw the top-left corner & top border.
		win.setBackgroundColor(bgColor)
		win.setTextColor(fgColor)
		win.setCursorPos(x - 1, y - 1)
		win.write("\x9F" .. ("\x8F"):rep(width))
		-- Draw the top-right corner.
		win.setBackgroundColor(fgColor)
		win.setTextColor(bgColor)
		win.write("\x90")
		-- Draw the right border.
		for i = 1, height do
			win.setCursorPos(win.getCursorPos() - 1, y + i - 1)
			win.write("\x95")
		end
		-- Draw the left border.
		win.setBackgroundColor(bgColor)
		win.setTextColor(fgColor)
		for i = 1, height do
			win.setCursorPos(x - 1, y + i - 1)
			win.write("\x95")
		end
		-- Draw the bottom border and corners.

		win.setBackgroundColor(fgColor)
		win.setTextColor(bgColor )
		win.setCursorPos(x - 1, y + height)
		win.write("\x82" .. ("\x83"):rep(width) .. "\x81")

		win.setBackgroundColor(bgColor)
		win.setTextColor(fgColor)
	end
	if not _G.PrimeUI then
		--Get PrimeUI-218b28d version (21 Oct 2024 - commit by MCJack123) [stable] - for this project
		local PrimeUI_repo,i = "https://raw.githubusercontent.com/MCJack123/PrimeUI/218b28d4185ddc3ad15594910877eb5f0e858cfd/",1
		local PrimeUI_require = make_git_require(PrimeUI_repo,"PrimeUI",function()end)
		PrimeUI = PrimeUI_require("init")
		_G.PrimeUI=PrimeUI
	else PrimeUI=_G.PrimeUI end
end
--#endregion Download_PrimeUI

--#region Download_PrimeUI & ShowSplash
term.setPaletteColor(colors.orange,unpack(pal[colors.red]))
parallel.waitForAny(
	function()parallel.waitForAll(Splash_Screen,Download_PrimeUI) end,
	function() repeat 
		local ev,key=os.pullEvent"key" 
		if key==keys.space or key==keys.enter then
			if PrimeUI and license then break 
			else
				local X,Y,c,x,y=term.getSize()
				c,x,y=term.getTextColor(),term.getCursorPos()
				term.setTextColor(colors.orange)
				term.setCursorPos(1,Y-1)
				print("PrimeUI downloading... Please wait...",PrimeUI and 1,license and 1)
				term.setCursorPos(x,y)
				term.setTextColor(c)
			end
		end
	until false end)

pal_ctrl(pal) --recover palette

--#endregion Download_PrimeUI & ShowSplash

--#region PrimeUI GUI part
local comp=require"cc.shell.completion"
local main=term.current()
local x,y=6,8
local act,_,scroll_box="done"

--#region GUI_base func
function make_gui(tm)
	term.setBackgroundColor(colors.lightBlue)
	term.clear()

	-- Logo
	blit_pic({"\x96\x83 \x8C\x82 \x8C\x82","bb b* b*","   ee ee",
				"\x82\x83 \x81\x81 \x81\x81","bb ee ee","        "},4,2,function(a)return a:gsub("*","3") end,function(a)return a:gsub(" ","3") end)
	term.setCursorPos(4+8,2)
	term.setTextColor(colors.blue)
	write(" Framework V4.5-beta Installer. ")

	-- PrimeUI CC0 "copyright"
	local p_msg ="PrimeUI-218b28d by MCJack123 "
	term.setCursorPos(math.max(14+9,max_x-#p_msg+1),max_y-1)
	write(p_msg)

	-- Box 
	local clr = (tm=="LICENSE"or tm=="DESCRIPTION")and colors.white or colors.lightBlue
	PrimeUI_borderBox(main,3,5,max_x-x+2,max_y-y,colors.blue,clr)--paintutils.drawBox(2,4,max_x-1,max_y-3,colors.blue)

	-- Name
	clr=colors.toBlit(clr)
	term.setCursorPos(4+8,3) term.blit("\x9F"..("\x8F"):rep(2+#tm).."\x90",("3"):rep(3+#tm).."b",("b"):rep(3+#tm).."3")
	term.setCursorPos(3+9,4) term.blit("\x90["..tm.."]\x9F",clr..("1"):rep(#tm+2)..'b','b'..("b"):rep(#tm+2)..clr)

	-- Buttons & Keys
	PrimeUI.keyCombo(keys.c,true,false,false,"exit") -- Ctrl+C exit
	if tm=="INSTALL" then 
		PrimeUI.label(main,2,max_y-1," Continue ",colors.lightGray,colors.blue)
		PrimeUI.label(main,2+11,max_y-1," Cancel ",colors.lightGray,colors.blue)
	elseif tm== "LICENSE" then
		PrimeUI.button(main,13,max_y-1,"Cancel" ,"exit",colors.orange,colors.blue,colors.cyan)
		PrimeUI.keyAction(keys.enter,"done")
	elseif tm=="PATH" or tm=="STARTUP"then
		--PrimeUI.label(main,2,max_y-1," Continue ",colors.lightGray,colors.blue)
		PrimeUI.button(main,13,max_y-1,"Cancel" ,"exit",colors.orange,colors.blue,colors.cyan)
	else
		PrimeUI.keyAction(keys.enter,"done")
		PrimeUI.button(main,2,max_y-1,"Continue","done",colors.orange,colors.blue,colors.cyan)
		PrimeUI.button(main,13,max_y-1,"Cancel" ,"exit",colors.orange,colors.blue,colors.cyan)
	end

	-- Return Normal Color
	term.setBackgroundColor(colors.lightBlue)
end
--#endregion GUI_base func

--#region CancelInstalation
local on_cancel = function()
	
	PrimeUI.clear()
	--wnd.clear()
	make_gui("Cancel")
	PrimeUI.label(main ,3,5,"Instalation canceled. Press any key to exit.",colors.red,colors.lightBlue)
	PrimeUI.label(main ,3,6,"Program will exit automaticly in 3 seconds.",colors.blue,colors.lightBlue)
	PrimeUI.addTask(function()while true do
		local ev=os.pullEvent"key"
		ev=ev and PrimeUI.resolve()
		end
	end)
	PrimeUI.timeout(3,"timeout")
	_,act=PrimeUI.run()
	exit_animation()
end
--#endregion CancelInstalation

-- GUI START

--#region ShowDescription
PrimeUI.clear()
make_gui("DESCRIPTION")
paintutils.drawFilledBox(3,5,max_x-x+4,max_y-y+4,colors.white)
scroll_box=PrimeUI.scrollBox(main,3,5,max_x-x+2, max_y-y,999,true,true,colors.blue,colors.white)
PrimeUI.drawText(scroll_box,
[[Enter->Continue Ctrl+c->Cancel Space->Select
Version="4.5-beta" creator="M.A.G.Gen."}

C SuS SuS Framework (Very Suspisious C++)
Modular data processing system.
C SuS SuS Compiller (CSSC) has no own parcer and 
act like preproccessor that turns C SuS SuS code into Lua5.1 code.
    
What C SuS SuS provides?
1. Full support of Lua5.3 operators
    Such as ">>" "//" "&"
2. Keywords shortcuts 
    (and -> "&&", or -> "||", local ->"@", return -> "$", ...)
3. Assignment operators
    ("+=", "-=", "*=", "^=" ...)
4. IS keyword 
    (variable is "string")
    with {__type="your_type"} metamethod support
5. Nil forgiving operators
    (object?.method()) error will not be emited if "method" is nil.
6. Lambdas 
    "(*args*)=>" will be turned into "function(args)"
7. Defautl  arguments for functions
    function demo(A := *default_value*) *code* end
8. More custom features...
    
To know more about C SuS SuS features,
how to use them and how to works with them,
please visit official github
and read or download the documentation [in development].

This package has quiet install mode.
Use `-H` or `--help` option for more information.

For more information visit project git:
https://github.com/MAGGen-hub/C-SuS-SuS-Framework
]],true,colors.brown,colors.white)

term.setBackgroundColor(colors.lightBlue)
_,act = PrimeUI.run()
if act=="exit" then on_cancel() return end


--@endregion ShowDescription


--#endregion PrimeUI GUI part

--#region LICENSE (with timer)
PrimeUI.clear()
local time=skip_timer and 0 or 3--time to accept
make_gui("LICENSE")
paintutils.drawFilledBox(3,5,max_x-x+4,max_y-y+4,colors.white)
local is_active={active=false}
scroll_box=PrimeUI.scrollBox(main,3,5,max_x-x+2, max_y-y,999,true,true,colors.blue,colors.white)
PrimeUI.drawText(scroll_box,license,true,colors.brown,colors.white) 
PrimeUI.button(main,3,max_y-1,"Accept","done",colors.orange,colors.blue,colors.cyan)
PrimeUI.keyAction(keys.enter,function()if time<1 then PrimeUI.resolve(nil,"done")end end)
_,act = PrimeUI.run()
if act=="exit" then on_cancel() return end
--#endregion LICENCE

--#region ChooseModules
local wnd=window.create(term.current(),3,7,max_x-x+2,4)--API chooser window
local base_modules={["Original"]=false, ["Minified"]=true, ["Startup"]= true, ["Program"]= true}
--Module Descriptions
local desc={
	["Original"]="Original C SuS SuS package.",
	["Minified"]="Minified C SuS SuS package.",
	["Startup"] ="Startup module. CSSC API auto-load.",
	["Program"] ="Program to launch CSSC programs from shell. Recomended to install."}
setmetatable(base_modules,{__pairs=function(a)
	return function(t,i)
		local order={"Original",["Original"]="Minified",["Minified"]="Startup",["Startup"]="Program"}--["Program"]=nil}
		local ind=order[i or 1]
		return ind,base_modules[ind] 
	end,desc
end})
local sel_desk=desc["Minified"]--defalut
local redr_func=function()PrimeUI.textBox(main,3,12,max_x-x+2,1,sel_desk or "",colors.blue,colors.lightBlue)end

local selc="Original"
repeat
	PrimeUI.clear()
	make_gui("MODULES")
	PrimeUI.label(main,3,5,"Select API and modules to install:",colors.blue,colors.lightBlue)
	redr_func()--PrimeUI.textBox(main,4,15,max_x-x,1,sel_desk,colors.blue,colors.lightBlue)
	PrimeUI.checkSelectionBox(wnd,1, 1,max_x-x+2,8,base_modules,
		function(k)
			local i = 0
			for kk in pairs(base_modules)do
				i=i+1
				if not({["Startup"]=1,["Program"]=1})[k] and i<3 then 
					base_modules[kk]=false 
				end
			end
			if i<3 then 
				base_modules[k]=true
			else
				base_modules[k]=not base_modules[k]
			end
			sel_desk=desc[k]
			selc=k
			PrimeUI.resolve(_,"api")
		end,colors.brown,colors.lightBlue)
	PrimeUI.addTask(--task to put cursor on it's place
			function()
				for k,v in pairs(base_modules)do 
					if k~=selc then os.queueEvent("key",keys.down,false)
					else break end 
				end 
				while true do coroutine.yield() end 
			end)
	_,act,key,value=PrimeUI.run()
until act~="api"

if act=="exit" then on_cancel() return end
--#endregion ChooseModules

--#region ChoosePath
--Path to cssc directory 
local cssc_folder,prev_folder,err 
local histor={"/","/progs/cssc","/programs/cssc","/disk/cssc","/lib/cssc","/apis/cssc","/cssc"}-- posible names for directory
repeat
	cssc_folder=nil
	PrimeUI.clear()
	make_gui("PATH")
	PrimeUI.button(main,2,max_y-1,"Continue",function()os.queueEvent("key",28)end,colors.orange,colors.blue,colors.cyan)
	PrimeUI.label(main,3,5,"Choose instalation folder (use \x12):",colors.blue,colors.lightBlue)
	paintutils.drawLine(3,7,max_x-x+3,10,colors.lightGray)
	PrimeUI.inputBox(main,4,7,max_x-x+1,"done",colors.white,colors.lightGray,nil,histor,
		function(sLine) if #sLine>0 then return comp.dir(shell,sLine)end end,histor[#histor])
	
	PrimeUI.textBox(main,4,8,max_x-x,3,err or"",colors.red,colors.lightBlue)
	term.setTextColor(colors.yellow)
	term.setCursorBlink(true)
	term.setCursorPos(5+5,7)
	_,act,cssc_folder=PrimeUI.run()--attempt to get the way
	_,err=pcall(function() 
		if cssc_folder then --create files if posible
			if prev_folder~=cssc_folder and fs.isDir(cssc_folder) and (fs.exists(fs.combine(cssc_folder,"cssc.lua")) or fs.exists(fs.combine(cssc_folder,"cssc_api.lua")))then
				prev_folder=cssc_folder
				error("Warning! Files 'cssc.lua' and 'cssc_api.lua' will be rewriten! Are you sure? [Enter]")
			end
			local tmp1,err1
			if base_modules["Program"] then
				tmp1=not fs.isReadOnly(fs.combine(cssc_folder,"cssc.lua")) or error("File is read-only!")
			end
			local tmp2=not fs.isReadOnly(fs.combine(cssc_folder,"cssc_api.lua")) or error("File is read-only!")
			
			install_prog=tmp1 and cssc_folder-- fs.combine(cssc_folder,"cssc.lua")
			path =tmp2 and cssc_folder -- fs.combine(cssc_folder,"cssc_api.lua")
		end
	end)
	histor[#histor+1]=cssc_folder~=histor[#histor] and cssc_folder or nil
until path or act=="exit"
if act=="exit" then on_cancel() return end
--#endregion ChoosePath

--#region ChooseStartup
err=nil
local st_path_tmp,prev_st_path
--Startup path
if base_modules["Startup"] then
	local histor={"/startup.lua","/disk/startup.lua","/disk/startup/00_cssc.lua","/startup/cssc.lua","/startup/02_cssc.lua","/startup/01_cssc.lua"}
	repeat
		PrimeUI.clear()
		make_gui("STARTUP")
		PrimeUI.button(main,2,max_y-1,"Continue",function()os.queueEvent("key",28)end,colors.orange,colors.blue,colors.cyan)
		PrimeUI.label(main,3,5,"Enter startup (use \x12):",colors.blue,colors.lightBlue)
		paintutils.drawLine(3,7,max_x-x+4,7,colors.lightGray)
		PrimeUI.inputBox(main,3,7,max_x-x+2,"done",colors.white,colors.lightGray,nil,histor,
			function(sLine) if #sLine>0 then return comp.dirOrFile(shell,sLine)end end, histor[#histor])
		PrimeUI.textBox(main,4,8,max_x-x,3,err or"",colors.red,colors.lightBlue)
		_,act,st_path_tmp=PrimeUI.run()
		_,err=pcall(function()
				if st_path_tmp then
					if fs.exists(st_path_tmp) and prev_st_path~=st_path_tmp then
						prev_st_path=st_path_tmp
						error("Warning! File '"..st_path_tmp.."' will be rewriten! Are you sure? [Enter]")
					end
					local tmp =not fs.isReadOnly(st_path_tmp) or error("File is read-only!")
					st_path=tmp and fs.combine(st_path_tmp)
				end
			end)
		histor[#histor+1]=st_path_tmp~=histor[#histor] and st_path_tmp or nil
	until st_path or act=="exit"
end
if act=="exit" then on_cancel() return end
--#endregion ChooseStartup

--#region ProgressBar & Size calculation & Instalation Completion
PrimeUI.clear()
make_gui("INSTALL")
term.setBackgroundColor(colors.black)
term.clear()
--PrimeUI.textBox(main,3,5,max_x-x+4,max_y-y+4,"Ins\nIns\n",colors.blue,colors.lightBlue)
PrimeUI.addTask(function()
	local wnd = window.create(main,3,5,max_x-x+2,max_y-y,true)
	term.redirect(wnd)
	term.setCursorPos(1,1)
	install()
	term.redirect(main)
	PrimeUI.resolve("install","done")
end)
_,act=PrimeUI.run()
if act=="exit" then on_cancel() return end
--#endregion ProgressBar & Size calculation & Instalation Completion

--#endregion PrimeUI GUI part

exit_animation()