local match,gsub,insert=ENV(2,5,7)
-- function to proccess spaces
insert(Struct,function()--SPACE HANDLER
	local temp,space = #C.operator>0 and"operator"or"word"
	space,C[temp]=match(C[temp],"^(%s*)(.*)")
	space,temp=gsub(space,"\n",{})--line counter
	C.line=C.line+temp
	C.index=C.index+#space
	Result[#Result+1]=space
	Core(5,space)
end)