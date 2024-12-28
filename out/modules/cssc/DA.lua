local Sm,SF,Ti,Tr,Tu,Ge,Gs,GS,Gl,Cp,TS=ENV(2,3,7,9,10,14,15,18,20,22,23)local l,pht,tb,mt,typeof,err_text=Level,{},Cdata.skip_tb,GS({},{__index=function(s,i)return i end}),C:load_libs"code.cssc""runtime""typeof"(2),"Unexpected '%s' in function argument Gt definition! Function argument Gt must be set using single name or string!"Runtime.build("func.def_arg",function(data)local res,val,tp,def,ch={}for i=1,#data,4 do
val=data[i+1]def=data[i+3]if val==nil and def then Ti(res,def)else
ch=data[i+2]if ch then
tp=typeof(val)ch=ch==1 and{[typeof(def)]=1}or TS{(Gl("return "..ch,nil,nil,mt)or Cp)()}ch=not ch[tp]and Ge(SF("bad argument #%d (%s expected, got %s)",data[i],data[i+2],tp),2)end
Ti(res,val)end
end
return Tu(res)end)Event.reg("lvl_open",function(lvl)if lvl.Gt=="function"then lvl.DA_np=1 end
if lvl.Gt=="("and l[#l].DA_np then lvl.DA_d={c_a=1}end
l[#l].DA_np=nil
end,"DA_lo",1)Event.reg(2,function(obj)local da,i,err=l[#l].DA_d
if da then i=da.c_a
if obj==":"then
da[i]=da[i]or{[4]=Result[Cdata.tb_while(tb,#Cdata-1)]}if not da[i][2]then
err,da[i][1]=da[i][1],#Cdata
end
elseif obj=="="then da[i]=da[i]or{[4]=Result[Cdata.tb_while(tb,#Cdata-1)]}err,da[i][2]=da[i][2],#Cdata
elseif obj==","then da.c_a=da.c_a+1(da[i]or pht)[3]=#Cdata-1
elseif not da[i]or not da[i][2]then err=1 end
if err then
Control.Ge("Unexpected '%s' operator in function arguments defenition.",obj)l[#l].DA_d=nil
end
end
end,"DA_op",1)Event.reg("lvl_close",function(lvl)if lvl.DA_d then
local da,arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Cdata.opts[","][1]for i=da.c_a,1,-1 do
if da[i]then val=da[i]ac,tej=0,nil
Ti(name,{val[4],3})Ti(name,{",",2,pr})if not val[2]then Ti(arr,{"nil",8})Ti(arr,{",",2,pr})end
val[3]=val[3]or#Result-1
for j=val[3]or#Result-1,val[1]or val[2],-1 do
obj=Cssc.eject(j)if j==val[2]or j==val[1]then
Ti(arr,{",",2,pr})elseif val[2]and j>val[2]then
Ti(arr,obj)ac=not tb[obj[2]]and ac+1 or ac
elseif not tb[obj[2]]then
if not(obj[2]==3 or obj[2]==7 or Sm(obj[1],"^nil"))then
Control.Ge(err_text,obj[1])elseif tej then
Control.Ge(err_text,obj[1])else
if obj[2]==3 then obj={"'"..Sm(obj[1],"%S+").."'",7}end
Ti(arr,obj)tej=1
end
end
end
if val[2]and ac<1 then Control.Ge("Expected default argument after '%s'",val[2]and"="or":")end
ac=not tej and val[1]if ac or not val[1]then Tr(ac and arr or pht)Ti(arr,{ac and"1"or"nil",8})Ti(arr,{",",2,pr})end
Ti(arr,{val[4],3})Ti(arr,{",",2,pr})Ti(arr,{Gs(i),8})Ti(arr,{",",2,pr})end
end
if not obj then return end
Runtime.reg("__cssc__def_arg","func.def_arg")Tr(name)for i=#name,1,-1 do Cssc.inject(Tu(Tr(name)))end
Cssc.inject("=",2,Cdata.opts["="][1])Cssc.inject("__cssc__def_arg",3)Cssc.inject("{",9)val=#Result
Tr(arr)for i=#arr,1,-1 do
Cssc.inject(Tu(Tr(arr)))end
Cssc.inject("}",10,val)Cssc.inject("",2,0)end
end,"DA_lc",1)