local tb,fk,Sm,Ss=Cdata.skip_tb,"function",ENV(2,6)Operators["->"]=function()local s,ei,ed,cor,br=3,Cdata.tb_while(tb)if Sm(Result[ei],"^%)")then
ei=ed[2]cor=ei and Sm(Result[Cdata.tb_while(tb,ei-1)]or"","^[=%(,]")else
while ei>0 and(tb[ed[1]]or ed[1]==s or s~=3 and((ed[2]or-1)==Cdata.opts[","][1]and Sm(Result[ei],"^%,")))do
ei,s=ei-1,s*(tb[ed[1]]and 1 or-1)ed=Cdata[ei]end
ei,br,cor=ei+1,1,ei>0 and s~=3 and Sm(Result[ei],"^[=%(]")end
if not cor then Control.Ge("Corrupted lambda arguments at line %d !",C.line)Text.split_seq(nil,2)return end
Cssc.inject(ei,fk,4)Cssc.inject(ei," ",5)if br then
Cssc.inject(ei+2,"(",9)Cssc.inject(")",10,ei+1)end
if"-"==Ss(C.operator,1,1)then Cssc.inject("return",4)Cssc.inject(" ",5)end
Event.run(2,"->",2,1)Event.run("all",Ss(C.operator,1,1)..">",tp,1)Level.open(fk,nil,ei)Level[#Level].DA_np=nil
Text.split_seq(nil,2)end
Operators["=>"]=Operators["->"]