local match,sub,insert=ENV(__ENV_MATCH__,__ENV_SUB__,__ENV_INSERT__)
--function that created sefault reactions to different tokens
return __RESULTABLE__, function(s,i,t,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
	t=t or match(s,"%w")and"word"or"operator"
	j=j or#s
	return function()
		insert(Result,s)
		C[t]=sub(C[t],j+1)
		C.index=C.index+j
		Core(i,s)
	end
end