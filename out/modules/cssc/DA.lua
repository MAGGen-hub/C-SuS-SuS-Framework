local Sm,SF,Ti,Tr,Tu,Ge,Gs,GS,Gl,Cp,TS=ENV(2,3,7,9,10,14,15,18,20,22,23)local placeholder_table,skipper_tab,def_arg_meta,typeof,err_text={},Cdata.skip_tb,GS({},{__index=function(s,i)return i end}),C:load_libs"code.cssc""runtime""typeof"(2),"Unexpected '%s' in function argument Gt definition! Function argument Gt must be set using single name or string!"Runtime.build("func.def_arg",function(data)local res,value,value_tp,default_arg,type_check={}for i=1,#data,4 do
value=data[i+1]default_arg=data[i+3]if value==nil and default_arg then Ti(res,default_arg)else
type_check=data[i+2]if type_check then
value_tp=typeof(value)type_check=type_check==1 and{[typeof(default_arg)]=1}or TS{(Gl("return "..type_check,"DA_type_loader",nil,def_arg_meta)or Cp)()}type_check=not type_check[value_tp]and Ge(SF("bad argument #%d (%s expected, got %s)",data[i],data[i+2],value_tp),2)end
Ti(res,value)end
end
return Tu(res)end)Event.reg("lvl_open",function(lvl)if lvl.Gt=="function"then lvl.DA_np=1 end
if lvl.Gt=="("and Level[#Level].DA_np then lvl.DA_d={c_a=1}end
Level[#Level].DA_np=nil
end,"DA_lo",1)Event.reg(2,function(obj)local da_tab,i,err=Level[#Level].DA_d
if da_tab then i=da_tab.c_a
if obj==":"then
da_tab[i]=da_tab[i]or{[4]=Result[Cdata.tb_while(skipper_tab,#Cdata-1)]}if not da_tab[i][2]then
err,da_tab[i][1]=da_tab[i][1],#Cdata
end
elseif obj=="="then da_tab[i]=da_tab[i]or{[4]=Result[Cdata.tb_while(skipper_tab,#Cdata-1)]}err,da_tab[i][2]=da_tab[i][2],#Cdata
elseif obj==","then da_tab.c_a=da_tab.c_a+1(da_tab[i]or placeholder_table)[3]=#Cdata-1
elseif not da_tab[i]or not da_tab[i][2]then err=1 end
if err then
Control.Ge("Unexpected '%s' operator in function arguments defenition.",obj)Level[#Level].DA_d=nil
end
end
end,"DA_op",1)Event.reg("lvl_close",function(lvl)if lvl.DA_d then
local da_tab,build_arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Cdata.opts[","][1]for i=da_tab.c_a,1,-1 do
if da_tab[i]then
val,ac,tej=da_tab[i],0
Ti(name,{val[4],3})Ti(name,{",",2,pr})if not val[2]then Ti(build_arr,{"nil",8})Ti(build_arr,{",",2,pr})end
val[3]=val[3]or#Result-1
for j=val[3]or#Result-1,val[1]or val[2],-1 do
obj=Cssc.eject(j)if j==val[2]or j==val[1]then
Ti(build_arr,{",",2,pr})elseif val[2]and j>val[2]then
Ti(build_arr,obj)ac=not skipper_tab[obj[2]]and ac+1 or ac
elseif not skipper_tab[obj[2]]then
if not(obj[2]==3 or obj[2]==7 or Sm(obj[1],"^nil"))then
Control.Ge(err_text,obj[1])elseif tej then
Control.Ge(err_text,obj[1])else
if obj[2]==3 then obj={"'"..Sm(obj[1],"%S+").."'",7}end
Ti(build_arr,obj)tej=1
end
end
end
if val[2]and ac<1 then Control.Ge("Expected default argument after '%s'",val[2]and"="or":")end
ac=not tej and val[1]if ac or not val[1]then Tr(ac and build_arr or placeholder_table)Ti(build_arr,{ac and"1"or"nil",8})Ti(build_arr,{",",2,pr})end
Ti(build_arr,{val[4],3})Ti(build_arr,{",",2,pr})Ti(build_arr,{Gs(i),8})Ti(build_arr,{",",2,pr})end
end
if not obj then return end
Runtime.reg("__cssc__def_arg","func.def_arg")Tr(name)for i=#name,1,-1 do Cssc.inject(Tu(Tr(name)))end
Cssc.inject("=",2,Cdata.opts["="][1])Cssc.inject("__cssc__def_arg",3)Cssc.inject("{",9)val=#Result
Tr(build_arr)for i=#build_arr,1,-1 do
Cssc.inject(Tu(Tr(build_arr)))end
Cssc.inject("}",10,val)Cssc.inject("",2,0)end
end,"DA_lc",1)