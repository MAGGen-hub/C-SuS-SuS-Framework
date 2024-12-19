local sub,insert,concat=ENV(6,7,8)
--base API for text/code related data
C.Operators={}
C.operator=""
C.word=""
C.Words={}
C.Result[1]=""
C.max_op_len=3
C.line=1
C.Text={split_seq=function(data,i,seq)--split_seq:function to split operator/word quences
	seq=seq and"word"or"operator"
	if data then
		data[#data+1]=i and sub(C[seq],1,i)or C[seq]
	end
	C[seq]=i and sub(C[seq],i+1)or""
	C.index=C.index+(i or 0)
	return i
end}

C.Return=function() return concat(C.Result)end --C.Result : C - required, because concat can't pull Result from _ENV in lua5.1 for some reason
insert(Clear,function()C.Result={""}C.operator=""C.word=""end)