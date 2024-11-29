local match,gsub,insert=ENV(2,5,7)
-- function to proccess spaces
insert(Control.Struct,function()--SPACE HANDLER
	local temp,space = #Control.operator>0 and"operator"or"word"
	space,Control[temp]=match(Control[temp],"^(%s*)(.*)")
	space,temp=gsub(space,"\n",{})--line counter
	Control.line=Control.line+temp
	Control.index=Control.index+#space
	--Control.Result[#Control.Result]=Control.Result[#Control.Result]..space--return space back to place
	Control.Result[#Control.Result+1]=space
	Control.Core(5,space)
end)