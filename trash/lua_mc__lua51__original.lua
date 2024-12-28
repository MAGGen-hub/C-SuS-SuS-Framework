
local A,E=assert,"lua_mc load failed because of missing libruary method!"local base_path=__BASE_PATH__
local gmatch=A(string.gmatch,E)local match=A(string.match,E)local format=A(string.format,E)local find=A(string.find,E)local gsub=A(string.gsub,E)local sub=A(string.sub,E)local insert=A(table.insert,E)local concat=A(table.concat,E)local remove=A(table.remove,E)local unpack=A(unpack,E)local floor=A(math.floor,E)local assert=A
local type=A(type,E)local pairs=A(pairs,E)local error=A(error,E)local tostring=A(tostring,E)local tonumber=A(tonumber,E)local getmetatable=A(getmetatable,E)local setmetatable=A(setmetatable,E)local pcall=A(pcall,E)local _
local bit32=pcall(require,"bit")and require"bit"or pcall(require,"bit32")and require"bit32"or pcall(require,"bitop")and(require"bitop".bit or require"bitop".bit32)or print and print"Warning! Bit32/bitop libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
local b={}for k,v in pairs(bit32)do b[k]=v end
b.shl=b.lshift
b.shr=b.rshift
b.lshift,b.rshift=nil
bit32=b
end
local native_load,native_loadfile
do
local loadstring,load,setfenv,loadfile=A(loadstring,E),A(load,E),A(setfenv,E),A(loadfile,E)native_load=function(x,name,mode,env)local r,e=(type(x)=="string"and loadstring or load)(x,name)if env and r then setfenv(r,env)end
return r,e
end
native_loadfile=function(filename,mode,env)local r,e=loadfile(filename)if env and r then setfenv(r,env)end
return r,e
end
end
A,E=nil
local lua_mc={}local placeholder_func=function()end
local t_copy,t_swap=function(s,o,f)for k,v in pairs(s)do o[k]=f and o[k]or v end end,function(t,o)o=o or{}for k,v in pairs(t)do o[v]=k end return o end
local E_ENV
local env_load=function(...)local rez={}for k,v in pairs{...}do insert(rez,E_ENV[v])end
return unpack(rez)end
E_ENV={gmatch,match,format,find,gsub,sub,insert,concat,remove,unpack,floor,assert,type,pairs,error,tostring,tonumber,getmetatable,setmetatable,pcall,native_load,bit32,placeholder_func,t_swap,t_copy}local arg_check=function(Control)if(getmetatable(Control)or{}).__type~="cssf_unit"then
error(format("Bad argument #1 (expected cssf_unit, got %s)",type(Control)),3)end
end
local tab_run=function(Control,tab,br)for k,v in pairs(Control[tab])do if v(Control)and br then break end end end
local Configs,_arg,load_lib,continue,clear,make,run,read_control_string,load_control_string={cssc_basic="sys.err,cssc={NF,KS,LF,BO,CA}",cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS}",cssc_full="sys.err,cssc={NF,KS(sc_end,pl_cond),LF,DA,BO,CA,NC,IS}"},{'arg'},function(Control,path,...)local ld,arg,tp=Control.Loaded[">"..path],{}if false~=ld then
Control.log("Load %s",">"..path)if ld and"function"==type(ld)then arg={ld(...)}remove(arg,1)return unpack(arg)end
if ld and"table"==type(ld)then return unpack(ld)end
local r,e=native_loadfile(base_path.."features/"..gsub(path,"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))e=e and error("Lib ["..path.."]:"..e)arg={r(...)}tp=remove(arg,1)or false
Control.Loaded[">"..path]=2==tp and arg or(tp==1)and r or tp
end
return unpack(arg)end
clear=function(Obj)arg_check(Obj)tab_run(Obj.data,"Clear")end
run=function(Obj,x,...)arg_check(Obj)local Control=Obj.data
tab_run(Control,"Clear")Control.src=x
Control.args={...}tab_run(Control,"PreRun")while not Control.Iterator(0)do tab_run(Control,"Struct",1)end
tab_run(Control,"PostRun")local e=type(Control.Return)if"function"==e then
return Control.Return()elseif"table"==e then
return unpack(Control.Return)else
return Control.Return
end
end
make=function(ctrl_str)if"string"~=type(ctrl_str)then error(format("Bad argument #2 (expected string, got %s)",type(ctrl_str)))end
local m,i,Control,Obj,r={__type="cssf_unit",__name="cssf_unit"},1
r={__call=function(S,s,...)if#S>999 then remove(S,1)end
insert(S,format("%-16s : "..s,format("[%0.3d] [%s]",i,S._),...))i=i+1
end}Control={load_lib=load_lib,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},error=setmetatable({_=" Error "},r),log=setmetatable({_="  Log  "},r),warn=setmetatable({_="Warning"},r),Core=placeholedr_func,Iterator=native_load"return 1",}Obj=setmetatable({data=Control,run=run,info="C SuS SuS Framework object"},m)Control.User=Obj
load_control_string(Control,read_control_string(ctrl_str))tab_run(Control,"PostLoad")return Obj
end
read_control_string=function(s)local c,t,l,e,m={"config",[_arg]={}}m={__index=function(s,i)s=s==c and setmetatable({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==type(l[i])and l[i][_arg]and concat(l[i],".")or l[i]end
s[_arg][s[#s]]=#l==1 and"table"==type(l[1])and l[1]or l
return s end}l,e=native_load(gsub(format("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,setmetatable({},{__index=function(s,i)return setmetatable(i==c[1]and c or{[_arg]={},i},m)end}))l=e and error(format("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=pcall(concat,s)e=Configs[t and e or s]t=1
for k,v in pairs(e and read_control_string(e)or{})do
if"number"==type(k)then insert(l,t,v)t=t+1 else l[k]=v end
end
return l,a
end
load_control_string=function(Control,main,subm,path,cur_sc)local prt,mod,e,sc
if path then
prt=remove(main,1)path=path..((cur_sc or{})[prt]or prt)mod,e=native_loadfile(base_path.."modules/"..gsub(sub(path,2),"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))e=e and error(format('Error loading module "%s": %s',path,e),4)Control.Loaded[path],e=pcall(function()if Control.Loaded[path]then return end
Control.log("Load %s",path)sc=(mod or placeholder_func)(path,main[_arg][prt])end)e=e and error(format('Error loading module "%s": %s',path,e),4)else
mod=1
subm=main
main={}end
if mod and sc~=1 then
path=path and path.."."or"@"if#main>0 then load_control_string(Control,main,subm,path,sc)else for k,v in pairs(subm or{})do
e=e or"string"==type(v)v=e and{v}or v
v="number"==type(k)and{v}or{k,v}load_control_string(Control,v[1],v[2],path,sc)end end
end
end
lua_mc={make=make,Configs=Configs,creator="M.A.G.Gen.",version='__VERSION__'}lua_mc.continue=continue
_G.lua_mc=lua_mc
return lua_mc