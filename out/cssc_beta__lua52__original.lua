
local cssc_beta,A,S,T,E,Cp,base_path,E_ENV,_={},assert,string,table,"cssc_beta load failed because of missing libruary method!",function()end,'/home/maggen/.local/share/craftos-pc/computer/0/cssc_final/out/'local SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,Gt,Gp,Ge,Gs,Gn,GG,GS,GP=A(S.gmatch,E),A(S.match,E),A(S.format,E),A(S.find,E),A(S.gsub,E),A(S.sub,E),A(T.insert,E),A(T.concat,E),A(T.remove,E),A(table.Tu,E),A(type,E),A(pairs,E),A(error,E),A(tostring,E),A(tonumber,E),A(getmetatable,E),A(setmetatable,E),A(pcall,E)local bit32=GP(require,"bit")and require"bit"or GP(require,"bit32")and require"bit32"or GP(require,"bitop")and(require"bitop".bit or require"bitop".bit32)or print and print"Warning! Bit32/bitop libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
local b={}for k,v in Gp(bit32)do b[k]=v end
b.shl=b.lshift
b.shr=b.rshift
b.lshift,b.rshift=nil
bit32=b
end
local Gl=A(load,E)local Gf=A(loadfile,E)local TC,TS,Ce=function(s,o,f)o=o or{}for k,v in Gp(s)do o[k]=f and o[k]or v end return o end,function(t,o)o=o or{}for k,v in Gp(t)do o[v]=k end return o end,function(...)local r={}for k,v in Gp{...}do Ti(r,E_ENV[v])end return Tu(r)end
E_ENV={SG,Sm,SF,Sf,Sg,Ss,Ti,Tc,Tr,Tu,A,Gt,Gp,Ge,Gs,Gn,GG,GS,GP,Gl,bit32,Cp,TS,TC,TC(T),TC(S),TC(math),}A,E,S,T=nil
local arg_check=function(C)if(GG(C)or{}).__type~="cssf_unit"then
Ge(SF("Bad argument #1 (expected cssf_unit, got %s)",Gt(C)),3)end
end
local Cr=function(C,t,b)for k,v in Gp(C[t])do if v(C)and b then break end end end
local Configs,_arg,Cl,CL,clear,make,run,CS,Cs={cssc_basic="sys.err,cssc={NF,KS,LF,BO,CA}",cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}",cssc_full="sys.err,cssc={NF,KS(sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}"},{'arg'},function(C,path,...)local ld,arg,tp=C.Loaded[">"..path],{}if false~=ld then
C.log("Load %s",">"..path)if ld and"function"==Gt(ld)then arg={ld(...)}Tr(arg,1)return Tu(arg)end
if ld and"table"==Gt(ld)then return Tu(ld)end
local r,e=Gf(base_path.."features/"..Sg(path,"%.","/")..".lua",nil,GS({C=C,Control=C,ENV=Ce,_G=_G,_E=_ENV},{__index=C}))e=e and Ge("Lib ["..path.."]:"..e)arg={r(...)}tp=Tr(arg,1)or false
C.Loaded[">"..path]=2==tp and arg or(tp==1)and r or tp
end
return Tu(arg)end
do
local mt mt={__index=function(s,p)Ti(s.p,p)return s end,__call=function(s,lib,...)if s==mt then return GS({r={},p={lib},C=...},mt)end
if Gt(lib)=="string"then Ti(s.r,{Cl(s.C,Tc(s.p,".").."."..lib,...)})return s end
if Gt(lib)=="number"then local r,i={},1
for _,v in Gp{lib,...}do for _,v1 in Gp(s.r[v]or{(v<0 and s)or(v<1 and s.r)or nil})do r[i]=v1 i=i+1 end end
return Tu(r)end
Tr(s.p)return s
end}CL=function(C,path)local s=mt.__call(mt,path,C)return s end
end
clear=function(Obj)arg_check(Obj)Cr(Obj.data,"Clear")end
run=function(Obj,x,...)arg_check(Obj)local C=Obj.data
Cr(C,"Clear")C.src=x
C.args={...}Cr(C,"PreRun")while not C.Iterator(0)do Cr(C,"Struct",1)end
Cr(C,"PostRun")local e=Gt(C.Return)if"function"==e then
return C.Return()elseif"table"==e then
return Tu(C.Return)else
return C.Return
end
end
make=function(ctrl_str)if"string"~=Gt(ctrl_str)then Ge(SF("Bad argument #2 (expected string, got %s)",Gt(ctrl_str)))end
local m,i,C,Obj,r={__type="cssf_unit",__name="cssf_unit"},1
r={__call=function(S,s,...)if#S>999 then Tr(S,1)end
Ti(S,SF("%-16s : "..s,SF("[%0.3d] [%s]",i,S._),...))i=i+1
end}C={load_lib=Cl,load_libs=CL,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},error=GS({_=" Error "},r),log=GS({_="  Log  "},r),warn=GS({_="Warning"},r),Core=placeholedr_func,Iterator=Gl"return 1",}Obj=GS({data=C,run=run,info="C SuS SuS Framework object"},m)C.User=Obj
Cs(C,CS(ctrl_str))Cr(C,"PostLoad")return Obj
end
CS=function(s)local c,t,l,e,m={"config",[_arg]={}}m={__index=function(s,i)s=s==c and GS({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==Gt(l[i])and l[i][_arg]and Tc(l[i],".")or l[i]end
s[_arg][s[#s]]=#l==1 and"table"==Gt(l[1])and l[1]or l
return s end}l,e=Gl(Sg(SF("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,GS({},{__index=function(s,i)return GS(i==c[1]and c or{[_arg]={},i},m)end}))l=e and Ge(SF("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=GP(Tc,s)e=Configs[t and e or s]t=1
for k,v in Gp(e and CS(e)or{})do
if"number"==Gt(k)then Ti(l,t,v)t=t+1 else l[k]=v end
end
return l,a
end
Cs=function(C,main,subm,path,cur_sc)local prt,mod,e,sc
if path then
prt=Tr(main,1)path=path..((cur_sc or{})[prt]or prt)mod,e=Gf(base_path.."modules/"..Sg(Ss(path,2),"%.","/")..".lua",nil,GS({C=C,Control=C,ENV=Ce,_G=_G,_E=_ENV},{__index=C}))e=e and Ge(SF('Error loading module "%s": %s',path,e),4)C.Loaded[path],e=GP(function()if C.Loaded[path]then return end
C.log("Load %s",path)sc=(mod or Cp)(path,main[_arg][prt])end)e=e and Ge(SF('Error loading module "%s": %s',path,e),4)else
mod=1
subm=main
main={}end
if mod and sc~=1 then
path=path and path.."."or"@"if#main>0 then Cs(C,main,subm,path,sc)else for k,v in Gp(subm or{})do
e=e or"string"==Gt(v)v=e and{v}or v
v="number"==Gt(k)and{v}or{k,v}Cs(C,v[1],v[2],path,sc)end end
end
end
cssc_beta={make=make,Configs=Configs,creator="M.A.G.Gen.",version='4.5-beta'}_G.cssc_beta=cssc_beta
return cssc_beta