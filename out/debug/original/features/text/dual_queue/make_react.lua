local match,sub,insert=ENV(2,6,7)
--function that created sefault reactions to different tokens
return 2, function(s,i,t,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
	t=t or match(s,"%w")and"word"or"operator"
	j=j or#s
	return function()
		insert(Result,s)
		C[t]=sub(C[t],j+1)
		C.index=C.index+j
		Core(i,s)
	end
end