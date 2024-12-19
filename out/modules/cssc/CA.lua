local match,insert,unpack,pairs,t_swap = ENV(2,7,10,14,24)
--C/C++ additional asignment operators
C:load_lib"code.cssc.runtime"
C:load_lib"code.cssc.op_stack"
local prohibited_area,bitw,bt,tb,stx = t_swap{"(","{","[","for","while","if","elseif","until"},{},{},Cdata.skip_tb,[[O
+ - * / % .. ^ ?
&& ||
]]
if Operators["~"] then stx=stx.."| & >> <<\n" 
    bt=t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
    bitw=t_swap{__cssc__bit_bor="|",__cssc__bit_band="&",__cssc__bit_shr=">>",__cssc__bit_shl="<<"}
end--TODO: temporal solution! rework!
bt['?']="op.qad"
bitw['?']="__cssc_op_qad"
Runtime.build("op.qad",function(a,b)
    return a~=nil and a or b
end)

C:load_lib"code.syntax_loader"(stx,{O=function(...)
    for k, v, t,p in pairs{...}do
        t=({["&&"]="and",["||"]="or"})[v] or v
        p=bitw[v]
        Operators[v.."="]=function()
            if bt[v] then Runtime.reg(p,(v~="?"and"bit."or"")..bt[v])end
            local lvl,cur_i,cur_d,i,lst=Level[#Level],#Cdata
            if prohibited_area[lvl.type] or #(lvl.OP_st or"")>0 then
                Control.error("Attempt to use additional asignment in prohibited area!")
            end
            --action
            Control.inject(nil,"=",2,Cdata.opts["="][1])--insert assignment

            Text.split_seq(nil,#v+1)--clear queue

            Event.run(2,v.."=",2,1)--send events to fin opts in OP_st
            Event.run("all",v.."=",2,1)


            i,lst=Control.configure_operator(nil,Cdata.opts[","][1]+1,false,1,false,#Cdata-1)--add ")" to fin on, or stat end
            
            if lst[1]==2 and lst[2]==Cdata.opts[","][1] then --TODO: Temporal solution! Rework!
                Control.error("Additional asignment do not support multiple additions in this version of cssc_beta!")
            end
            if lst[1]==2 and lst[2]==0 and i-1>0 and Cdata[i-1][1]==4 and match(Result[i-1],"^local")then
                Control.error("Attempt to perform additional asignment to local variable constructor!")
            end

            if p then
                Control.inject(nil,p,3)--bitw func call
                Control.inject(nil,"(",9)--open breaket
                cur_d = #Cdata 
            end

            for k=i+1,cur_i do --insert local var copy
                Control.inject(nil,Result[k],unpack(Cdata[k]))
            end

            if not p then --insert operator/coma
                if match(t,"^[ao]")then Result[#Result]=Result[#Result].." "end --add spaceing
                Control.inject(nil,t,2,Cdata.opts[t][1])
                Control.inject(nil,"(",9)
                cur_d = #Cdata 
            else
                Control.inject(nil,",",2,Cdata.opts[","][1]+1)--comma with higher priority --TODO: temporal solution! rework!
            end

            lvl.OP_st[#lvl.OP_st][3]= cur_d--correct operator start/breaket values
            lvl.OP_st[#lvl.OP_st][4]= cur_d

            Event.reg("all",function(obj,tp)--error check after
                if tp==4 and not match(Result[#Result],"^function") or  tp==10 or tp==2 and not Cdata[#Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v.."=") end
                return not tb[tp] and 1 
            end)
        end
    end
end})
--return 1