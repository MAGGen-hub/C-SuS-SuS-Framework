local Sm,Ti,Tr,Tu,Gt,Gl,Cp,GP,Ge=ENV(2,7,9,10,12,20,22,19,14)local l,O,K,L,c,M,run=C:load_libs"text.dual_queue""base""parser""iterator""space_handler"().code.lua("base",Operators,Words)"struct"()(5,-1)L("cdata",O,l,Cp)().common"event"("level",l)L=nil
c={inject=function(i,o,t,...)if"string"~=Gt(i)then Ti(Result,i,o)Cdata.reg(t,i,...)else Ti(Result,i)Cdata.reg(o,nil,t,...)end
end,eject=function(i)return{Tr(Result,i),Tu(Tr(Cdata,i))}end}C.Cssc=c
M=C:load_lib("code.lua.meta_opt",function(m,T)T=Tr(Result)c.inject("",2,m>0 and O[":"][1]or 0)Event.run(2,"",2)Event.run("all","",2)Ti(Result,T)end)C.Core=function(t,o)local P,p,s=Cdata.tb_while(Cdata.skip_tb)s=p[1]==4 and Sm(Result[P]or"","^end")and Sm(Result[p[2]]or"","^function")M(p[1],t,s)Cdata.run(o,t)Event.run(t,o,t)Event.run("all",o,t)Level.ctrl(o)end
Ti(PostRun,function()c.inject("",2,0)Event.run(2,"",2)Event.run("all","",2)Level.fin()end)User.info="C SuS SuS Compiller"User.version="4.2-beta"run,User.run=User.run
User.compile=function(...)return run(User,...)end
User.load=function(x,name,mode,env)if x==User then x=Return()elseif not Sm(x,"^\x1B\x4C")and mode~="c"then
local r r,x=GP(run,User,x)if not r then return nil,x end
end
mode=mode~="c"and mode or nil
env=Runtime and Runtime.mk_env(env)or env
return Gl(x,name,mode,env)end
return{backport_operators="BO",back_opts="BO",bitwizes="BO",additional_assignment="CA",c_like_assignment="CA",AA="CA",defautl_arguments="DA",def_args="DA",is_keyword="IS",keyword_shortcuts="KS",sort_keywords="KS",lambda_functions="LF",lambda_funcs="LF",nil_forgiving="NC",nil_checking="NC",number_formats="NF",number_concat_bug_fix="ncbf"}