local sub,insert,concat=ENV(6,7,8)
--base API for text/code related data
C.Operators={}
C.operator=""
C.word=""
C.Words={}
C.Result[1]=""
C.max_op_len=3
C.line=1
C.Text={split_seq=function(data,i,queue)--split_seq:function to split operator/word quences
	queue=queue and"word"or"operator"
	if data then
		data[#data+1]=i and sub(C[queue],1,i)or C[queue]
	end
	C[queue]=i and sub(C[queue],i+1)or""
	C.index=C.index+(i or 0)
	return i
end}

C.Return=function() return concat(C.Result)end --C.Result : C - required, because concat can't pull Result from _ENV in lua5.1 for some reason
insert(Clear,function()C.Result={""}C.operator=""C.word="" C.line=1 end)