local Sm,Ss,Gt=ENV(2,6,12)local func=function(react_obj,t,j,i,po)if"string"==Gt(react_obj)then Result[#Result+1]=react_obj
else react_obj=react_obj(C,po)end
if react_obj then
C[t]=Ss(C[t],j+1)C.index=C.index+j
Core(i,react_obj)end
end
Struct.final=function()local posible_obj,react_obj
if#C.operator>0 then
for j=C.max_op_len,1,-1 do
posible_obj=Ss(C.operator,1,j)react_obj=Operators[posible_obj]if react_obj or j<2 then func(react_obj or posible_obj,"operator",j,react_obj and 2 or 1,posible_obj)break end
end
elseif#C.word>0 then
posible_obj=Sm(C.word,"^%S+")react_obj=Words[posible_obj]or posible_obj
func(react_obj,"word",#posible_obj,3,posible_obj)end
end