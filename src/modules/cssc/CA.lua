local match,insert,unpack,pairs,t_swap = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_UNPACK__,__ENV_PAIRS__,__ENV_T_SWAP__)
--C/C++ additional asignment operators
C:load_libs"code.cssc""runtime""op_stack"
local prohibited_area,bitwize_opts,skipper_tab,stx,loc_base = t_swap{"(","{","[","for","while","if","elseif","until"},{},Cdata.skip_tb,[[O
+ - * / % .. ^ ?
&& ||
]],"__cssc__bit_"
if Operators["~"] then stx=stx.."| & >> <<\n" 
    bitwize_opts=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
end--TODO: temporal solution! rework!
bitwize_opts['?']="op.qad"
Runtime.build("op.qad",function(a,b)return a~=nil and a or b end)

C:load_lib"code.syntax_loader"(stx,{O=function(...)
    for k, v, actual_op, runtime_func_name in pairs{...}do
        actual_op=({["&&"]="and",["||"]="or"})[v] or v
        runtime_func_name=v=="?" and"__cssc_op_qad"or bitwize_opts[v]and loc_base..bitwize_opts[v]
        Operators[v.."="]=function()
            if bitwize_opts[v] then Runtime.reg(runtime_func_name,(v~="?"and"bit."or"")..bitwize_opts[v])end
            local Lvl,coma_prior,cur_index,cur_data,index,last=Level[#Level],Cdata.opts[","][1],#Cdata
            if prohibited_area[Lvl.type] or #(Lvl.OP_st or"")>0 then
                C.error("Attempt to use additional asignment in prohibited area!")
            end
            --action
            Cssc.inject("=",__OPERATOR__,Cdata.opts["="][1])--insert assignment

            Text.split_seq(nil,#v+1)--clear queue

            Event.run(__OPERATOR__,v.."=",__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
            Event.run("all",v.."=",__OPERATOR__,__TRUE__)


            index,last=Cssc.op_conf(nil,coma_prior+1,false,__TRUE__,false,#Cdata-1)--add ")" to fin on, or stat end
            
            if last[1]==__OPERATOR__ and last[2]==coma_prior then --TODO: Temporal solution! Rework!
                C.error("Additional asignment do not support multiple additions in this version of __PROJECT_NAME__!")
            end
            if last[1]==__OPERATOR__ and last[2]==0 and index-1>0 and Cdata[index-1][1]==__KEYWORD__ and match(Result[index-1],"^local")then
                C.error("Attempt to perform additional asignment to local variable constructor!")
            end

            if runtime_func_name then
                Cssc.inject(runtime_func_name,__WORD__)--bit func call
                Cssc.inject("(",__OPEN_BREAKET__)--open breaket
                cur_data = #Cdata 
            end

            for k=index+1,cur_index do --insert local var copy
                Cssc.inject(Result[k],unpack(Cdata[k]))
            end

            if not runtime_func_name then --insert operator/coma
                if match(actual_op,"^[ao]")then Cssc.inject(" ",__SPACE__)end --add spaceing
                Cssc.inject(actual_op,__OPERATOR__,Cdata.opts[actual_op][1])
                Cssc.inject("(",__OPEN_BREAKET__)
                cur_data = #Cdata 
            else
                Cssc.inject(",",__OPERATOR__,coma_prior+1)--comma with higher priority --TODO: temporal solution! rework!
            end

            Lvl.OP_st[#Lvl.OP_st][3]= cur_data--correct operator start/breaket values
            Lvl.OP_st[#Lvl.OP_st][4]= cur_data

            Event.reg("all",function(obj,tp)--error check after
                if tp==__KEYWORD__ and not match(Result[#Result],"^function") or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Cdata[#Cdata][3] then C.error("Unexpected '%s' after '%s'!",obj,v.."=") end
                return not skipper_tab[tp] and __TRUE__ 
            end)
        end
    end
end})
--return __TRUE__