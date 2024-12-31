local Sm,Ss,Gt=ENV(2,6,12)local f=function(r,q,j,t,p)if"string"==Gt(r)then Result[#Result+1]=r
else r=r(C,p)end
if r then
C[q]=Ss(C[q],j+1)C.index=C.index+j
Core(t,r)end
end
Struct.final=function()local p,r
if#C.operator>0 then
for j=C.max_op_len,1,-1 do
p=Ss(C.operator,1,j)r=Operators[p]if r or j<2 then f(r or p,"operator",j,r and 2 or 1,p)break end
end
elseif#C.word>0 then
p=Sm(C.word,"^%S+")r=Words[p]or p
f(r,"word",#p,3,p)end
end