local sub,insert,pairs,setmetatable,t_swap=ENV(6,7,14,19,24)
--nil check (nil forgiving operator feature)
Control:load_lib"code.cssc.runtime"
Control:load_lib"code.cssc.op_stack"
local stx = [[O
?. ?: ?( ?{ ?[ ?" ?'
]] --all posible operators in current version
local phf=function()end

local runtime_meta=setmetatable({},{__call=function()end,__newindex=function()end})
local runtime_func=function(obj) return obj==nil and runtime_meta or obj end

local runtime_dual_meta={__index=function()return phf end}--TODO: TEMPORAL SOLUTION! REWORK!
local runtime_dual_func=function(obj) return obj==nil and runtime_dual_meta or setmetatable({},{__index=function(self,i)return obj[i] or phf end}) end
Control.Runtime.build("nilF.dual",runtime_dual_func)
Control.Runtime.build("nilF.basic",runtime_func)
local tb = Control.Cdata.skip_tb
local check=t_swap{7,3,10}

Control:load_lib"code.syntax_loader"(stx,{O=function(...)
    for k,v in pairs{...}do
        Control.Operators[v]=function() --shadow operator
            local tp = sub(v,2)
            --todo prew ":" check on calls/indexing

            local i,d=Control.Cdata.tb_while(tb)
            if not check[d[1]] then Control.error("Unexpected '?' after '%s'!",Control.Result[i])end--error check before

            Control.Event.run(2,"?x",2,1)--send events to fin opts in OP_st
            Control.Event.run("all","?x",2,1)
            if tp==":" then --dual operatiom -> index -> call
                Control.Runtime.reg("__cssc__op_d_nc","nilF.dual")
                Control.configure_operator({{" ",5},{"__cssc__op_d_nc",3}},Control.Cdata.opts["."][1],false,false,true)
            else
                Control.Runtime.reg("__cssc__op_nc","nilF.basic")
                Control.configure_operator({{" ",5},{"__cssc__op_nc",3}},Control.Cdata.opts["."][1],false,false,true)
            end
            Control.Text.split_seq(nil,1)--del "?"
        end
    end
end})
--return 1