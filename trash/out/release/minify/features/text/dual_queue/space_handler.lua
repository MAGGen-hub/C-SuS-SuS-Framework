local Sm,Sg,Ti=ENV(2,5,7)Ti(Struct,function()local t,s=#C.operator>0 and"operator"or"word"s,C[t]=Sm(C[t],"^(%s*)(.*)")if#s>0 then
s,t=Sg(s,"\n",{})C.line=C.line+t
C.index=C.index+#s
Result[#Result+1]=s
Core(5,s)end
end)