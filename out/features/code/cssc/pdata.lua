local Sm,SF,Ti,Tc,Tu,Gp,Ge,GS=ENV(2,3,7,8,10,14,15,19)local path,dt=...
local p,clr
p={path=path or"__cssc_beta__runtime",locals={},modules={},data=dt or GS({},{__call=function(self,...)local t={}for _,v in Gp{...}do
Ti(t,self[v]or Ge(SF("Unable to load '%s' run-time module!",v)))end
return Tu(t)end}),reg=function(l_name,m_name)Ti(p.locals,l_name)Ti(p.modules,"'"..m_name.."'")end,build=function(m_name,func)if(not p.data[m_name]or Control.Ge("Attempt to rewrite runtime module '%s'! Choose other name or delete module first!",m_name))then p.data[m_name]=func end
end,is_done=false,mk_env=function(tb)tb=tb or{}if#p.locals>0 then
if tb[p.path]then Control.warn(" CSSC environment var '%s' already exist in '%s'. Override performed.",p.path,tb)end
tb[p.path]=p.data
end
return tb
end}Ti(Control.PostRun,function()if not p.is_done and#p.locals>0 then
Ti(Control.Result,1,"local "..Tc(p.locals,",").."="..p.path.."("..Tc(p.modules,",")..");")end
p.is_done=true
end)clr=function()p.locals={}p.modules={}p.is_done=false
end
Control.Runtime=p
Ti(Control.Clear,clr)