--nil check (nil forgiving operator feature)
local stx,placeholder_func,sub,insert,pairs,setmetatable,t_swap=[[O
?. ?: ?( ?{ ?[ ?" ?'
]], --all posible operators in current version
function()end, --local placeholder func, using default placeholder is not a variant!
ENV(__ENV_SUB__,__ENV_INSERT__,__ENV_PAIRS__,__ENV_SETMETATABLE__,__ENV_T_SWAP__)

local runtime_meta,runtime_dual_meta,check=setmetatable({},{__call=function()end,__newindex=function()end}),
{__index=function()return placeholder_func end},--TODO: TEMPORAL SOLUTION! REWORK!
t_swap{__STRING__,__WORD__,__CLOSE_BREAKET__}

local runtime_func,runtime_dual_func=function(obj) return obj==nil and runtime_meta or obj end,
function(obj) return obj==nil and runtime_dual_meta or setmetatable({},{__index=function(s,i)return obj[i] or placeholder_func end}) end

C:load_libs"code".cssc"runtime""op_stack"()"syntax_loader"(3)(stx,{O=function(...)
    for k,v in pairs{...}do
        Operators[v]=function() --shadow operator
            local t,i,d = sub(v,2)
            --todo prew ":" check on calls/indexing

            i,d=Cdata.tb_while(Cdata.skip_tb)
            if not check[d[1]] then C.error("Unexpected '?' after '%s'!",Result[i])end--error check before

            Event.run(__OPERATOR__,"?x",__OPERATOR__,__TRUE__)--send events to fin opts in OP_st
            Event.run("all","?x",__OPERATOR__,__TRUE__)
            if t==":" then --dual operatiom -> index -> call
                Runtime.reg("__cssc__op_d_nc","nilF.dual")
                Cssc.op_conf({{" ",__SPACE__},{"__cssc__op_d_nc",__WORD__}},Cdata.opts["."][1],false,false,true)
            else
                Runtime.reg("__cssc__op_nc","nilF.basic")
                Cssc.op_conf({{" ",__SPACE__},{"__cssc__op_nc",__WORD__}},Cdata.opts["."][1],false,false,true)
            end
            Text.split_seq(nil,1)--del "?"
        end
    end
end})
Runtime.build("nilF.dual",runtime_dual_func)
Runtime.build("nilF.basic",runtime_func)
--return __TRUE__