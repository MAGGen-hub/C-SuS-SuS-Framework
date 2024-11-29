local match,sub,pairs=ENV(__ENV_MATCH__,__ENV_SUB__,__ENV_PAIRS__)

local mod,arg=... --keyword shorcuts
--require"cc.pretty".pretty_print(arg)
local stx = [[O
|| or
&& and
! not
@ local
$ return
]]
for _,v in pairs(arg or{})do
	if v=="sc_end" then --include semicolon to end conversion basic ; can be placed with \;
		stx=stx.."; end\n\\; ;\n"
	end
	if v=="pl_cond" then --platform condition... the most cursed feature... so probably will be removed in future
		stx=stx..[[? then
/| if
:| elseif
\| else
]]
	end
end
--specific make react with space addition
local make_react=function(s,i,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
	return function(Control)
		--Control.Result[#Control.Result]= Control.Result[#Control.Result].." "
		Control.inject(nil," ",__SPACE__)
		
		Control.operator=sub(Control.operator,j+1)
		Control.index=Control.index+j
		insert(Control.Result,s)
		
		Control.Core(i,s)
		Control.inject(nil," ",__SPACE__)
	end
end
Control:load_lib"code.syntax_loader"(stx,{O=function(k,v)
	Control.Operators[k]=make_react(v,match(v,"^[aon]") and __OPERATOR__ or __KEYWORD__,#k)
end})
return __TRUE__