local match,sub,type=ENV(2,6,13)
local func=function(react_obj,t,j,i,po)
	if"string"==type(react_obj)then Result[#Result+1]=react_obj
	else react_obj=react_obj(C,po) end --MAIN ACTION
	
	if react_obj then -- default reaction to string (functions can have default reactions if they return anything(expected string!))
		C[t]=sub(C[t],j+1)
		C.index=C.index+j
		Core(i,react_obj)
	end
end
Struct.final=function() --base handler for two sequences
	local posible_obj,react_obj
	if#C.operator>0 then --OPERATOR PROCESSOR
		for j=C.max_op_len,1,-1 do --split the operator_seq
			posible_obj=sub(C.operator,1,j)
			react_obj=Operators[posible_obj]
			if react_obj or j<2 then func(react_obj or posible_obj,"operator",j,react_obj and 2 or 1,posible_obj)break end
		end
	elseif#C.word>0 then--WORD PROCESSOR
		posible_obj=match(C.word,"^%S+") --split the word_seq temp=#posible_object
		react_obj=Words[posible_obj]or posible_obj
		func(react_obj,"word",#posible_obj,3,posible_obj)
	end
end