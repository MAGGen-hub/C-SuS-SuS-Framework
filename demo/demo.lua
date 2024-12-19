--PREPARE_REQUIRE
package.path=package.path..";../lib/?.lua" --libs directory
package.path=package.path..";../out/?.lua" --project directory


--REQUIRES
lua_mc = require"cssc_beta__lua51__original" --obtain generator
pp = require"cc.pretty".pretty_print --load my own lib for lua5.1 based on original cc.pretty
--local bitop = require("bitop")

local bitop_force_load=false
if bitop_force_load then
    local req = require 
    require = function(s,...)if s=="bit" or s=="bit32"then return nil end return req(s,...)end
end
package.preload["bitop"]=function() print("\nWARNIGN!\nBitop.lua loaded. Bitwize operators performance might be low.\n\n") return bitop end--for situations where bit/bit32 dlls not exist

--DEMO DATA
local demos = {{
name = "Демо 1: Сокращение ключевых слов.",
ctrl = "cssc.KS",
base_script = [[
    local a=1
    local b=a+1
    local c=b+1
    local d=c+1
    local e=d+1
    local f=e+1
    print(f)

    return a and b and c and d or e or not f
]],
cssc_script = [[

    @a=1
    @ b=a+1
    @ c=b+1
    @d=c+1 @e=d+1@f=e+1
    print(f)

    $a&&b&&c&&d||e||!f
]]},{
name = "Демо 2: Новые числовые форматы.",
ctrl = "cssc.NF",
base_script =[[
    print(5)
    print(-14)
    print(10)
    print(4)  --__#__
    print(10) --_#_#_
    print(17) --#___#
    print(10) --_#_#_
    print(4)  --__#__
    return 108
]],
cssc_script =[[

    print(0b101)
    print(-0o16)
    print(0b101P+1)
    print(0b00100) --__#__
    print(0b01010) --_#_#_
    print(0b10001) --#___#
    print(0b01010) --_#_#_
    print(0b00100) --__#__
    return 0o154
]]},{
name = "Демо 3: Бекпорт операторов из lua5.3. (полное копирование поведения)",
ctrl = "cssc.BO",
base_script =[[
    local idiv = function(a,b) 
        if type(a)~="number" or type(b)~="number" then 
            error("worng arg error") 
        end
        return math.floor(a/b)
    end
    local a = bit32.bor(bit32.lshift(bit32.rshift(11, 1 + 1), 1),bit32.band(bit32.rshift(4,1),1*2))
    print(a, idiv(a,2),idiv(a,3))
    local meta = setmetatable({},
        {__idiv = function(a,b) print("idiv") return 12 * b end,
        __bxor = function(a,b) print("bxor") return 12/b end})

    local meta_idiv = function(a,b) 
        meta_a = getmetatable(a)
        meta_b = getmetatable(b)
        if meta_a and meta_a.__idiv then return meta_a.__idiv(a,b) end
        if meta_b and meta_b.__idiv then return meta_b.__idiv(a,b) end
        return idiv(a,b)
    end
    local meta_bxor = function(a,b)
        meta_a = getmetatable(a)
        meta_b = getmetatable(b)
        if meta_a and meta_a.__bxor then return meta_a.__bxor(a,b) end
        if meta_b and meta_b.__bxor then return meta_b.__bxor(a,b) end
        return bit32.bxor(a,b)
    end
    return meta_idiv(meta,2), meta_bxor(meta,12)
]],
cssc_script =[[

    local a = 11 >> 1 + 1 << 1 | 4 >> 1 & 1 * 2
    print(a, a // 2, a // 3)
    local meta = setmetatable({},
        {__idiv = function(a,b) print("idiv") return 12 * b end,
        __bxor = function(a,b) print("bxor") return 12/b end})
    return meta // 2, meta ~ 12

]]},{
name = "Демо 4: Ключевое слово IS.",
ctrl = "cssc.IS",
base_script =[[
    print( type(4)   == "number")
    print( type("")  == "numbrer" or type("") = "string")
    print( type(nil) == "nil")
    print( type({})  == "boolean")
    print( type(true)== "boolean")

    local typeof = function(obj)
        local meta = getmetatable(obj)
        return meta and meta.__type or type(obj)
    end
    local cust_type_name = 'type1'
    local cust_type_obj = setmetatable({},{__type=cust_type_name})

    return typeof(cust_type_obj)

]],
cssc_script =[[

    print( 4   is "number")
    print( ""  is {"numbrer","string"})
    print( nil is "nil")
    print( {}  is "boolean")
    print(true is "boolean")
    
    local cust_type_name = 'type1'
    local cust_type_obj = setmetatable({},{__type=cust_type_name})

    return cust_type_obj is cust_type_name
]]},{
name = "Демо 5: Оператор авто проверки на nil (?) - защита от (attempt to call/index nil value).",
ctrl = "cssc.NC",
base_script =[[
    local init_obj = function(o)
        if not o then return end
        o.sub = {}
    end
    local init_sub_obj = function(o)
        if not o then return end
        if o.sub then 
            o.sub.foo = 1
            o.sub.bar = 2
        end
        o.add = function(o)
            if o and o.sub and o.sub.foo~=nil and o.sub.bar~=nil then return o.sub.foo + o.sub.bar end
            print("Warning! Object not inited!")
        end
    end

    if not init_obj or not init_sub_obj or not pp then error("Libruary not loaded!") end 

    local obj = nil
    init_obj(obj)
    init_sub_obj(obj)
    if obj and obj.add then obj.add() end
    pp(obj)

    obj = {}
    init_obj(obj)
    if obj and obj.add then obj.add() end
    pp(obj)

    obj = {}
    init_sub_obj(obj)
    if obj and obj.add then obj.add() end
    pp(obj)

    obj = {}
    init_obj(obj)
    init_sub_obj(obj)
    if obj and obj.add then obj.add() end
    pp(obj)

    return obj

]],
cssc_script =[[

    local init_obj = function(o) o?.sub = {} end
    local init_sub_obj = function(o)
        o?.sub?.foo = 1
        o?.sub?.bar = 2
        o?.add = function(o)
            local a,b = o?.sub?.foo, o?.sub?.bar 
            if a and b then return a + b end
            print("Warning! Object not inited!")
        end
    end

    local obj = nil
    init_obj?(obj)
    init_sub_obj?(obj)
    obj?.add?()
    pp?(obj)

    obj = {}
    init_obj?(obj)
    obj?.add?()
    pp?(obj)

    obj = {}
    init_sub_obj?(obj)
    obj?.add?()
    pp?(obj)

    obj = {}
    init_obj?(obj)
    init_sub_obj?(obj)
    obj?.add?()
    pp?(obj)

    return obj
]]},
{
name = "Демо 6: Лямбда функции. (=>) (->), улучшенный ';' и условия-платформы.",
ctrl = "cssc={LF,KS(sc_end,pl_cond)}",
base_script =[[
    local add = function(a,b) if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a + b end
    local mul = function(a,b) if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a * b end
    local div = function(a,b) if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a / b end
    local sub = function(a,b) if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a - b end
    
    if false then print("first")
    elseif true then print("second")
    else print("last")end
    
    return ("abc12fr34rt56yt78op90"):gsub("()(%w)",function(i,w) return w.char(w:byte()+i%3) end)
]],
cssc_script =[[

    local add = a,b => if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a + b ;
    local mul =(a,b)=> if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a * b ;
    local div =(a,b)=> if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a / b ;
    local sub = a,b => if type(a)~="number" or type(b)~="number" then error("invalid arg") end return a - b ; \;

    /|false ?print("first")
    :|true? print("second")
    \| print("last");

    return ("abc12fr34rt56yt78op90"):gsub("()(%w)",(i,w)-> w.char(w:byte()+i%3);)

]]},{
name = "Демо 7: Операторы дополненного присвоения (X=) и повторной(дополнительной) инициализации `?=`.",
ctrl = "cssc={BO,CA}",
base_script =[[
    local i = 1
    local _break
    while not _break do
        i = i + 1
        _break = _break or i>10
    end
    local obj
    --some code that may init (obj) or may not
    obj = obj or {}
    obj.foo={}
    obj.foo.bar=1
    obj["foo"].bar = bit32.lshift(obj["foo"].bar,1)
    return obj.foo.bar 
    ]],
cssc_script =[[

    local i = 1 -- << 0 -- err fix
    local _break
    while not _break do
        i += 1
        _break||=i>10
    end
    local obj
    --some code that may init (obj) or may not
    obj ?= {}
    obj.foo={}
    obj.foo.bar=1
    obj["foo"].bar<<=1
    local b = 12
    b ?= 10
    return obj.foo.bar, b
]]},{
name = "Демо 8: Стандартные аргументы и строгая типизация для аргументов функций",
ctrl = "cssc.DA",
base_script =[[
    local tab = {}
    local cust_type = setmetatable({},{__type='type1'})
    -- GDScript Godot-подобный синтаксис (поддержка кастомных типов как у IS модуля)
    local func = function(a, b, c, d, e)
        --стандартизация
        if a==nil then a="str"end
        if b==nil then b=12   end
        --if c==nil then --[=[нет стандартного аргумента]=]end
        if d==nil then d=tab  end
        if e==nil then e={}   end
        --типизация
        if type(a)~="string" then error("bad argument #1 string ecpected got "..type(a)) end
        if type(b)~="number" then error("bad argument #2 number ecpected got "..type(a)) end
        if not(type(c)=="boolean"or type(c)==""or (getmetatable(c)or{}).__type=="type1")then error("bad argument #3 boolean or number or type1 ecpected got "..type(a)) end
        print(a,b,c,d,e)
    end
    local r,e
    r,e = pcall(func)
    print("1:",e)
    r,e = pcall(func,nil,nil,true)
    print("2:",e)
    r,e = pcall(func,nil,nil,4)
    print("3:",e)
    r,e = pcall(func,46,"str",4)
    print("4:",e)
    r,e = pcall(func,"STR",56,cust_type,function()end,12)
    print("5:",e)
    return func
]],
cssc_script =[[

    local tab = {}
    local cust_type = setmetatable({},{__type='type1'})
    -- GDScript Godot-подобный синтаксис (поддержка кастомных типов как у IS модуля)
    local func = function(a : string = "str", b: number = 12, c:"boolean,number,type1", d = tab, e = {})
        print(a,b,c,d,e)
    end
    local r,e
    r,e = pcall(func)
    print("1:",e)
    r,e = pcall(func,nil,nil,true)
    print("2:",e)
    r,e = pcall(func,nil,nil,4)
    print("3:",e)
    r,e = pcall(func,46,"str",4)
    print("4:",e)
    r,e = pcall(func,"STR",56,cust_type,function()end,12)
    print("5:",e)
    return func
]]}
}
--LOCAL_VARS
local cont = "Press enter to continue...\n"
local tab = demos[tonumber(arg[1])]

local name = tab.name
local ctrl = tab.ctrl
base_script = tab.base_script
cssc_script = tab.cssc_script
final_script = ""

--DEMO
os.execute"clear"
print(name)
print("Строка контроля: '"..ctrl.."'")
comp1 = lua_mc.make(ctrl)
print("Лог загрузки:")
pp(comp1.data.log)
print(cont)
io.read()

os.execute"clear"
print(name)
print("Начальный скрипт:")
print(base_script)
print(cont)
io.read()

--os.execute"clear"
--print(name)
print("Скрипт для препроцессора:")
print(cssc_script)
print(cont)
io.read()

--os.execute"clear"
--print(name)
print("Результат работы препроцессора:")
final_script = comp1:run(cssc_script)
print(final_script)
print(cont)
io.read()

print("Вывод скрипта:")
cssc_rez,cssc_err = comp1:load("demo_func",nil,setmetatable({},{__index=_G}))
print("Ошибка при компиляции:",cssc_err)
print("Вывод print при работе demo:")
print("Результат работы скрипта:",(cssc_rez or function()end)())
pp(comp1.data.error)
--print(cont)
--io.read()