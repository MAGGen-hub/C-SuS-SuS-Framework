local SG,Tu,Cp=ENV(1,10,22)return 2,function(str,f)local mode,t=Cp,{}for o,s in SG(str,"(.-)(%s)")do
t[#t+1]=o
if s=="\n"then
mode=#t==1 and f[o]or mode(Tu(t))or mode
t={}end
end
end