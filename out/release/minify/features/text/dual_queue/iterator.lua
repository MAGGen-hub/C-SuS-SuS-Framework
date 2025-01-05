local SG,Ti=ENV(1,7)local S=...
Ti(C.PreRun,function()local s=SG(C.src,S or"()([%s!-/:-@[-^{-~`]*)([^!-/:-@[-^{-~`]*)")C.Iterator=function(m)if m and(#(C.operator or'')>0 or#(C.word or'')>0)then return end
C.index,C.operator,C.word=s()return not C.index
end
end)