local S,f,Sm,Ss=Cdata.skip_tb,"function",ENV(2,6)Operators["->"]=function()local s,i,d,c,b=3,Cdata.tb_while(S)if Sm(Result[i],"^%)")then
i=d[2]c=i and Sm(Result[Cdata.tb_while(S,i-1)]or"","^[=%(,]")else
while i>0 and(S[d[1]]or d[1]==s or s~=3 and((d[2]or-1)==Cdata.opts[","][1]and Sm(Result[i],"^%,")))do
i,s=i-1,s*(S[d[1]]and 1 or-1)d=Cdata[i]end
i,b,c=i+1,1,i>0 and s~=3 and Sm(Result[i],"^[=%(]")end
if not c then C.error("Corrupted lambda arguments at line %d !",C.line)Text.split_seq(nil,2)return end
Cssc.inject(i,f,4)Cssc.inject(i," ",5)if b then
Cssc.inject(i+2,"(",9)Cssc.inject(")",10,i+1)end
if"-"==Ss(C.operator,1,1)then Cssc.inject("return",4)Cssc.inject(" ",5)end
Event.run(2,"->",2,1)Event.run("all",Ss(C.operator,1,1)..">",tp,1)Level.open(f,nil,i)Level[#Level].DA_np=nil
Text.split_seq(nil,2)end
Operators["=>"]=Operators["->"]