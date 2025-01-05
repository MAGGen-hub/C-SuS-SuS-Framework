local Ss,Ti,Tc=ENV(6,7,8)C.Operators={}C.operator=""C.word=""C.Words={}C.Result[1]=""C.max_op_len=3
C.line=1
C.Text={split_seq=function(d,i,s)s=s and"word"or"operator"if d then
d[#d+1]=i and Ss(C[s],1,i)or C[s]end
C[s]=i and Ss(C[s],i+1)or""C.index=C.index+(i or 0)return i
end}C.Return=function()return Tc(C.Result)end
Ti(Clear,function()C.Result={""}C.operator=""C.word=""C.line=1 end)