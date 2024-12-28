local Sm,SF,Ti,Tc,Tu,Gp,Ge,GS,Gs=ENV(2,3,7,8,10,13,14,18,15)local path,dt=...
local p,clr
p={path=path or"__cssc_beta__runtime",locals={},modules={},loc_names={},data=dt or GS({},{__call=function(self,...)local t={}for _,v in Gp{...}do
Ti(t,self[v]or Ge(SF("Unable to load '%s' run-time module!",v)))end
return Tu(t)end}),reg=function(l_name,m_name)if p.loc_names[l_name]then return end
p.loc_names[l_name]=1
Ti(p.locals,l_name)Ti(p.modules,"'"..m_name.."'")end,build=function(m_name,func)if(not p.data[m_name]or Control.Ge("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name))then p.data[m_name]=func end
end,is_done=false,mk_env=function(tb)tb=tb or{}if#p.locals>0 then
if tb[p.path]then Control.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,Gs(tb))end
tb[p.path]=p.data
end
return tb
end}Ti(PostRun,function()if not p.is_done and#p.locals>0 then
Ti(Result,1,"local "..Tc(p.locals,",").."="..p.path.."("..Tc(p.modules,",")..");")end
p.is_done=true
end)clr=function()p.locals={}p.modules={}p.loc_names={}p.is_done=false
end
C.Runtime=p
Ti(Clear,clr)