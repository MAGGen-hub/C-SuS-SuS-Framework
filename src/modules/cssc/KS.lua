local match,sub,insert,pairs,t_swap=ENV(__ENV_MATCH__,__ENV_SUB__,__ENV_INSERT__,__ENV_PAIRS__,__ENV_T_SWAP__)

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
		Cssc.inject(" ",__SPACE__)
		C.operator=sub(C.operator,j+1)
		C.index=C.index+j
		insert(Result,s)
		Core(i,s)
		Cssc.inject(" ",__SPACE__)
	end
end
C:load_lib"code.syntax_loader"(stx,{O=function(k,v)
	Operators[k]=make_react(v,match(v,"^[aon]") and __OPERATOR__ or __KEYWORD__,#k)
end})