
local cssc_beta,A,E,S,T,Cp,base_path,E_ENV,_={},assert,"cssc_beta load failed because of missing libruary method!",string,table,function()end,'/home/maggen/.local/share/craftos-pc/computer/0/cssc_final/out/'local SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,Gt,Gp,Ge,Gs,Gn,GG,GS,GP=A(S.gmatch,E),A(S.match,E),A(S.format,E),A(S.find,E),A(S.gsub,E),A(S.sub,E),A(T.insert,E),A(T.concat,E),A(T.remove,E),A(table.Tu,E),A(type,E),A(pairs,E),A(error,E),A(tostring,E),A(tonumber,E),A(getmetatable,E),A(setmetatable,E),A(pcall,E)local bit32=GP(require,"bit")and require"bit"or GP(require,"bit32")and require"bit32"or GP(require,"bitop")and(require"bitop".bit or require"bitop".bit32)or print and print"Warning! Bit32/bitop libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
local b={}for k,v in Gp(bit32)do b[k]=v end
b.shl=b.lshift
b.shr=b.rshift
b.lshift,b.rshift=nil
bit32=b
end
local Gl=A(load,E)local Gf=A(loadfile,E)local TC,TS,Cl=function(s,o,f)for k,v in Gp(s)do o[k]=f and o[k]or v end end,function(t,o)o=o or{}for k,v in Gp(t)do o[v]=k end return o end,function(...)local r={}for k,v in Gp{...}do Ti(r,E_ENV[v])end return Tu(r)end
E_ENV={SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,assert,Gt,Gp,Ge,Gs,Gn,GG,GS,GP,Gl,bit32,Cp,TS,TC,table,string,math,io,os,coroutine,debug,package,require}A,E,S,T=nil
local arg_check=function(Control)if(GG(Control)or{}).__type~="cssf_unit"then
Ge(SF("Bad argument #1 (expected cssf_unit, got %s)",Gt(Control)),3)end
end
local tab_run=function(Control,tab,br)for k,v in Gp(Control[tab])do if v(Control)and br then break end end end
local Configs,_arg,load_lib,load_libs,clear,make,run,read_control_string,load_control_string={cssc_basic="sys.err,cssc={NF,KS,LF,BO,CA}",cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}",cssc_full="sys.err,cssc={NF,KS(sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}"},{'arg'},function(Control,path,...)local ld,arg,tp=Control.Loaded[">"..path],{}if false~=ld then
Control.log("Load %s",">"..path)if ld and"function"==Gt(ld)then arg={ld(...)}Tr(arg,1)return Tu(arg)end
if ld and"table"==Gt(ld)then return Tu(ld)end
local r,e=Gf(base_path.."features/"..Sg(path,"%.","/")..".lua",nil,GS({C=Control,Control=Control,ENV=Cl,_G=_G,_E=_ENV},{__index=Control}))e=e and Ge("Lib ["..path.."]:"..e)arg={r(...)}tp=Tr(arg,1)or false
Control.Loaded[">"..path]=2==tp and arg or(tp==1)and r or tp
end
return Tu(arg)end
do
local mt mt={__index=function(s,p)Ti(s.p,p)return s end,__call=function(s,lib,...)if s==mt then return GS({r={},p={lib},C=...},mt)end
if Gt(lib)=="string"then Ti(s.r,{load_lib(s.C,Tc(s.p,".").."."..lib,...)})return s end
if Gt(lib)=="number"then local r,i={},1
for _,v in Gp{lib,...}do for _,v1 in Gp(s.r[v]or{(v<0 and s)or(v<1 and s.r)or nil})do r[i]=v1 i=i+1 end end
return Tu(r)end
Tr(s.p)return s
end}load_libs=function(Control,path)local s=mt.__call(mt,path,Control)return s end
end
clear=function(Obj)arg_check(Obj)tab_run(Obj.data,"Clear")end
run=function(Obj,x,...)arg_check(Obj)local Control=Obj.data
tab_run(Control,"Clear")Control.src=x
Control.args={...}tab_run(Control,"PreRun")while not Control.Iterator(0)do tab_run(Control,"Struct",1)end
tab_run(Control,"PostRun")local e=Gt(Control.Return)if"function"==e then
return Control.Return()elseif"table"==e then
return Tu(Control.Return)else
return Control.Return
end
end
make=function(ctrl_str)if"string"~=Gt(ctrl_str)then Ge(SF("Bad argument #2 (expected string, got %s)",Gt(ctrl_str)))end
local m,i,Control,Obj,r={__type="cssf_unit",__name="cssf_unit"},1
r={__call=function(S,s,...)if#S>999 then Tr(S,1)end
Ti(S,SF("%-16s : "..s,SF("[%0.3d] [%s]",i,S._),...))i=i+1
end}Control={load_lib=load_lib,load_libs=load_libs,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},Ge=GS({_=" Error "},r),log=GS({_="  Log  "},r),warn=GS({_="Warning"},r),Core=placeholedr_func,Iterator=Gl"return 1",}Obj=GS({data=Control,run=run,info="C SuS SuS Framework object"},m)Control.User=Obj
load_control_string(Control,read_control_string(ctrl_str))tab_run(Control,"PostLoad")return Obj
end
read_control_string=function(s)local c,t,l,e,m={"config",[_arg]={}}m={__index=function(s,i)s=s==c and GS({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==Gt(l[i])and l[i][_arg]and Tc(l[i],".")or l[i]end
s[_arg][s[#s]]=#l==1 and"table"==Gt(l[1])and l[1]or l
return s end}l,e=Gl(Sg(SF("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,GS({},{__index=function(s,i)return GS(i==c[1]and c or{[_arg]={},i},m)end}))l=e and Ge(SF("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=GP(Tc,s)e=Configs[t and e or s]t=1
for k,v in Gp(e and read_control_string(e)or{})do
if"number"==Gt(k)then Ti(l,t,v)t=t+1 else l[k]=v end
end
return l,a
end
load_control_string=function(Control,main,subm,path,cur_sc)local prt,mod,e,sc
if path then
prt=Tr(main,1)path=path..((cur_sc or{})[prt]or prt)mod,e=Gf(base_path.."modules/"..Sg(Ss(path,2),"%.","/")..".lua",nil,GS({C=Control,Control=Control,ENV=Cl,_G=_G,_E=_ENV},{__index=Control}))e=e and Ge(SF('Error loading module "%s": %s',path,e),4)Control.Loaded[path],e=GP(function()if Control.Loaded[path]then return end
Control.log("Load %s",path)sc=(mod or Cp)(path,main[_arg][prt])end)e=e and Ge(SF('Error loading module "%s": %s',path,e),4)else
mod=1
subm=main
main={}end
if mod and sc~=1 then
path=path and path.."."or"@"if#main>0 then load_control_string(Control,main,subm,path,sc)else for k,v in Gp(subm or{})do
e=e or"string"==Gt(v)v=e and{v}or v
v="number"==Gt(k)and{v}or{k,v}load_control_string(Control,v[1],v[2],path,sc)end end
end
end
cssc_beta={make=make,Configs=Configs,creator="M.A.G.Gen.",version='4.5-beta'}_G.cssc_beta=cssc_beta
return cssc_beta