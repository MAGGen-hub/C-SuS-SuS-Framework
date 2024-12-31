local Sm,Ss,Ti=ENV(2,6,7)return 2,function(s,i,t,j)t=t or Sm(s,"%w")and"word"or"operator"j=j or#s
return function()Ti(Result,s)C[t]=Ss(C[t],j+1)C.index=C.index+j
Core(i,s)end
end