local Ss,Ti,Tc=ENV(6,7,8)C.Operators={}C.operator=""C.word=""C.Words={}C.Result[1]=""C.max_op_len=3
C.line=1
C.Text={split_seq=function(data,i,seq)seq=seq and"word"or"operator"if data then
data[#data+1]=i and Ss(C[seq],1,i)or C[seq]end
C[seq]=i and Ss(C[seq],i+1)or""C.index=C.index+(i or 0)return i
end}C.Return=function()return Tc(C.Result)end
Ti(Clear,function()C.Result={""}C.operator=""C.word=""end)