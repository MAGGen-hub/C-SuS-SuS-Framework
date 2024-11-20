{[_init]=function(Control)--keyword shorcuts
    local stx = [[O
? then
/| if
:| elseif
\| else
]]
    local make_react=function(s,i,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
        return function(Control)
            Control.Result[#Control.Result]= Control.Result[#Control.Result].." "--add spaceing
            insert(Control.Result,s.." ")
            Control.operator=sub(Control.operator,j+1)
            Control.index=Control.index+j
            Control.Core(i,s)
        end
    end
Control:load_lib"code.syntax_loader"(stx,{O=function(k,v)
    Control.Operators[k]=make_react(v,__KEYWORD__,#k)
end})
end}