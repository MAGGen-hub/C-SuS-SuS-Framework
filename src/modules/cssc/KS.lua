local match,sub,insert,pairs,t_swap=ENV(__ENV_MATCH__,__ENV_SUB__,__ENV_INSERT__,__ENV_PAIRS__,__ENV_T_SWAP__)

local stx,_,arg = [[O
|| or
&& and
! not
]],...
arg=t_swap(arg or{})

stx=stx..
(arg.loc and     "@ local\n"or"")..
(arg.ret and     "$ return\n"or"")..
(arg.sc_end and  "; end\n\\; ;\n"or"")..--include semicolon to end conversion basic ; can be placed with \;
(arg.pl_cond and[[? then
/| if
:| elseif
\| else
]]or"")--platform condition... the most cursed feature... so probably will be removed in future

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