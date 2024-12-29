local Sm,Ti,Tu,Gp,TS=ENV(2,7,10,13,23)C:load_libs"code.cssc""runtime""op_stack"local prohibited_area,bt,tb,stx,loc_base=TS{"(","{","[","for","while","if","elseif","until"},{},Cdata.skip_tb,[[O
+ - * / % .. ^ ?
&& ||
]],"__cssc__bit_"if Operators["~"]then stx=stx.."| & >> <<\n"bt=TS{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}end
bt['?']="op.qad"Runtime.build("op.qad",function(a,b)return a~=nil and a or b
end)C:load_lib"code.syntax_loader"(stx,{O=function(...)for k,v,t,p in Gp{...}do
t=({["&&"]="and",["||"]="or"})[v]or v
p=v=="?"and"__cssc_op_qad"or bt[v]and loc_base..bt[v]Operators[v.."="]=function()if bt[v]then Runtime.reg(p,(v~="?"and"bit."or"")..bt[v])end
local lvl,cur_i,cur_d,i,lst=Level[#Level],#Cdata
if prohibited_area[lvl.Gt]or#(lvl.OP_st or"")>0 then
Control.Ge("Attempt to use additional asignment in prohibited area!")end
Cssc.inject("=",2,Cdata.opts["="][1])Text.split_seq(nil,#v+1)Event.run(2,v.."=",2,1)Event.run("all",v.."=",2,1)i,lst=Cssc.op_conf(nil,Cdata.opts[","][1]+1,false,1,false,#Cdata-1)if lst[1]==2 and lst[2]==Cdata.opts[","][1]then
Control.Ge("Additional asignment do not support multiple additions in this version of cssc_beta!")end
if lst[1]==2 and lst[2]==0 and i-1>0 and Cdata[i-1][1]==4 and Sm(Result[i-1],"^local")then
Control.Ge("Attempt to perform additional asignment to local variable constructor!")end
if p then
Cssc.inject(p,3)Cssc.inject("(",9)cur_d=#Cdata
end
for k=i+1,cur_i do
Cssc.inject(Result[k],Tu(Cdata[k]))end
if not p then
if Sm(t,"^[ao]")then Result[#Result]=Result[#Result].." "end
Cssc.inject(t,2,Cdata.opts[t][1])Cssc.inject("(",9)cur_d=#Cdata
else
Cssc.inject(",",2,Cdata.opts[","][1]+1)end
lvl.OP_st[#lvl.OP_st][3]=cur_d
lvl.OP_st[#lvl.OP_st][4]=cur_d
Event.reg("all",function(obj,tp)if tp==4 and not Sm(Result[#Result],"^function")or tp==10 or tp==2 and not Cdata[#Cdata][3]then Control.Ge("Unexpected '%s' after '%s'!",obj,v.."=")end
return not tb[tp]and 1
end)end
end
end})