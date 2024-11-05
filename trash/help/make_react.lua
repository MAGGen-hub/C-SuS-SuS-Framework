make_react=function(Control,s,j,i,t)
	t=t and"word"or"operator"
	return function()
		insert(Control.Result,s)
		Control[t]=sub(Control[t],j+1)
		Control.index=Control.index+j
		Control.Core(i)
	end
end
