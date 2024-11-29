local match,gsub,insert=ENV(__ENV_MATCH__,__ENV_GSUB__,__ENV_INSERT__)
-- function to proccess spaces
insert(Control.Struct,function()--SPACE HANDLER
	local temp,space = #Control.operator>0 and"operator"or"word"
	space,Control[temp]=match(Control[temp],"^(%s*)(.*)")
	space,temp=gsub(space,"\n",{})--line counter
	Control.line=Control.line+temp
	Control.index=Control.index+#space
	Control.Result[#Control.Result+1]=space
	Control.Core(__SPACE__,space)
end)