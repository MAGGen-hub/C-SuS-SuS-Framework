local Sm,Sg,Ti=ENV(2,5,7)Ti(Struct,function()local temp,space=#C.operator>0 and"operator"or"word"space,C[temp]=Sm(C[temp],"^(%s*)(.*)")if#space>0 then
space,temp=Sg(space,"\n",{})C.line=C.line+temp
C.index=C.index+#space
Result[#Result+1]=space
Core(5,space)end
end)