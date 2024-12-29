local match,insert,unpack,pairs,t_swap = ENV(__ENV_MATCH__,__ENV_INSERT__,__ENV_UNPACK__,__ENV_PAIRS__,__ENV_T_SWAP__)
--C/C++ additional asignment operators
C:load_libs"code.cssc""runtime""op_stack"
local prohibited_area,bt,tb,stx,loc_base = t_swap{"(","{","[","for","while","if","elseif","until"},{},Cdata.skip_tb,[[O
+ - * / % .. ^ ?
&& ||
]],"__cssc__bit_"
if Operators["~"] then stx=stx.."| & >> <<\n" 
    bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
end--TODO: temporal solution! rework!
bt['?']="op.qad"
Runtime.build("op.qad",function(a,b)
    return a~=nil and a or b
end)

C:load_lib"code.syntax_loader"(stx,{O=function(...)
    for k, v, t,p in pairs{...}do
        t=({["&&"]="and",["||"]="or"})[v] or v
        p=v=="?" and"__cssc_op_qad"or bt[v]and loc_base..bt[v]
        Operators[v.."="]=function()
            if bt[v] then Runtime.reg(p,(v~="?"and"bit."or"")..bt[v])end
            local lvl,cur_i,cur_d,i,lst=Level[#Level],#Cdata
            if prohibited_area[lvl.type] or #(lvl.OP_st or"")>0 then
                Control.error("Attempt to use additional asignment in prohibited area!")
            end
            --action
            Cssc.inject("=",__OPERATOR__,Cdata.opts["="][1])--insert assignment

            Text.split_seq(nil,#v+1)--clear queue

            Event.run(__OPERATOR__,v.."=",__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
            Event.run("all",v.."=",__OPERATOR__,__TRUE__)


            i,lst=Cssc.op_conf(nil,Cdata.opts[","][1]+1,false,__TRUE__,false,#Cdata-1)--add ")" to fin on, or stat end
            
            if lst[1]==__OPERATOR__ and lst[2]==Cdata.opts[","][1] then --TODO: Temporal solution! Rework!
                Control.error("Additional asignment do not support multiple additions in this version of __PROJECT_NAME__!")
            end
            if lst[1]==__OPERATOR__ and lst[2]==0 and i-1>0 and Cdata[i-1][1]==__KEYWORD__ and match(Result[i-1],"^local")then
                Control.error("Attempt to perform additional asignment to local variable constructor!")
            end

            if p then
                Cssc.inject(p,__WORD__)--bit func call
                Cssc.inject("(",__OPEN_BREAKET__)--open breaket
                cur_d = #Cdata 
            end

            for k=i+1,cur_i do --insert local var copy
                Cssc.inject(Result[k],unpack(Cdata[k]))
            end

            if not p then --insert operator/coma
                if match(t,"^[ao]")then Result[#Result]=Result[#Result].." "end --add spaceing
                Cssc.inject(t,__OPERATOR__,Cdata.opts[t][1])
                Cssc.inject("(",__OPEN_BREAKET__)
                cur_d = #Cdata 
            else
                Cssc.inject(",",__OPERATOR__,Cdata.opts[","][1]+1)--comma with higher priority --TODO: temporal solution! rework!
            end

            lvl.OP_st[#lvl.OP_st][3]= cur_d--correct operator start/breaket values
            lvl.OP_st[#lvl.OP_st][4]= cur_d

            Event.reg("all",function(obj,tp)--error check after
                if tp==__KEYWORD__ and not match(Result[#Result],"^function") or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v.."=") end
                return not tb[tp] and __TRUE__ 
            end)
        end
    end
end})
--return __TRUE__