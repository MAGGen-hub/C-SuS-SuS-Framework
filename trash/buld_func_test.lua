local Libruarys={
    sys={
        modules={
        dbg={},
        err={},}
    },
    stab={modules={f={},d={},
    b={},
    c={
    modules={dd={},ff={},mm={},pp={},
    cx={modules={fg={},bb={}}}}}}}
}
local Control={Loaded={}}
local remove = table.remove
local format = string.format
local p = require"cc.pretty".pretty_print
local placeholder_func=function()end
local load_control_string
    load_control_string=function(main,sub,nxt,path)
        local prt,mod,e
        if nxt then--LOAD MODULE
            prt=remove(main,1)
            mod=nxt[prt]or{}
            path=path..prt
            Control.Loaded[path],e=pcall(function()
                if Control.Loaded[path]then return end --prevent double load
                prt=mod.modules and{}or#main>0 and main or sub or{}
                for k,v in pairs(prt)do if"table"==type(v)then prt={}break end end
                (mod.init or placeholder_func)(Control,mod,path,unpack(prt))
                --write(path)write"Args: "p(prt)
            end)
            mod=e and error(format('Error loading module "%s": %s',path,e))or mod.modules
        else
            mod=Libruarys--INIT LOADER
            sub=main
        end
        --mod={}--DEBUG! Show all modules without any rules
        if mod then  --load sub_modules
            path=path and path.."."or"@"
            if nxt and#main>0 then load_control_string(main,sub,mod,path)
            else for k,v in pairs(sub or{})do
                e=e or"string"==type(v)--set correct mode
                v=e and{v}or v
                v="number"==type(k)and{v}or{k,v}
                load_control_string(v[1],v[2],mod,path)
            end end
        end
    end


local lo = {{"sys","err"},[{"sys"}]={"dbg"},[{"stab"}]={"b","f"},[{"stab"}]={[{"c","cx"}]={{"fg"},{"bb"}},{"d"}}}

--for k,v in pairs(loaded_string)do func("number"==type(k)and{v}or{"string"==type(k) and{k}or k,v},nil,"@")end
--p(Control.Loaded)
--Control.Loaded={}

local ctrl="config=cssc,V=F.G.Y,C.A.D={E,R},G.F=D,HH.HH"
local tt=_G.func(ctrl)
p(ctrl)
p(tt)
local t,e=pcall(func,tt)
if e then print(e)end
p(Control.Loaded)
--lt= {{ "sys" },}
