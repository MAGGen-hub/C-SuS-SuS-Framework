{[_init]=function(Control)
	--OperatorWordSystem-debug utilite
	
	--blit control
	local rep = string.rep --rep func import
	local blit_ctrl={
	space={colors.toBlit(colors.white)," "},
	[__WORD__]={colors.toBlit(colors.white)," "},
	[__KEYWORD__]={colors.toBlit(colors.yellow)," "},
	[__OPERATOR__]={colors.toBlit(colors.lightBlue)," "},
	[__SYMBOL__]={colors.toBlit(colors.lightBlue)," "},
	[__COMMENT__]={colors.toBlit(colors.green)," "},
	[__VALUE__]={colors.toBlit(colors.cyan)," "},
	[__OPEN_BREAKET__]={colors.toBlit(colors.white)," "},
	[__CLOSE_BREAKET__]={colors.toBlit(colors.white)," "},
	[__NUMBER__]={colors.toBlit(colors.lime)," "},
	[__STRING__]={colors.toBlit(colors.red)," "},
	[__UNFINISHED__]={colors.toBlit(colors.pink)," "},
	}
	Control.BlitBack={}
	Control.BlitFront={}
	local burn_blit=function(tp,len)
		tp=blit_ctrl[tp]or{" "," "}
		len=len or #Control.Result[#Control.Result]
		Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)
		Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)
	end
	
	--load base lib
	Control:load_lib"text.dual_queue.base"
	Control:load_lib"text.dual_queue.parcer"
	Control:load_lib"text.dual_queue.iterator"
	--Control:load_lib"text.dual_queue.make_react"
	Control:load_lib"text.dual_queue.space_handler"
	
	--edit space handler
	local sp_h=remove(Control.Struct)
	insert(Control.Struct,function()
		local pl=#Control.Result[#Control.Result]
		sp_h(Control)
		burn_blit("space",#Control.Result[#Control.Result]-pl)
	end)

	Control.Core=function(tp)
		local len =#Control.Result[#Control.Result]
		burn_blit(tp)
	end
	Control.Return=function()
		local rez,blit,back=concat(Control.Result).."\n",concat(Control.BlitFront).." ",concat(Control.BlitBack).." "
		rez=sub(rez,-1)=="\n"and rez or rez.."\n"
		gsub(rez,"()(.-()\n)",function(st,con,nd)
			term.blit(gsub(con,".$","\x14"),
				sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),
				sub(back,st,nd))--back color
			print()
		end)
		return Control
	end
	insert(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)
end}