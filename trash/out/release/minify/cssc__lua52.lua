
local base_path=[[/home/maggen/.local/share/craftos-pc/computer/0/cssc_final/out/release/]]local cssc,A,S,T,E,Cp,E_ENV,_={},assert,string,table,"cssc load failed because of missing libruary method!",function()end
local SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,Gt,Gp,Ge,Gs,Gn,GG,GS,GP=A(S.gmatch,E),A(S.match,E),A(S.format,E),A(S.find,E),A(S.gsub,E),A(S.sub,E),A(T.insert,E),A(T.concat,E),A(T.remove,E),A(table.Tu,E),A(type,E),A(pairs,E),A(error,E),A(tostring,E),A(tonumber,E),A(getmetatable,E),A(setmetatable,E),A(pcall,E)local bit32=GP(require,"bit")and require"bit"or GP(require,"bit32")and require"bit32"or GP(require,"bitop")and(require"bitop".bit or require"bitop".bit32)or print and print"Warning! Bit32/bitop libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
local b={}for k,v in Gp(bit32)do b[k]=v end
b.shl=b.lshift
b.shr=b.rshift
b.lshift,b.rshift=nil
bit32=b
end
local Gl=A(load,E)local Gf=A(loadfile,E)local TC,TS,Ce=function(s,o,f)o=o or{}for k,v in Gp(s)do o[k]=f and o[k]or v end return o end,function(t,o)o=o or{}for k,v in Gp(t)do o[v]=k end return o end,function(...)local r={}for k,v in Gp{...}do Ti(r,E_ENV[v]or false)end return Tu(r)end
E_ENV={SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,A,Gt,Gp,Ge,Gs,Gn,GG,GS,GP,Gl,bit32,Cp,TS,TC,TC(T),TC(S),TC(math),}A,E,S,T=nil
local arg_check=function(Control)if(GG(Control)or{}).__type~="cssf_unit"then
Ge(SF("Bad argument #1 (expected cssf_unit, got %s)",Gt(Control)),3)end
end
local tab_run=function(Control,t,b)for k,v in Gp(Control[t])do if v(Control)and b then break end end end
local _arg,load_lib,load_libs,clear,run,read_control_string,load_control_string={'arg'},function(Control,l_path,...)local l_loaded,l_arg,rez_tp=Control.Loaded[">"..l_path],{}if false~=l_loaded then
Control.log("Load %s",">"..l_path)if l_loaded and"function"==Gt(l_loaded)then l_arg={l_loaded(...)}Tr(l_arg,1)return Tu(l_arg)end
if l_loaded and"table"==Gt(l_loaded)then return Tu(l_loaded)end
local r,e=Gf(base_path.."features/"..Sg(l_path,"%.","/")..".lua",nil,GS({C=Control,Control=Control,ENV=Ce,_G=_G,_E=_ENV},{__index=Control}))e=e and Ge("Lib ["..l_path.."]:"..e)l_arg={r(...)}rez_tp=Tr(l_arg,1)or false
Control.Loaded[">"..l_path]=2==rez_tp and l_arg or(rez_tp==1)and r or rez_tp
end
return Tu(l_arg)end
do
local m m={__index=function(s,p)Ti(s.p,p)return s end,__call=function(s,l,...)if s==m then return GS({r={},p={l},C=...},m)end
if Gt(l)=="string"then Ti(s.r,{load_lib(s.C,Tc(s.p,".").."."..l,...)})return s end
if Gt(l)=="number"then local r,i={},1
for _,v in Gp{l,...}do for _,v1 in Gp(s.r[v]or{(v<0 and s)or(v<1 and s.r)or nil})do r[i]=v1 i=i+1 end end
return Tu(r)end
Tr(s.p)return s
end}load_libs=function(Control,l_path)local s=m.__call(m,l_path,Control)return s end
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
read_control_string=function(s,C)local c,t,l,e,m={"config",[_arg]={}}m={__index=function(s,i)s=s==c and GS({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==Gt(l[i])and l[i][_arg]and Tc(l[i],".")or l[i]end
s[_arg][s[#s]]=#l==1 and"table"==Gt(l[1])and l[1]or l
return s end}l,e=Gl(Sg(SF("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,GS({},{__index=function(s,i)return GS(i==c[1]and c or{[_arg]={},i},m)end}))l=e and Ge(SF("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=GP(Tc,s)e=C[t and e or s]t=1
for k,v in Gp(e and read_control_string(e,C)or{})do
if"number"==Gt(k)then Ti(l,t,v)t=t+1 else l[k]=v end
end
return l,a
end
load_control_string=function(Control,main,subm,l_path,cur_aliases)local path_prt,l_mod,e,aliases
if l_path then
path_prt=Tr(main,1)l_path=l_path..((cur_aliases or{})[path_prt]or path_prt)l_mod,e=Gf(base_path.."modules/"..Sg(Ss(l_path,2),"%.","/")..".lua",nil,GS({C=Control,Control=Control,ENV=Ce,_G=_G,_E=_ENV},{__index=Control}))e=e and Ge(SF('Error loading module "%s": %s',l_path,e),4)Control.Loaded[l_path],e=GP(function()if Control.Loaded[l_path]then return end
Control.log("Load %s",l_path)aliases=(l_mod or Cp)(l_path,main[_arg][path_prt])end)e=e and Ge(SF('Error loading module "%s": %s',l_path,e),4)else
l_mod=1
subm=main
main={}end
if l_mod and aliases~=1 then
l_path=l_path and l_path.."."or"@"if#main>0 then load_control_string(Control,main,subm,l_path,aliases)else for k,v in Gp(subm or{})do
e=e or"string"==Gt(v)v=e and{v}or v
v="number"==Gt(k)and{v}or{k,v}load_control_string(Control,v[1],v[2],l_path,aliases)end end
end
end
cssc=GS({Configs={cssc_basic="sys.err,cssc={NF,KS,BO,CA,ncbf}",cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}",cssc_full="sys.err,cssc={NF,KS(ret,loc,sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}",lua_53="sys.err,cssc={BO,ncbf}"},creator="M.A.G.Gen.",version='4.5-beta'},{__type="cssf",__name="cssf",__call=function(S,l_ctrl_str)if"string"~=Gt(l_ctrl_str)then Ge(SF("Bad argument #2 (expected string, got %s)",Gt(l_ctrl_str)))end
local m,i,Control,Obj,r={__type="cssf_unit",__name="cssf_unit"},1
r={__call=function(S,s,...)if#S>999 then Tr(S,1)end
Ti(S,SF("%-16s : "..s,SF("[%0.3d] [%s]",i,S._),...))i=i+1
end}Control={load_lib=load_lib,load_libs=load_libs,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},Ge=GS({_=" Error "},r),log=GS({_="  Log  "},r),warn=GS({_="Warning"},r),Core=Cp,Iterator=Gl"return 1",}Obj=GS({data=Control,run=run,info="C SuS SuS Framework object"},m)Control.User=Obj
load_control_string(Control,read_control_string(l_ctrl_str,S.Configs))tab_run(Control,"PostLoad")return Obj
end})return cssc