
local A,E=assert,"cssc_beta load failed because of missing libruary method!"local gmatch=A(string.gmatch,E)local match=A(string.match,E)local format=A(string.format,E)local find=A(string.find,E)local gsub=A(string.gsub,E)local sub=A(string.sub,E)local insert=A(table.insert,E)local concat=A(table.concat,E)local remove=A(table.remove,E)local unpack=A(unpack,E)local floor=A(math.floor,E)local assert=A
local type=A(type,E)local pairs=A(pairs,E)local error=A(error,E)local tostring=A(tostring,E)local getmetatable=A(getmetatable,E)local setmetatable=A(setmetatable,E)local pcall=A(pcall,E)local _
local bit32=pcall(require,"bit")and require"bit"or pcall(require,"bit32")and require"bit32"or pcall(require,"bitop")and(require"bitop".bit or require"bitop".bit32)or print and print"Warning! Bit32/bitop libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
local b={}for k,v in pairs(bit32)do b[k]=v end
b.shl=b.lshift
b.shr=b.rshift
b.lshift,b.rshift=nil
bit32=b
end
local native_load
do
local loadstring,load,setfenv=A(loadstring,E),A(load,E),A(setfenv,E)native_load=function(x,name,mode,env)local r,e=(type(x)=="string"and loadstring or load)(x,name)if env and r then setfenv(r,env)end
return r,e
end
end
A,E=nil
local cssc_beta={}local placeholder_func=function()end
local arg_check,t_copy,t_swap,Modules,Features=function(Control)if(getmetatable(Control)or{}).__type~="cssc_unit"then error(format("Bad argument #1 (expected cssc_unit, got %s)",type(Control)),3)end end,function(s,o,f)for k,v in pairs(s)do o[k]=f and o[k]or v end end,function(t,o)o=o or{}for k,v in pairs(t)do o[v]=k end return o end
local Configs,_init,_modules,_arg,load_lib,continue,clear,make,run,read_control_string,load_control_string={cssc="lua.cssc=M.KS.IS.N.CA.DA.NF.LF"},setmetatable({},{__tostring=native_load"return'init'"}),setmetatable({},{__tostring=native_load"return'modules'"}),{'arg'},function(Control,path,...)arg_check(Control)local ld,arg,tp=Control.Loaded[">"..path],{}if false~=ld then
Control.log("Load %s",">"..path)if ld and ld~=1 then return unpack(ld)end
arg={native_load("return "..path.."(...)","Feature Loader",nil,Features)(Control,...)}tp=remove(arg,1)or false
Control.Loaded[">"..path]=2==tp and arg or tp
end
return unpack(arg)end,function(Control,x,...)arg_check(Control)Control.src=x
Control.args={...}Control:tab_run"PreRun"while not Control.Iterator(0)do
Control:tab_run("Struct",1)end
Control:tab_run"PostRun"local e=type(Control.Return)if"function"==e then
return Control.Return()elseif"table"==e then
return unpack(Control.Return)else
return Control.Return
end
end,function(Control)arg_check(Control)Control:tab_run"Clear"end
run=function(Control,x,...)Control:clear()return Control:continue(x,...)end
make=function(ctrl_str)if"string"~=type(ctrl_str)then error(format("Bad argument #2 (expected string, got %s)",type(ctrl_str)))end
local m,i,Control,r={__type="cssc_unit",__name="cssc_unit"},1
r={__call=function(S,s,...)if#S>999 then remove(S,1)end insert(S,format("%-16s : "..s,format("[%0.3d] [%s]",i,S._),...))i=i+1 end}Control=setmetatable({ctrl=ctrl_str,run=run,clear=clear,continue=continue,load_lib=load_lib,tab_run=function(Control,tab,br)for k,v in pairs(Control[tab])do if v(Control)and br then break end end end,PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},error=setmetatable({_=" Error "},r),log=setmetatable({_="  Log  "},r),warn=setmetatable({_="Warning"},r),Core=placeholedr_func,Iterator=native_load"return 1",meta=m},m)load_control_string(Control,read_control_string(ctrl_str))Control:tab_run"PostLoad"return Control
end
read_control_string=function(s)local c,t,l,e,m={"config",[_arg]={}}m={__index=function(s,i)s=s==c and setmetatable({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)local l={...}for i=1,#l do l[i]="table"==type(l[i])and l[i][_arg]and concat(l[i],".")or l[i]end
s[_arg][s[#s]]=#l==1 and"table"==type(l[1])and l[1]or l
return s end}l,e=native_load(gsub(format("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,setmetatable({},{__index=function(s,i)return setmetatable(i==c[1]and c or{[_arg]={},i},m)end}))l=e and error(format("Invalid control string: <%s> -> %s",s,e))or l()s,l[c]=l[c]t,e=pcall(concat,s)e=Configs[t and e or s]t=1
for k,v in pairs(e and read_control_string(e)or{})do
if"number"==type(k)then insert(l,v,t)t=t+1 else l[k]=v end
end
return l,a
end
load_control_string=function(Control,main,sub,nxt,path)local prt,mod,e
if nxt then
prt=remove(main,1)mod=nxt[prt]or{}path=path..prt
Control.Loaded[path],e=pcall(function()if Control.Loaded[path]then return end
Control.log("Load %s",path);(mod[_init]or placeholder_func)(Control,mod,main[_arg][prt])end)mod=e and error(format('Error loading module "%s": %s',path,e),4)or mod[_modules]else
mod=Modules
sub=main
end
if mod then
path=path and path.."."or"@"if nxt and#main>0 then load_control_string(Control,main,sub,mod,path)else for k,v in pairs(sub or{})do
e=e or"string"==type(v)v=e and{v}or v
v="number"==type(k)and{v}or{k,v}load_control_string(Control,v[1],v[2],mod,path)end end
end
end
do
Features={code={cdata=function(Control,opts_hash,level_hash)local check,c,clr=t_swap{2,4,9}clr=function()for i=1,#c do c[i]=nil end c[1]={2,0}end
c={opts=opts_hash,lvl=level_hash,run=function(obj,tp)local lh,rez=c.lvl[obj]if lh and lh[2]then
rez=Control.Level[#Control.Level]rez={tp,rez.ends[obj]and rez.index}elseif tp==2 then
local pd,lt,un=c.opts[obj],c[#c][1]un=pd[2]and(not pd[1]or not check[lt])rez={tp,not un and pd[1],un and pd[2]}else
rez={tp}end
c[#c+1]=rez
end,reg=function(tp,id,...)local rez={tp,...}insert(c,id or#c+1,rez)end,del=function(id)return remove(c,id or#c+1)end,tb_until=function(type_tab,i)i=i or#c+1
repeat i=i-1 until i<1 or type_tab[c[i][1]]return i,c[i]end,tb_while=function(type_tab,i)i=i or#c
while i>0 and type_tab[c[i][1]]do i=i-1 end
return i,c[i]end,{2,0}}Control.Cdata=c
insert(Control.Clear,clr)end,cssc={op_stack=function(Control)local L,CD,pht=Control.Level,Control.Cdata,{}Control.Event.reg("lvl_close",function(lvl)if lvl.OP_st then
local i=#CD
for k=#lvl.OP_st,1,-1 do
Control.inject(i,")",10,lvl.OP_st[k][4])end
end
end,"OP_st_f",1)Control.Event.reg(2,function(obj,tp)local lvl,cdt,st,cst=L[#L],CD[#CD]st=lvl.OP_st
if st and cdt[2]then
while#st>0 and cdt[2]<=st[#st][2]do
cst=remove(st)Control.inject(#CD,")",10,cst[4])end
end
end,"OP_st_d",1)Control.inject_operator=function(pre_tab,priority,is_unary,skip_fb,now_end)local lvl,i,cdt,b,st,sp,last=L[#L],#CD
cdt,st,pre_tab=CD[i],lvl.OP_st or{},pre_tab or{}sp=#st>0 and st[#st][4]or lvl.index
if not is_unary then
while i>sp and not(cdt[1]==2 and(cdt[2]or cdt[3])<priority)do
i=(L.data[Control.Result[i]]or pht)[2]and cdt[2]or i-1
cdt=CD[i]end
last=cdt
else
_,last=Control.Cdata.tb_while({[11]=1},i-1)end
if i<sp then Control.error("OP_STACK Unexpected error!")end
i=i+1
if not skip_fb then
Control.inject(i,"(",9)if#pre_tab>0 then
Control.inject(i,"",2,Control.Cdata.opts[":"][1])end
for k=#pre_tab,1,-1 do
Control.inject(i,unpack(pre_tab[k]))end
end
if now_end then
Control.inject(nil,")",10)return i-1,last
end
insert(st,{#CD,priority,i,i+#pre_tab})lvl.OP_st=st
return i-1,last
end
end,pdata=function(Control,path,dt)local p,clr
p={path=path or"__cssc_beta__runtime",locals={},modules={},data=dt or setmetatable({},{__call=function(self,...)local t={}for _,v in pairs{...}do
insert(t,self[v]or error(format("Unable to load '%s' run-time module!",v)))end
return unpack(t)end}),reg=function(l_name,m_name)insert(p.locals,l_name)insert(p.modules,"'"..m_name.."'")end,build=function(m_name,func)if(not p.data[m_name]or Control.error("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name))then p.data[m_name]=func end
end,is_done=false,mk_env=function(tb)tb=tb or{}if#p.locals>0 then
if tb[p.path]then Control.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,tb)end
tb[p.path]=p.data
end
return tb
end}insert(Control.PostRun,function()if not p.is_done and#p.locals>0 then
insert(Control.Result,1,"local "..concat(p.locals,",").."="..p.path.."("..concat(p.modules,",")..");")end
p.is_done=true
end)clr=function()p.locals={}p.modules={}p.is_done=false
end
Control.Runtime=p
insert(Control.Clear,clr)end,},lua={base=function(Control,O,W)local make_react,lvl,kw,kwrd,opt,t,p,lua51=Control:load_lib"text.dual_queue.make_react",{},{},{},{},{},1,[[K
end
else 1
elseif
then 1 2 3
do 1
in 5
until
if 4
function 1
for 5 6
while 5
repeat 7
elseif 4
local
return
break
B
{ }
[ ]
( )
V
...
nil
true
false
O
;
=
,
or
and
< > <= >= ~= ==




..
+ -
* / // %
not # -
^
. :
]]Control:load_lib"text.dual_queue.base"Control:load_lib"code.syntax_loader"(lua51,{K=function(k,...)kw[#kw+1]=k
t=lvl[k]or{}for k,v in pairs{...}do
v=tonumber(v)t[1]=t[1]or{}t[1][kw[v]]=1
lvl[kw[v]][2]=1
end
kwrd[k]=1
lvl[k]=t
W[k]=make_react(k,4)end,B=function(o,c)lvl[o]={{[c]=1}}lvl[c]={nil,1}O[o]=make_react(o,9)O[c]=make_react(c,10)end,V=function(v)(match(v,"%w")and W or O)[v]=make_react(v,8)end,O=function(...)for k,v in pairs{...}do if""~=v then
opt[v]=opt[v]and{opt[v][1],p}or{p}if match(v,"%w")then W[v]=W[v]or make_react(v,2)else O[v]=O[v]or v end
end end
p=p+1
end})lvl["do"][3]=1
opt["not"]={nil,opt["not"][1]}opt["#"]={nil,opt["#"][1]}return 1,lvl,opt,kwrd
end,meta_opt=function(Control,place_mark)local call_prew=t_swap{7,10,3}local call_nxt=t_swap{7,9}local stat_end_prew=t_swap{3,10,7,8,6}local stat_end_nxt=t_swap{3,4,8,6}return 2,function(prew,nxt,spifc)if call_prew[prew]and call_nxt[nxt]then
place_mark(1)elseif stat_end_prew[prew]and stat_end_nxt[nxt]or prew==4 and not spifc then
place_mark(-1)end
end
end,struct=function(Control)local get_number_part=function(nd,f)local ex
nd[#nd+1],ex,Control.word=match(Control.word,format("^(%s*([%s]?%%d*))(.*)",unpack(f)))Control.operator=""if#Control.word>0 or#ex>1 then return 1 end
if#ex>0 then
Control.Iterator()ex=match(Control.operator or"","^[+-]$")if ex then
nd[#nd+1]=ex
nd[#nd+1],Control.word=match(Control.word,"^(%d*)(.*)")Control.operator=""end
return 1
end
end
local get_number,split_seq=function()local c,d=match(Control.word,"^0x")d=Control.operator=="."and not c
if not match(Control.word,"^%d")or not d and#Control.operator>0 then return end
local num_data,f=d and{"."}or{},c and{"0x%x","Pp"}or{"%d","Ee"}if get_number_part(num_data,f)or"."==num_data[1]then return num_data end
Control.Iterator()if Control.operator=="."then
num_data[#num_data+1]="."f[1]=sub(f[1],-2)get_number_part(num_data,f)end
return num_data
end,function(data,i,seq)seq=seq and"word"or"operator"if data then
data[#data+1]=i and sub(Control[seq],1,i)or Control[seq]end
Control[seq]=i and sub(Control[seq],i+1)or""Control.index=Control.index+(i or 0)return i
end
insert(Control.Struct,function()local com,rez,mode,lvl,str=#Control.operator>0 and"operator"or"word"if#Control.operator>0 then
rez,com,lvl={},match(Control.operator,"^(-?)%1%[(=*)%[")com=match(Control.operator,"^-%-")str=match(Control.operator,"^['\"]")if lvl then
lvl="%]"..lvl.."()%]"repeat
if split_seq(rez,match(Control.operator,lvl))then mode=com and 11 or 7 break end
insert(rez,Control.word)until Control.Iterator()elseif str then
split_seq(rez,1)str="(\\*()["..str.."\n])"while Control.index do
com,mode=match(Control.operator,str)if split_seq(rez,mode)then
mode=match(com,"\n$")lvl=lvl or mode
if#com%2>0 then mode=not mode and 7 break end
else
if split_seq(rez,match(Control.word,"()\n"),1)then break end
Control.Iterator()end
end
elseif com then
repeat
if split_seq(rez,match(Control.operator,"()\n"))or split_seq(rez,match(Control.word,"()\n"),1)then Control.line=Control.line+1 break end
until Control.Iterator()mode=11
else
rez=get_number()mode=rez and 6
end
elseif#Control.word>0 then
rez=get_number()mode=rez and 6
end
if rez then
rez=concat(rez)if lvl then
rez,com=gsub(rez,"\n",{})Control.line=Control.line+com
end
Control.Result[#Control.Result+1]=rez
Control.Core(mode or 12,rez)return true
end
end)return __REZULTABLE__,get_number_part,split_seq
end,},syntax_loader=function()return 2,function(str,f)local mode,t=placeholder_func,{}for o,s in gmatch(str,"(.-)(%s)")do
t[#t+1]=o
if s=="\n"then
mode=#t==1 and f[o]or mode(unpack(t))or mode
t={}end
end
end
end,},common={event=function(Control)local clr,e
clr=function()e.temp={}end
e={main={},reg=function(name,func,id,gl)local l=e.temp[name]or{}id=id or#l+1
if"number"==type(id)then insert(l,id,func)else l[id]=func end
e[gl and"main"or"temp"][name]=l
return id
end,run=function(name,...)local l,rm=e.temp[name]or{},{}for k,v in pairs(e.main[name]or{})do v(...)end
for k,v in pairs(l)do rm[k]=v(...)end
for k in pairs(rm)do
if"number"==type(k)then remove(l,k)else l[k]=nil end
end
end}clr()Control.Event=e
insert(Control.Clear,clr)end,level=function(Control,level_hash)local a,clr,l={["main"]=1}clr=function()for i=1,#l do l[i]=nil end l[1]={type="main",index=1,ends=a}end
l={{type="main",index=1,ends=a},data=level_hash,fin=function()if#l<2 then l.close("main",nil,a)else Control.error("Can't close 'main' level! Found (%d) unfinished levels!",#l-1)end
end,close=function(obj,nc,f)f=f==a and a or{}local lvl,e,r=remove(l)if f~=a and#l<1 then Control.error("Attempt to close 'main'(%d) level with '%s'!",#l+1,obj)insert(l,lvl)return end
e=lvl.ends or f
if e[obj]then Control.Event.run("lvl_close",lvl,obj)return
elseif nc then return end
r="'"for k in pairs(e)do r=r..k.."' or '"end r=sub(r,1,-6)Control.error(#r>0 and"Expected %s to close '%s' but got '%s'!"or"Attempt to close level with no ends!",r,lvl.type,obj)end,open=function(obj,ends,i)if#l<1 then Control.error("Attempt to open new level '%s' after closing 'main'!",obj)return end
local lvl={type=obj,index=i or#Control.Result,ends=ends or(l.data[obj]or{})[1]}Control.Event.run("lvl_open",lvl)insert(l,lvl)end,ctrl=function(obj)local t=l.data[obj]_=t and(t[2]and l.close(obj,t[3])or t[1]and l.open(obj,t[1]))if not t and l[#l].ends[obj]then l.close(obj)end
end}Control.Level=l
clr()insert(Control.Clear,clr)end,},text={dual_queue={base=function(Control)Control.Operators={}Control.operator=""Control.word=""Control.Words={}Control.Result[1]=""Control.max_op_len=3
Control.line=1
Control.Return=function()return concat(Control.Result)end
insert(Control.Clear,function()Control.Result={""}Control.operator=""Control.word=""end)end,init=function(Control)return 2,function(Control,mod)Control:load_lib"text.dual_queue.base"for k,v in pairs(mod.operators or{})do
Control.Operators[k]=v
end
for k,v in pairs(mod.words or{})do
Control.Words[k]=v
end
end
end,iterator=function(Control,seq)insert(Control.PreRun,function()local s=gmatch(Control.src,seq or"()([%s!-/:-@[-^{-~`]*)([%P_]*)")Control.Iterator=function(m)if m and(#(Control.operator or'')>0 or#(Control.word or'')>0)then return end
Control.index,Control.operator,Control.word=s()return not Control.index
end
end)end,make_react=function(Control)return 2,function(s,i,t,j)t=t or match(s,"%w")and"word"or"operator"j=j or#s
return function(Control)insert(Control.Result,s)Control[t]=sub(Control[t],j+1)Control.index=Control.index+j
Control.Core(i,s)end
end
end,parcer=function(Control)local func=function(react_obj,t,j,i,po)if"string"==type(react_obj)then Control.Result[#Control.Result+1]=react_obj
else react_obj=react_obj(Control,po)end
if react_obj then
Control[t]=sub(Control[t],j+1)Control.index=Control.index+j
Control.Core(i,react_obj)end
end
Control.Struct.final=function()local posible_obj,react_obj
if#Control.operator>0 then
for j=Control.max_op_len,1,-1 do
posible_obj=sub(Control.operator,1,j)react_obj=Control.Operators[posible_obj]if react_obj or j<2 then func(react_obj or posible_obj,"operator",j,react_obj and 2 or 1,posible_obj)break end
end
elseif#Control.word>0 then
posible_obj=match(Control.word,"^%S+")react_obj=Control.Words[posible_obj]or posible_obj
func(react_obj,"word",#posible_obj,3,posible_obj)end
end
end,space_handler=function(Control)insert(Control.Struct,function()local temp,space=#Control.operator>0 and"operator"or"word"space,Control[temp]=match(Control[temp],"^(%s*)(.*)")space,temp=gsub(space,"\n",{})Control.line=Control.line+temp
Control.Result[#Control.Result]=Control.Result[#Control.Result]..space
end)end,},},}end
do
Modules={cssc={[_init]=function(Control)Control:load_lib"text.dual_queue.base"Control:load_lib"text.dual_queue.parcer"Control:load_lib"text.dual_queue.iterator"Control:load_lib"text.dual_queue.space_handler"local lvl,opt,kwrd=Control:load_lib("code.lua.base",Control.Operators,Control.Words)Control.get_num_prt,Control.split_seq=Control:load_lib"code.lua.struct"Control:load_lib("code.cdata",opt,lvl,placeholder_func)Control:load_lib("common.event")Control:load_lib("common.level",lvl)Control.inject=function(id,obj,type,...)if id then insert(Control.Result,id,obj)else insert(Control.Result,obj)end
Control.Cdata.reg(type,id,...)end
Control.eject=function(id)return{remove(Control.Result,id),unpack(remove(Control.Cdata,id))}end
local meta_reg=Control:load_lib("code.lua.meta_opt",function(mark)local temp=remove(Control.Result)Control.inject(nil,"",2,mark>0 and opt[":"][1]or 0)Control.Event.run(2,"",2)Control.Event.run("all","",2)insert(Control.Result,temp)end)local tb=t_swap{11}Control.Core=function(tp,obj)local id_prew,c_prew,spifc=Control.Cdata.tb_while(tb)spifc=c_prew[1]==4 and match(Control.Result[id_prew],"^end")and match(Control.Result[c_prew[2]],"^function")meta_reg(c_prew[1],tp,spifc)Control.Cdata.run(obj,tp)Control.Event.run(tp,obj,tp)Control.Event.run("all",obj,tp)Control.Level.ctrl(obj)end
insert(Control.PostRun,function()Control.inject(nil,"",2,0)Control.Event.run(2,"",2)Control.Event.run("all","",2)Control.Level.fin()end)Control.cssc_load=function(x,name,mode,env)x=x==Control and Control.Return()or x
env=Control.Runtime and Control.Runtime.mk_env(env)or env
return native_load(x,name,mode,env)end
end,[_modules]={BO={[_init]=function(Control,direct)if not bit32 then Control.error("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end
direct=false
Control:load_lib"code.cssc.pdata"Control:load_lib"code.cssc.op_stack"local opts=Control.Cdata.opts
local stx=[[O
|
~
&
<< >>
//
]]local pht={}local p=opts["<"][1]+1
local p_un=opts["#"][2]local bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}local tb=t_swap{11}local check=t_swap{2,9,4}local loc_base="__cssc__bit_"local used_opts={}local idiv_func=function(a,b)return floor(a/b)end
Control:load_lib"code.syntax_loader"(stx,{O=function(...)for k,v,tab,has_un in pairs{...}do
has_un=v=="~"k=v=="//"and opts["*"][1]or p
opts[v]=has_un and{k,p_un}or{k}tab={{loc_base..bt[v],3}}has_un=has_un and{{loc_base.."bnot",3}}local bit_name,bit_func
if not direct then
local func=native_load(format([[local p,g,f={},... return function(a,b)return((g(a)or p).%s or(g(b)or p).%s or f)(a,b)end]],"__"..bt[v],"__"..bt[v]),loc_base..bt[v],nil,nil)(getmetatable,bit32[bt[v]]or idiv_func)Control.Runtime.build("bit."..bt[v],func,1)else Control.Runtime.build("bitD."..bt[v],func,1)end
Control.Operators[v]=function()local id,prew,is_un=Control.Cdata.tb_while(tb)is_un=has_un and prew[1]==2 or prew[1]==9
local i,d=Control.Cdata.tb_while(tb)if not is_un and check[d[1]]then Control.error("Unexpected '%s' after '%s'!",v,Control.Result[i])end
if not used_opts[is_un and"bnot"or v]then Control.Runtime.reg(is_un and loc_base.."bnot"or loc_base..bt[v],is_un and"bit.bnot"or"bit."..bt[v])end
Control.inject(nil,is_un and""or",",2,not is_un and k or nil,is_un and p_un or nil)Control.split_seq(nil,#v)Control.Event.run(2,v,2,1)Control.Event.run("all",v,2,1)Control.Event.reg("all",function(obj,tp)if tp==4 and not match(Control.Result[#Control.Result],"^function")or tp==10 or tp==2 and not Control.Cdata[#Control.Cdata][3]then Control.error("Unexpected '%s' after '%s'!",obj,v)end
return tp~=11 and 1
end)Control.inject_operator(is_un and has_un or tab,is_un and p_un or k,is_un)end
end
p=p+1
end})if not direct then
local func=native_load([[local p,g,f={},... return function(a)return((g(a)or p).__bnot or f)(a)end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot)Control.Runtime.build("bit.bnot",func,1)else
Control.Runtime.build("bitD.bnot",bit32.bnot,1)end
insert(Control.Clear,function()used_opts={}end)end},CA={[_init]=function(Control)Control:load_lib"code.cssc.pdata"Control:load_lib"code.cssc.op_stack"local prohibited_area=t_swap{"(","{","[","for","while","if","elseif","until"}local cond={["&&"]="and",["||"]="or"}local bitw
local b_func={}local s=1
local used
local stx=[[O
+ - * / % .. ^ ?
&& ||
]]if Control.Operators["~"]then stx=stx.."| & >> <<\n"bitw={["|"]="__cssc__bit_bor",["&"]="__cssc__bit_band",[">>"]="__cssc__bit_shr",["<<"]="__cssc__bit_shl"}end
Control.Runtime.build("op.qad",function(a,b)return a~=nil and a or b
end)Control:load_lib"code.syntax_loader"(stx,{O=function(...)for k,v,t,p in pairs{...}do
t=s==2 and cond[v]or v
p=s==3 and bitw[v]or v=="?"and"__cssc__op_qad"Control.Operators[v.."="]=function()if v=="?"and not used then used=1 Control.Runtime.reg("__cssc__op_qad","op.qad")end
local lvl=Control.Level[#Control.Level]if prohibited_area[lvl.type]or#(lvl.OP_st or"")>0 then
Control.error("Attempt to use additional asignment in prohibited area!")end
local i,last=Control.inject_operator(nil,Control.Cdata.opts[","][1]+1,false,1)if last[1]==2 and last[2]==Control.Cdata.opts[","][1]then
Control.error("Additional asignment do not support multiple additions is this version of cssc_beta!")end
if last[1]==2 and last[2]==0 and i-1>0 and Control.Cdata[i-1][1]==4 and match(Control.Result[i-1],"^local")then
Control.error("Attempt to perform additional asignment to local variable constructor!")end
local cur_i,cur_d=#Control.Cdata
Control.inject(nil,"=",2,Control.Cdata.opts["="][1])if p then
Control.inject(nil,p,3)Control.inject(nil,"(",9)cur_d=#Control.Cdata
end
for k=i+1,cur_i do
Control.inject(nil,Control.Result[k],unpack(Control.Cdata[k]))end
if not p then
if match(t,"^[ao]")then Control.Result[#Control.Result]=Control.Result[#Control.Result].." "end
Control.inject(nil,t,2,Control.Cdata.opts[t][1])Control.inject(nil,"(",9)cur_d=#Control.Cdata
else
Control.inject(nil,",",2,Control.Cdata.opts[","][1]+1)end
lvl.OP_st[#lvl.OP_st][3]=cur_d
lvl.OP_st[#lvl.OP_st][4]=cur_d
Control.split_seq(nil,#v+1)Control.Event.run(2,v.."=",2,1)Control.Event.run("all",v.."=",2,1)Control.Event.reg("all",function(obj,tp)if tp==4 and not match(Control.Result[#Control.Result],"^function")or tp==10 or tp==2 and not Control.Cdata[#Control.Cdata][3]then Control.error("Unexpected '%s' after '%s'!",obj,v.."=")end
return tp~=11 and 1
end)end
end
s=s+1
end})insert(Control.Clear,function()used=nil end)end},DA={[_init]=function(Control)Control:load_lib"code.cssc.pdata"local l,pht,ct=Control.Level,{},t_swap{11}local mt=setmetatable({},{__index=function(s,i)return i end})local def_arg_runtime_func=function(data)local res,val,tp,def,ch={}for i=1,#data,4 do
val=data[i+1]def=data[i+3]if val==nil and def then insert(res,def)else
ch=data[i+2]if ch then
tp=type(val)ch=ch==1 and{[type(def)]=1}or t_swap{(native_load("return "..ch,nil,nil,mt)or placeholder_func)()}ch=not ch[tp]and error(format("bad argument #%d (%s expected, got %s)",data[i],data[i+2],tp),2)end
insert(res,val)end
end
return unpack(res)end
Control.Runtime.build("func.def_arg",def_arg_runtime_func)Control.Runtime.reg("__cssc__def_arg")Control.Event.reg("lvl_open",function(lvl)if lvl.type=="function"then lvl.DA_np=1 end
if lvl.type=="("and l[#l].DA_np then lvl.DA_d={c_a=1}end
l[#l].DA_np=nil
end,"DA_lo",1)Control.Event.reg(2,function(obj)local da,i,err=l[#l].DA_d
if da then i=da.c_a
if obj==":"then
da[i]=da[i]or{[4]=Control.Result[Control.Cdata.tb_while(ct,#Control.Cdata-1)]}if not da[i][2]then
err,da[i][1]=da[i][1],#Control.Cdata
end
elseif obj=="="then da[i]=da[i]or{[4]=Control.Result[Control.Cdata.tb_while(ct,#Control.Cdata-1)]}err,da[i][2]=da[i][2],#Control.Cdata
elseif obj==","then da.c_a=da.c_a+1(da[i]or pht)[3]=#Control.Cdata-1
elseif not da[i]or not da[i][2]then err=1 end
if err then
Control.error("Unexpected '%s' operator in function arguments defenition.",obj)l[#l].DA_d=nil
end
end
end,"DA_op",1)local err_text="Unexpected '%s' in function argument type definition! Function argument type must be set using single name or string!"Control.Event.reg("lvl_close",function(lvl)if lvl.DA_d then
local da,arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Control.Cdata.opts[","][1]for i=da.c_a,1,-1 do
if da[i]then val=da[i]ac,tej=0,nil
insert(name,{val[4],3})insert(name,{",",2,pr})if not val[2]then insert(arr,{"nil",8})insert(arr,{",",2,pr})end
val[3]=val[3]or#Control.Result-1
for j=val[3]or#Control.Result-1,val[1]or val[2],-1 do
obj=Control.eject(j)if j==val[2]or j==val[1]then
insert(arr,{",",2,pr})elseif val[2]and j>val[2]then
insert(arr,obj)ac=11~=obj[2]and ac+1 or ac
elseif 11~=obj[2]then
if not(obj[2]==3 or obj[2]==7 or match(obj[1],"^nil"))then
Control.error(err_text,obj[1])elseif tej then
Control.error(err_text,obj[1])else
if obj[2]==3 then obj={"'"..match(obj[1],"%S+").."'",7}end
insert(arr,obj)tej=1
end
end
end
if ac<1 then Control.error("Expected default argument after '%s'",val[2]and"="or":")end
ac=not tej and val[1]if ac or not val[1]then remove(ac and arr or pht)insert(arr,{ac and"1"or"nil",8})insert(arr,{",",2,pr})end
insert(arr,{val[4],3})insert(arr,{",",2,pr})insert(arr,{tostring(i),8})insert(arr,{",",2,pr})end
end
if not obj then return end
remove(name)for i=#name,1,-1 do Control.inject(nil,unpack(remove(name)))end
Control.inject(nil,"=",2,Control.Cdata.opts["="][1])Control.inject(nil,"__cssc__def_arg",3)Control.inject(nil,"{",9)val=#Control.Result
remove(arr)for i=#arr,1,-1 do
Control.inject(nil,unpack(remove(arr)))end
Control.inject(nil,"}",10,val)Control.inject(nil,"",2,0)end
end,"DA_lc",1)end},IS={[_init]=function(Control)Control:load_lib"code.cssc.pdata"Control:load_lib"code.cssc.op_stack"local ltp,tab,used=type,{{"__cssc__kw_is",3}}Control.typeof=function(obj,comp)local md,tp,rez=ltp(comp),ltp(obj),false
if md=="string"then rez=tp==comp
elseif md=="table"then for i=1,#comp do rez=rez or tp==comp[i]end
else error("bad argument #2 to 'is' operator (got '"..md.."', expected 'table' or 'string')",2)end
return rez
end
local tb=t_swap{11}local check=t_swap{2,9,4}local after=t_swap{4,10}Control.Runtime.build("kwrd.is",Control.typeof)Control.Words["is"]=function()if not used then Control.Runtime.reg("__cssc__kw_is","kwrd.is")end
local i,d=Control.Cdata.tb_while(tb)if check[d[1]]then Control.error("Unexpected 'is' after '%s'!",Control.Result[i])end
Control.inject(nil,",",2,Control.Cdata.opts["^"][1])Control.split_seq(nil,2,1)Control.Event.run(2,"is",2,1)Control.Event.run("all","is",2,1)Control.Event.reg("all",function(obj,tp)if after[tp]or tp==2 and not Control.Cdata[#Control.Cdata][3]then Control.error("Unexpected '%s' after 'is'!",obj)end
return tp~=11 and 1
end)Control.inject_operator(tab,Control.Cdata.opts["^"][1])end
insert(Control.Clear,function()used=nil end)end},KS={[_init]=function(Control)local stx=[[O
|| and
&& or
@ local
$ return
]]local make_react=function(s,i,j)return function(Control)Control.Result[#Control.Result]=Control.Result[#Control.Result].." "insert(Control.Result,s.." ")Control.operator=sub(Control.operator,j+1)Control.index=Control.index+j
Control.Core(i,s)end
end
Control:load_lib"code.syntax_loader"(stx,{O=function(k,v)Control.Operators[k]=make_react(v,match(v,"^[ao]")and 2 or 4,#k)end})end},LF={[_init]=function(Control)local ct,fk=t_swap{11},"function"Control.Operators["->"]=function(Control)local s,ei,ed,cor,br=3,Control.Cdata.tb_while(ct)if match(Control.Result[ei],"^%)")then
ei=ed[2]Control.log("EI:%d - %s;%s;%s;",ei,Control.Result[ei],match(Control.Result[ei],"^[=%(,]"),ei and match(Control.Result[ei],"^[=%(,]"))cor=ei and match(Control.Result[Control.Cdata.tb_while(ct,ei-1)]or"","^[=%(,]")Control.log("COR:%s",cor)else
while ei>0 and(ed[1]==11 or ed[1]==s or s~=3 and((ed[2]or-1)==Control.Cdata.opts[","][1]and match(Control.Result[ei],"^%,")))do
ei,s=ei-1,s*(ed[1]~=11 and-1 or 1)ed=Control.Cdata[ei]end
ei,br,cor=ei+1,1,ei>0 and s~=3 and match(Control.Result[ei],"^[=%(]")end
if not cor then Control.error("Corrupted lambda arguments at line %d !",Control.line)Control.split_seq(nil,2)return end
Control.inject(ei,fk,4)if br then
Control.inject(ei+1,"(",9)Control.inject(nil,")",10,ei+1)end
if"-"==sub(Control.operator,1,1)then Control.inject(nil,"return ",4)end
Control.Event.run(2,"->",2,1)Control.Event.run("all",sub(Control.operator,1,1)..">",tp,1)Control.Level.open(fk,nil,ei)Control.split_seq(nil,2)end
Control.Operators["=>"]=Control.Operators["->"]end},NC={[_init]=function(Control)Control:load_lib"code.cssc.pdata"Control:load_lib"code.cssc.op_stack"local stx=[[O
?. ?: ?( ?{ ?[ ?" ?'
]]local phf=function()end
local b_used,a_used
local runtime_meta=setmetatable({},{__call=function()end,__newindex=function()end})local runtime_func=function(obj)return obj==nil and runtime_meta or obj end
local runtime_dual_meta={__index=function()return phf end}local runtime_dual_func=function(obj)return obj==nil and runtime_dual_meta or setmetatable({},{__index=function(self,i)return obj[i]or phf end})end
Control.Runtime.build("nilF.dual",runtime_dual_func)Control.Runtime.build("nilF.basic",runtime_func)check=t_swap{7,3,10}Control:load_lib"code.syntax_loader"(stx,{O=function(...)for k,v in pairs{...}do
Control.Operators[v]=function()local tp=sub(v,2)local i,d=Control.Cdata.tb_while(tb)if not check[d[1]]then Control.error("Unexpected '?' after '%s'!",Control.Result[i])end
Control.Event.run(2,"?x",2,1)Control.Event.run("all","?x",2,1)if tp==":"then
if not a_used then a_used=1 Control.Runtime.reg("__cssc__op_d_nc","nilF.dual")end
Control.inject_operator({{"__cssc__op_d_nc",3}},Control.Cdata.opts["."][1],false,false,true)else
if not b_used then b_used=1 Control.Runtime.reg("__cssc__op_nc","nilF.basic")end
Control.inject_operator({{"__cssc__op_nc",3}},Control.Cdata.opts["."][1],false,false,true)end
Control.split_seq(nil,1)end
end
end})insert(Control.Clear,function()b_used,a_used=nil end)end},NF={[_init]=function(Control)local e,nan="Number '%s' isn't a valid number!",-(0/0)local fin_num=function(nd,c)nd=concat(nd)local f,s,ex=match(nd,"..(%d*)%.?(%d*)(.*)")c=c=="b"and 2 or 8
f=tonumber(#f>0 and f or 0,c)if#s>0 then s=(tonumber(s,c)or nan)/c/#s else s=0 end
ex=tonumber(#ex>0 and sub(ex,2)or 0,c)nd=(f and s==s and ex)and""..(f+s)*(2^ex)or Control.error(e,nd)or nd
insert(Control.Result,nd)Control.Core(6,nd)end
insert(Control.Struct,2,function()local c=#Control.operator<1 and match(Control.word,"^0([ob])%d")if c then
local num_data,f={},{0 ..c.."%d","Pp"}if Control.get_num_prt(num_data,f)then fin_num(num_data,c)return true end
Control.Iterator()if Control.operator=="."then
num_data[#num_data+1]="."f[1]="%d"Control.get_num_prt(num_data,f)end
fin_num(num_data,c)return true
end
end)end},PC={[_init]=function(Control)local stx=[[O
? then
/| if
:| elseif
\| else
]]local make_react=function(s,i,j)return function(Control)Control.Result[#Control.Result]=Control.Result[#Control.Result].." "insert(Control.Result,s.." ")Control.operator=sub(Control.operator,j+1)Control.index=Control.index+j
Control.Core(i,s)end
end
Control:load_lib"code.syntax_loader"(stx,{O=function(k,v)Control.Operators[k]=make_react(v,4,#k)end})end},},},dq_dbg={[_init]=function(Control)local rep=string.rep
local blit_ctrl={space={colors.toBlit(colors.white)," "},[3]={colors.toBlit(colors.white)," "},[4]={colors.toBlit(colors.yellow)," "},[2]={colors.toBlit(colors.lightBlue)," "},[1]={colors.toBlit(colors.lightBlue)," "},[11]={colors.toBlit(colors.green)," "},[8]={colors.toBlit(colors.cyan)," "},[9]={colors.toBlit(colors.white)," "},[10]={colors.toBlit(colors.white)," "},[6]={colors.toBlit(colors.lime)," "},[7]={colors.toBlit(colors.red)," "},[12]={colors.toBlit(colors.pink)," "},}Control.BlitBack={}Control.BlitFront={}local burn_blit=function(tp,len)tp=blit_ctrl[tp]or{" "," "}len=len or#Control.Result[#Control.Result]Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)end
Control:load_lib"text.dual_queue.base"Control:load_lib"text.dual_queue.parcer"Control:load_lib"text.dual_queue.iterator"Control:load_lib"text.dual_queue.space_handler"local sp_h=remove(Control.Struct)insert(Control.Struct,function()local pl=#Control.Result[#Control.Result]sp_h(Control)burn_blit("space",#Control.Result[#Control.Result]-pl)end)Control.Core=function(tp)local len=#Control.Result[#Control.Result]burn_blit(tp)end
Control.Return=function()local rez,blit,back=concat(Control.Result).."\n",concat(Control.BlitFront).." ",concat(Control.BlitBack).." "rez=sub(rez,-1)=="\n"and rez or rez.."\n"gsub(rez,"()(.-()\n)",function(st,con,nd)term.blit(gsub(con,".$","\x14"),sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),sub(back,st,nd))print()end)return Control
end
insert(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)end},dq_dbg2={[_init]=function(Control)local rep=string.rep
local blit_ctrl={space={colors.toBlit(colors.white)," "},[3]={colors.toBlit(colors.white)," "},[4]={colors.toBlit(colors.yellow)," "},[2]={colors.toBlit(colors.lightBlue)," "},[1]={colors.toBlit(colors.lightBlue)," "},[11]={colors.toBlit(colors.green)," "},[8]={colors.toBlit(colors.cyan)," "},[9]={colors.toBlit(colors.white)," "},[10]={colors.toBlit(colors.white)," "},[6]={colors.toBlit(colors.lime)," "},[7]={colors.toBlit(colors.red)," "},[12]={colors.toBlit(colors.pink)," "},}Control.BlitBack={}Control.BlitFront={}local burn_blit=function(tp,len)tp=blit_ctrl[tp]or{" "," "}len=len or#Control.Result[#Control.Result]Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)end
Control:load_lib"text.dual_queue.base"Control:load_lib"text.dual_queue.parcer"Control:load_lib"text.dual_queue.iterator"Control:load_lib"text.dual_queue.space_handler"Control:load_lib"common.event"Control:load_lib"common.level"local sp_h=remove(Control.Struct)insert(Control.Struct,function()local pl=#Control.Result[#Control.Result]sp_h(Control)burn_blit("space",#Control.Result[#Control.Result]-pl)end)Control.Core=function(tp)local len=#Control.Result[#Control.Result]burn_blit(tp)Control.Event.run("temp",tp)end
Control.Return=function()local rez,blit,back=concat(Control.Result).."\n",concat(Control.BlitFront).." ",concat(Control.BlitBack).." "rez=sub(rez,-1)=="\n"and rez or rez.."\n"gsub(rez,"()(.-()\n)",function(st,con,nd)term.blit(gsub(con,".$","\x14"),sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),sub(back,st,nd))print()end)return Control
end
insert(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)end},lua={[_init]=function(Control)Control:load_lib("code.lua.base",Control.Operators,Control.Words)Control:load_lib"text.dual_queue.space_handler"Control:load_lib"code.lua.struct"end,},sys={[_modules]={dbg={[_init]=function(Ctrl,Value)local v=Value
Ctrl.Finaliser.dbg=function(x,n,m)if v=="p"then print(concat(Ctrl.Result))end
if m=="c"then
Ctrl.rt=1
return Ctrl.Result
elseif m=="s"then
Ctrl.rt=1
return concat(Ctrl.Result)end
end
end},err={[_init]=function(Ctrl)Ctrl.Finaliser.err=function()if Ctrl.err then Ctrl.rt=1 return nil,Ctrl.err end
end
end},pre={[_init]=function(Ctrl,script_id,x,name,mode,env)if not cssc_beta.preload then cssc_beta.preload={}end
local P=cssc_beta.preload
if P[script_id]then return native_load(P[script_id],name,mode,env)end
Ctrl.Finaliser.pre=function()P[script_id]=concat(Ctrl.Result)end
end},},},}end
cssc_beta={make=make,run=run,clear=clear,continue=continue,Features=Features,Modules=Modules,Configs=Confgis,dev={init=_init,modules=_modules}}_G.cssc_beta=cssc_beta
return cssc_beta