local Sm,SF,Ti,Tr,Tu,Ge,Gs,GS,Gl,Cp,TS=ENV(2,3,7,9,10,14,15,18,20,22,23)local p,S,m,t,E={},Cdata.skip_tb,GS({},{__index=function(s,i)return i end}),C:load_libs"code.cssc""runtime""typeof"(2),"Unexpected '%s' in function argument Gt definition! Function argument Gt must be set using single n or string!"Runtime.build("func.def_arg",function(D)local r,v,V,d,T={}for i=1,#D,4 do
v=D[i+1]d=D[i+3]if v==nil and d then Ti(r,d)else
T=D[i+2]if T then
V=t(v)T=T==1 and{[t(d)]=1}or TS{(Gl("return "..T,"DA_type_loader",nil,m)or Cp)()}T=not T[V]and Ge(SF("bad argument #%d (%s expected, got %s)",D[i],D[i+2],V),2)end
Ti(r,v)end
end
return Tu(r)end)Event.reg("lvl_open",function(l)if l.Gt=="function"then l.DA_np=1 end
if l.Gt=="("and Level[#Level].DA_np then l.DA_d={c_a=1}end
Level[#Level].DA_np=nil
end,"DA_lo",1)Event.reg(2,function(o)local d,i,e=Level[#Level].DA_d
if d then i=d.c_a
if o==":"then
d[i]=d[i]or{[4]=Result[Cdata.tb_while(S,#Cdata-1)]}if not d[i][2]then
e,d[i][1]=d[i][1],#Cdata
end
elseif o=="="then d[i]=d[i]or{[4]=Result[Cdata.tb_while(S,#Cdata-1)]}e,d[i][2]=d[i][2],#Cdata
elseif o==","then d.c_a=d.c_a+1(d[i]or p)[3]=#Cdata-1
elseif not d[i]or not d[i][2]then e=1 end
if e then
C.Ge("Unexpected '%s' operator in function arguments defenition.",o)Level[#Level].DA_d=nil
end
end
end,"DA_op",1)Event.reg("lvl_close",function(lvl)if lvl.DA_d then
local d,b,n,c,D,o,s,a=lvl.DA_d,{},{},{",",2,Cdata.opts[","][1]}for i=d.c_a,1,-1 do
if d[i]then
D,a,s=d[i],0
Ti(n,{D[4],3})Ti(n,c)if not D[2]then
Ti(b,{"nil",8})Ti(b,c)end
D[3]=D[3]or#Result-1
for j=D[3],D[1]or D[2],-1 do
o=Cssc.eject(j)if j==D[2]or j==D[1]then
Ti(b,c)elseif D[2]and j>D[2]then
Ti(b,o)a=not S[o[2]]and a+1 or a
elseif not S[o[2]]then
if not(o[2]==3 or o[2]==7 or Sm(o[1],"^nil"))or s then
C.Ge(E,o[1])else
if o[2]==3 then o={"'"..Sm(o[1],"%S*").."'",7}end
Ti(b,o)s=1
end
end
end
if D[2]and a<1 then C.Ge("Expected default argument after '%s'",D[2]and"="or":")end
a=not s and D[1]if a or not D[1]then
Tr(a and b or p)Ti(b,{a and"1"or"nil",8})Ti(b,c)end
Ti(b,{D[4],3})Ti(b,c)Ti(b,{Gs(i),8})Ti(b,c)end
end
if not o then return end
Runtime.reg("__cssc__def_arg","func.def_arg")Tr(n)for i=#n,1,-1 do Cssc.inject(Tu(Tr(n)))end
Cssc.inject("=",2,Cdata.opts["="][1])Cssc.inject("__cssc__def_arg",3)Cssc.inject("{",9)D=#Result
Tr(b)for i=#b,1,-1 do
Cssc.inject(Tu(Tr(b)))end
Cssc.inject("}",10,D)Cssc.inject("",2,0)end
end,"DA_lc",1)