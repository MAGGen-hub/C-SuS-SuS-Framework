local Sm,Ti,Tu,Gp,TS=ENV(2,7,10,13,23)C:load_libs"code.cssc""runtime""op_stack"local P,B,S,s,b=TS{"(","{","[","for","while","if","elseif","until"},{},Cdata.skip_tb,[[O
+ - * / % .. ^ ?
&& ||
]],"__cssc__bit_"if Operators["~"]then s=s.."| & >> <<\n"B=TS{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}end
B['?']="op.qad"Runtime.build("op.qad",function(a,b)return a~=nil and a or b end)C:load_lib"code.syntax_loader"(s,{O=function(...)for k,v,a,R in Gp{...}do
a=({["&&"]="and",["||"]="or"})[v]or v
R=v=="?"and"__cssc_op_qad"or B[v]and b..B[v]Operators[v.."="]=function()if B[v]then Runtime.reg(R,(v~="?"and"bit."or"")..B[v])end
local L,c,I,D,i,l=Level[#Level],Cdata.opts[","][1],#Cdata
if P[L.type]or#(L.OP_st or"")>0 then
C.error("Attempt to use additional asignment in prohibited area!")end
Cssc.inject("=",2,Cdata.opts["="][1])Text.split_seq(nil,#v+1)Event.run(2,v.."=",2,1)Event.run("all",v.."=",2,1)i,l=Cssc.op_conf(nil,c+1,false,1,false,#Cdata-1)if l[1]==2 and l[2]==c then
C.error("Additional asignment do not support multiple additions in this version of cssc!")end
if l[1]==2 and l[2]==0 and i-1>0 and Cdata[i-1][1]==4 and Sm(Result[i-1],"^local")then
C.error("Attempt to perform additional asignment to local variable constructor!")end
if R then
Cssc.inject(R,3)Cssc.inject("(",9)D=#Cdata
end
for k=i+1,I do
Cssc.inject(Result[k],Tu(Cdata[k]))end
if not R then
if Sm(a,"^[ao]")then Cssc.inject(" ",5)end
Cssc.inject(a,2,Cdata.opts[a][1])Cssc.inject("(",9)D=#Cdata
else
Cssc.inject(",",2,c+1)end
L.OP_st[#L.OP_st][3]=D
L.OP_st[#L.OP_st][4]=D
Event.reg("all",function(obj,tp)if tp==4 and not Sm(Result[#Result],"^function")or tp==10 or tp==2 and not Cdata[#Cdata][3]then C.error("Unexpected '%s' after '%s'!",obj,v.."=")end
return not S[tp]and 1
end)end
end
end})