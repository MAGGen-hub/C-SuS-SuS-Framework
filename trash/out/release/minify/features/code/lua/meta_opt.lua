
local TS=ENV(23)local P,N,S,s,p=TS{7,10,3},TS{7,9},TS{3,10,7,8,6},TS{3,4,8,6},...
return 2,function(x,n,y)if P[x]and N[n]then
p(1)elseif S[x]and s[n]or x==4 and not y then
p(-1)end
end