local Sm,Ti,Tr,Tu,Gt,Gl,Cp=ENV(2,7,9,10,12,20,22)local lvl,opt,kwrd,ll,cl=C:load_libs"text.dual_queue""base""parcer""iterator""space_handler"().code.lua("base",Operators,Words)"struct"()(5,-1)ll("cdata",opt,lvl,Cp)().common"event"("level",lvl)ll=nil
cl={inject=function(id,obj,tp,...)if"string"~=Gt(id)then Ti(Result,id,obj)Cdata.reg(tp,id,...)else Ti(Result,id)Cdata.reg(obj,nil,tp,...)end
end,eject=function(id)return{Tr(Result,id),Tu(Tr(Cdata,id))}end}C.Cssc=cl
local meta_reg=C:load_lib("code.lua.meta_opt",function(mark)local temp=Tr(Result)cl.inject("",2,mark>0 and opt[":"][1]or 0)Event.run(2,"",2)Event.run("all","",2)Ti(Result,temp)end)local tb=Cdata.skip_tb
C.Core=function(tp,obj)local id_prew,c_prew,spifc=Cdata.tb_while(tb)spifc=c_prew[1]==4 and Sm(Result[id_prew]or"","^end")and Sm(Result[c_prew[2]]or"","^function")meta_reg(c_prew[1],tp,spifc)Cdata.run(obj,tp)Event.run(tp,obj,tp)Event.run("all",obj,tp)Level.ctrl(obj)end
Ti(PostRun,function()cl.inject("",2,0)Event.run(2,"",2)Event.run("all","",2)Level.fin()end)User.info="C SuS SuS Compiller object"User.load=function(x,name,mode,env)x=x==User and Return()or x
env=Runtime and Runtime.mk_env(env)or env
return Gl(x,name,mode,env)end
return{backport_operators="BO",back_opts="BO",bitwizes="BO",additional_assignment="CA",c_like_assignment="CA",AA="CA",defautl_arguments="DA",def_args="DA",is_keyword="IS",keyword_shortcuts="KS",sort_keywords="KS",lambda_functions="LF",lambda_funcs="LF",nil_forgiving="NC",nil_checking="NC",number_formats="NF",number_concat_bug_fix="ncbf"}