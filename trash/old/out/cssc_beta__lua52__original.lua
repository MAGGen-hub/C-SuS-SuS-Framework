
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
local z,Cl,CL,clear,run,CS,Cs={'arg'},function(C,P,...)local L,a,t=C.Loaded[">"..P],{}if false~=L then
C.log("Load %s",">"..P)if L and"function"==Gt(L)then a={L(...)}Tr(a,1)return Tu(a)end
if L and"table"==Gt(L)then return Tu(L)end
local r,e=Gf(base_path.."features/"..Sg(P,"%.","/")..".lua",nil,GS({C=C,Control=C,ENV=Ce,_G=_G,_E=_ENV},{__index=C}))e=e and Ge("Lib ["..P.."]:"..e)a={r(...)}t=Tr(a,1)or false
C.Loaded[">"..P]=2==t and a or(t==1)and r or t
end
return Tu(a)end
do
local m m={__index=function(s,p)Ti(s.p,p)return s end,__call=function(s,l,...)if s==m then return GS({r={},p={l},C=...},m)end
if Gt(l)=="string"then Ti(s.r,{Cl(s.C,Tc(s.p,".").."."..l,...)})return s end
if Gt(l)=="number"then local r,i={},1
for _,v in Gp{l,...}do for _,v1 in Gp(s.r[v]or{(v<0 and s)or(v<1 and s.r)or nil})do r[i]=v1 i=i+1 end end
return Tu(r)end
Tr(s.p)return s
end}CL=function(C,P)local s=m.__call(m,P,C)return s end
end
clear=function(O)arg_check(O)Cr(O.data,"Clear")end
run=function(O,x,...)arg_check(O)local C=O.data
Cr(C,"Clear")C.src=x
C.args={...}Cr(C,"PreRun")while not C.Iterator(0)do Cr(C,"Struct",1)end
Cr(C,"PostRun")local e=Gt(C.Return)if"function"==e then
return C.Return()elseif"table"==e then
return Tu(C.Return)else
return C.Return
end
end
CS=function(s,C)local c,t,l,e,m={"config",[z]={}}m={__index=function(s,i)s=s==c and GS({c[1],[z]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==Gt(l[i])and l[i][z]and Tc(l[i],".")or l[i]end
s[z][s[#s]]=#l==1 and"table"==Gt(l[1])and l[1]or l
return s end}l,e=Gl(Sg(SF("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,GS({},{__index=function(s,i)return GS(i==c[1]and c or{[z]={},i},m)end}))l=e and Ge(SF("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=GP(Tc,s)e=C[t and e or s]t=1
for k,v in Gp(e and CS(e,C)or{})do
if"number"==Gt(k)then Ti(l,t,v)t=t+1 else l[k]=v end
end
return l,a
end
Cs=function(C,M,S,P,A)local o,m,e,a
if P then
o=Tr(M,1)P=P..((A or{})[o]or o)m,e=Gf(base_path.."modules/"..Sg(Ss(P,2),"%.","/")..".lua",nil,GS({C=C,Control=C,ENV=Ce,_G=_G,_E=_ENV},{__index=C}))e=e and Ge(SF('Error loading module "%s": %s',P,e),4)C.Loaded[P],e=GP(function()if C.Loaded[P]then return end
C.log("Load %s",P)a=(m or Cp)(P,M[z][o])end)e=e and Ge(SF('Error loading module "%s": %s',P,e),4)else
m=1
S=M
M={}end
if m and a~=1 then
P=P and P.."."or"@"if#M>0 then Cs(C,M,S,P,a)else for k,v in Gp(S or{})do
e=e or"string"==Gt(v)v=e and{v}or v
v="number"==Gt(k)and{v}or{k,v}Cs(C,v[1],v[2],P,a)end end
end
end
cssc_beta=GS({Configs={cssc_basic="sys.err,cssc={NF,KS,LF,BO,CA}",cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}",cssc_full="sys.err,cssc={NF,KS(sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}"},creator="M.A.G.Gen.",version='4.5-beta'},{__call=function(S,X)if"string"~=Gt(X)then Ge(SF("Bad argument #2 (expected string, got %s)",Gt(X)))end
local m,i,C,O,r={__type="cssf_unit",__name="cssf_unit"},1
r={__call=function(S,s,...)if#S>999 then Tr(S,1)end
Ti(S,SF("%-16s : "..s,SF("[%0.3d] [%s]",i,S._),...))i=i+1
end}C={load_lib=Cl,load_libs=CL,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},error=GS({_=" Error "},r),log=GS({_="  Log  "},r),warn=GS({_="Warning"},r),Core=Cp,Iterator=Gl"return 1",}O=GS({data=C,run=run,info="C SuS SuS Framework object"},m)C.User=O
Cs(C,CS(X,S.Configs))Cr(C,"PostLoad")return O
end})_G.cssc_beta=cssc_beta
return cssc_beta