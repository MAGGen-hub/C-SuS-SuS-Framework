local l_opts,gsub,match,format,insert,floor,type,pairs,error,getmetatable,pcall,native_load,bit32,t_swap=
Cdata.opts,ENV(__ENV_GSUB__,__ENV_MATCH__,__ENV_FORMAT__,__ENV_INSERT__,__ENV_MATH__,__ENV_TYPE__,__ENV_PAIRS__,__ENV_ERROR__,__ENV_GETMETATABLE__,__ENV_PCALL__,__ENV_LOAD__,__ENV_BIT_LIB__,__ENV_T_SWAP__)
floor=floor.floor
--bitwize operators (lua53 - backport feature) and idiv
local make_err,func_part1,func_part2,direct = 
function(i)return function(a,b) error("attempt to perform ariphmetic on a "..(type(a)~="number" and type(a) or type(b)).." value",i)end end,
'local p,t,f,g,e={},...return function(a,b)return(',')(a,b)end'

--function(a,b) error("attempt to perform ariphmetic on a "..(type(a)~="number" and type(a) or type(b)).." value",3)end
local run_err,stx,cur_priority,un_priority,skipper_tab,bitwize_opts,check,loc_base,idiv_func=make_err(2),[[O
|
~
&
<< >>
//
]],l_opts["<"][1]+1,l_opts["#"][2],Cdata.skip_tb,
t_swap{shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'},t_swap{__OPERATOR__,__OPEN_BREAKET__,__KEYWORD__},"__cssc__bit_", --priority base, unary priority,bitw funcs
native_load(func_part1..[["number"==t(a)and"number"==t(b))and f(a/b)or((g(a)or p).__idiv or(g(b)or p).__idiv or e]]..func_part2,"OP: '//'",nil,nil)(type,floor,getmetatable,make_err(3))
--[[local p,t,f,g,e={},...return function(a,b)return("number"==t(a)and"number"==t(b))and f(a/b)or((g(a)or p).__idiv or(g(b)or p).__idiv or e)(a,b)end]]
if not bit32 then C.warn("Unable to load bitwize operators feature! Bit/Bit32 libruary not found!")return end

insert(PreRun,function() direct=t_swap(C.args)["cssc.BO.direct"]and"bitD."or"bit." end)
C:load_libs"code"
    .cssc
        "runtime"
        "op_stack"()
    "syntax_loader"(3)(stx,{O=function(...)--reg syntax
    for k,v,inject_table,has_un in pairs{...}do
        has_un=v=="~"
        k= v=="//" and l_opts["*"][1] or cur_priority --calc actual priority
        l_opts[v]=has_un and{k,un_priority}or{k}
        inject_table={{" ",__SPACE__},{loc_base..bitwize_opts[v],__WORD__}}
        
        has_un=has_un and {{loc_base.."bnot",__WORD__}}
        --local bit_name,bit_func
        --try get metatables from a and b and select function to run (probably it's better to check their type before, but the smaller the function the faster it will be)    
        --if not direct then
        
        --[[local p,t,f,g,e={},...return function(a,b)return(("number"~=t(a)or"number"~=t(b))and((g(a)or p).%s or(g(b)or p).%s or e)or f)(a,b)end]]
        --this function creates ultra fast & short pice of runtime working code
        Runtime.build("bit."..bitwize_opts[v],bit32[bitwize_opts[v]] and 
        native_load(format(func_part1..[[("number"~=t(a)or"number"~=t(b))and((g(a)or p).%s or(g(b)or p).%s or e)or f]]..func_part2,"__"..bitwize_opts[v],"__"..bitwize_opts[v],"__"..bitwize_opts[v],"__"..bitwize_opts[v])
        ,"OP: '"..v.."'",nil,nil)(type,bit32[bitwize_opts[v]],getmetatable,run_err)or idiv_func,__TRUE__)
        Runtime.build("bitD."..bitwize_opts[v],bit32[bitwize_opts[v]] or idiv_func ,__TRUE__)
        --end
        
        Operators[v]=function()--operator detected!
            local index,l_data,is_un = Cdata.tb_while(skipper_tab)
            is_un = has_un and l_data[1]==__OPERATOR__ or l_data[1]==__OPEN_BREAKET__ or l_data[1]==__KEYWORD__--is unary operator

            if not is_un and check[l_data[1]] then C.error("Unexpected '%s' after '%s'!",v,Result[index])end--error check before

            Runtime.reg(is_un and loc_base.."bnot" or loc_base..bitwize_opts[v],direct..(is_un and"bnot"or bitwize_opts[v]))
            Cssc.inject(is_un and ""or",",__OPERATOR__,not is_un and k or nil, is_un and un_priority or nil)--inject found operator Control.Cdata._opts[","][1]
            Text.split_seq(nil,#v)--remove bitwize from queue
            Event.run(__OPERATOR__,v,__OPERATOR__,__TRUE__)--send events to fin _opts in OP_st
            Event.run("all",v,__OPERATOR__,__TRUE__)

            Event.reg("all",function(obj,obj_tp)--error check after
                --if tp==__KEYWORD__ and not match(Control.Result[#Control.Result],"^function") or  tp==__CLOSE_BREAKET__ or tp==__OPERATOR__ and not Control.Cdata[#Control.Cdata][3] then Control.error("Unexpected '%s' after '%s'!",obj,v) end
                if obj_tp==__KEYWORD__ and Result[#Result]~="function" or obj_tp==__CLOSE_BREAKET__ or obj_tp==__OPERATOR__ and not Cdata[#Cdata][3] then C.error("Unexpected '%s' after '%s'!",obj,v) end
                return not skipper_tab[obj_tp] and __TRUE__ 
            end)
            --reg operator data
            Cssc.op_conf(is_un and has_un or inject_table,is_un and un_priority or k,is_un,nil,nil) --including stat_end
        end
    end
    cur_priority=cur_priority+1
end})
Runtime.build("bitD.bnot",bit32.bnot,__TRUE__)
--local func = native_load([[local p,g,f,P,e,t,_={},... return function(a)_,a=P((g(a)or p).__bnot or f,a) return _ and a or e((g(a)or p).__bnot and a or ("attempt to perform bitwise operation on a "..t(a).." value"),2) end]],"__cssc_bit_bnot",nil,nil)(getmetatable,bit32.bnot,pcall,error,type)
Runtime.build("bit.bnot",native_load(gsub(func_part1,",b","")..[["number"~=t(a)and((g(a)or p).__bnot or e)or f)(a)end]])(type,bit32.bnot,getmetatable,error),__TRUE__)
--return __TRUE__