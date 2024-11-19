{[_init]=function(Control)--keyword shorcuts
    local stx = [[O
|| and
&& or
@ local
$ return
]]
    local make_react=function(s,i,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
		return function(Control)
            Control.Result[#Control.Result]= Control.Result[#Control.Result].." "
			insert(Control.Result,s.." ")
			Control.operator=sub(Control.operator,j+1)
			Control.index=Control.index+j
			Control.Core(i,s)
		end
	end
    Control:load_lib"code.syntax_loader"(stx,{O=function(k,v)
        Control.Operators[k]=make_react(v,match(v,"^[ao]") and __OPERATOR__ or __KEYWORD__,#k)
    end})
end}