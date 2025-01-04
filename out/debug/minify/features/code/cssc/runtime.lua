local Sm,SF,Ti,Tc,Tu,Gp,Ge,GS,Gs=ENV(2,3,7,8,10,13,14,18,15)local P,d,p,c=...
p={path=P or"__cssf__runtime",locals={},modules={},loc_names={},data=d or GS({},{__call=function(s,...)local t={}for _,v in Gp{...}do
Ti(t,s[v]or Ge(SF("Unable to load '%s' run-time module!",v)))end
return Tu(t)end}),reg=function(n,m)if p.loc_names[n]then return end
p.loc_names[n]=1
Ti(p.locals,n)Ti(p.modules,"'"..m.."'")end,build=function(m,f)if(not p.data[m]or C.error("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m))then
p.data[m]=f
end
end,is_done=false,mk_env=function(t)t=t or{}if#p.locals>0 then
if t[p.path]then C.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,Gs(t))end
t[p.path]=p.data
end
return t
end}Ti(PostRun,function()if not p.is_done and#p.locals>0 then
Ti(Result,1,"local "..Tc(p.locals,",").."="..p.path.."("..Tc(p.modules,",")..");")end
p.is_done=true
end)c=function()p.locals={}p.modules={}p.loc_names={}p.is_done=false
end
C.Runtime=p
Ti(Clear,c)