local sub,insert,concat=ENV(__ENV_SUB__,__ENV_INSERT__,__ENV_CONCAT__)
--base API for text/code related data
Control.Operators={}
Control.operator=""
Control.word=""
Control.Words={}
Control.Result[1]=""
Control.max_op_len=3
Control.line=1

Control.split_seq=function(data,i,seq)--split_seq:function to split operator/word quences
	seq=seq and"word"or"operator"
	if data then
		data[#data+1]=i and sub(Control[seq],1,i)or Control[seq]
	end
	Control[seq]=i and sub(Control[seq],i+1)or""
	Control.index=Control.index+(i or 0)
	return i
end

Control.Return=function()return concat(Control.Result)end
insert(Control.Clear,function()Control.Result={""}Control.operator=""Control.word=""end)