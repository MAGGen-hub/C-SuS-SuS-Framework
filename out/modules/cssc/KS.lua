local match,sub,insert,pairs,t_swap=ENV(2,6,7,14,24)

local stx,_,arg = [[O
|| or
&& and
! not
@ local
$ return
]],...
arg=t_swap(arg or{})

--for _,v in pairs(arg or{})do
	if arg.sc_end then --include semicolon to end conversion basic ; can be placed with \;
		stx=stx.."; end\n\\; ;\n"
	end
	if arg.pl_cond then --platform condition... the most cursed feature... so probably will be removed in future
		stx=stx..[[? then
/| if
:| elseif
\| else
]]
	end
--end
--specific make react with space addition
local make_react=function(s,i,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
	return function()
		Cssc.inject(" ",5)
		C.operator=sub(C.operator,j+1)
		C.index=C.index+j
		insert(Result,s)
		Core(i,s)
		Cssc.inject(" ",5)
	end
end
C:load_lib"code.syntax_loader"(stx,{O=function(k,v)
	Operators[k]=make_react(v,match(v,"^[aon]") and 2 or 4,#k)
end})
--return 1