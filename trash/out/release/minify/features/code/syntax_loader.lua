local SG,Tu,Cp=ENV(1,10,22)return 2,function(s,f)local m,t=Cp,{}for o,s in SG(s,"(.-)(%s)")do
t[#t+1]=o
if s=="\n"then
m=#t==1 and f[o]or m(Tu(t))or m
t={}end
end
end