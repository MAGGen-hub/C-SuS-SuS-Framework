-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.

-- string.lib
local gmatch = string.gmatch
local match = string.match
local find = string.find
local gsub = string.gsub
local sub = string.sub

-- table.lib
local insert = table.insert
local concat = table.concat
local remove = table.remove
local unpack = table.unpack or unpack --depends on Lua version

-- math.lib
local floor = math.floor

-- generic.lib
local type = type
local pairs = pairs
local error = error
local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring = tostring
local bit32 = bit32
if not bit32 then
    bit32=require "bit32" -- This will return an error if bit32 is not loaded
end

-- PROTECTION LAYER END

-- BASE VARIABLES
local placeholder_func = function()end
local native_load = load    -- native load function from curent Lua environment
local Features = {}
local __PROJECT_NAME__ = {} -- _ _PROJECT_NAME_ _ will be replaced by "lua-mc" or "cssc" depending on project version

-- string with all Lua5.1 keywords
local keywords_string = "if function for while repeat elseif else do then end until local return in break "
local keywords_base = {}
local keywords_ids = {}
gsub(keywords_string,"(%S+)( )", --fill tables with values
    function(word,space)
        keywords_base[#keywords_base+1] = space..word..space
        keywords_ids[word] = #keywords_base
    end)

-- BASE VERIABLES END


-- PREPROCESSOR BASE MODULE
__PROJECT_NAME__.load = function (x,name,mode,env)
    if type(x)=="string" then -- x might be a function or a string
        local control_string=match(x,"^<.->") or match(x,"^#!.-\n?<.->") -- locate control string
        if control_string then --control string exists!
        
            --INITIALISE LOCALS
            local previous_operator,Result,Operator,Control,string_mode,temp,a,b,l,e="",{""},{['"']=placeholder_func ,["\0"]= function (Ctrl) local r=Ctrl.Result r[#r]=r[#r].." "..(remove(Ctrl.comments,1) or "") end ,['..']='..',['...']='...'} -- " - for strings \0 - for comments
            x=sub(x,#control_string+1) --remove control string to start parsing
            Control={Operator=Operator,Core=placeholder_func ,Result=Result,Finaliser={},comments={},line=1,previous_value=1} -- initialise control tablet for special functions call
                 --S -> the core module (empty by default)
            --INITIALIZE COMPILLER
            for K,V in gmatch(control_string,"([%w_]+)%(?([%w_. ]*)")do--load flags that used in control string: K - feature name V - feature argument
                if Features[K] then -- feature exist
                    for k,v in pairs(Features[K])do Operator[k]=v end
                    l=Features[K][1] and Features[K][1](Control,V,x,name,mode,env)-- [1] index is used to store special compiller directives
                    if l then  return l end --PRELOAD CHECK
                end                                          -- if special has argumet V ex: "<pre(V)>" then F["pre"][1](ctrl_table,"V")
            end
            Operator[1]=nil -- remove trash from current_operators table (all specials in S table now)
            
            --COMPILE -- o: operator, w: word
            l=#x+1
            for operator,word,index in gmatch(x,"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%[-`{-~\\-_%s]*[^\n%S]*)()")do
                                        -- see that pattern? Now try to spell it in one breath! =P
                --LINE COUNTER          -- in this pattern the word (w) will never be "^%s*$"!
                gsub(operator,"\n", function() Control.line=Control.line+1 end )
                --STRING MODE: string or comment located and must be captured
                if string_mode then
                    a,b,e=find(operator,#string_mode<2 and "(\\*[\n"..string_mode.."])%s*" or "(%]=*%])%s*") --locate posible end of string (depends on string type)
                    if a and (#string_mode<2 and (string_mode=="\n" or #e%2>0) or #string_mode==#e) or index==l then -- end of something found, check is it our string end or not
                        b=b or index
                        temp=temp..sub(operator,0,b) --finish string
                        if control_string then 
                            control_string=Control.comments
                        else 
                            temp=Control.Core(nil,temp,index)or temp --CORE module
                            control_string=Result
                        end
                        control_string[#control_string+1]=temp -- insert object
                        operator=previous_operator..sub(operator,b+1) --form new operators sequence
                        string_mode,temp=nil --disable string mode
                    else
                        temp=temp..operator..word --continue string
                    end
                end
                
                --DEFAULT MODE: main compiler part
                if  not string_mode then
                    --STRING LOCATOR
                    operator=gsub(operator,"-%-%s-\n","\n")--remove all empty comments (they may corrupt a lot of things!)
                    control_string=match(operator,"-%-%[?=*%[?") --if start found: init str_mode
                    string_mode=match(operator,"%[=*%[")or match(operator,"['\"]")
                    if control_string or string_mode then
                        a=find(operator,control_string or string_mode,1,1)
                        string_mode=control_string and (sub(control_string,3)==string_mode and string_mode or "\n") or string_mode --(string/long_string/long_comment) or small_comment
                        temp,word=sub(operator,a)..word,"" -- save temp string and errase word
                        operator=sub(operator,0,a-1)..(control_string and "\0" or '"') -- correct opeartor seq add control character
                        previous_operator=control_string and (operator or "") or "" -- set previous operator
                    end
                    --IF NOT COMMENT
                    if not control_string or index==l then
                        --OPERATOR PARCE: Default parcer and custom functions launcher
                        while #operator>0 do
                            a=match(operator,"^%s*") --this code was made to decrase the length of result table and allow spacing in operators capture section
                            Result[#Result]=Result[#Result]..a
                            operator=sub(operator,#a+1)
                            for j=3,1,-1 do --WARNING! Max operator length: 3    
                                a=sub(operator,1,j)  -- a variable here used to store enabled_operators[posible operator]
                                b=Operator[a] or j<2 and a
                                if b and #operator>0 then --if O[posible_operator] -> C SuS SuS enabled operator (or something else) found and must be parced
                                    b=Control.Core(a,b,index) or b -- CORE module call
                                    if 7>#type(b) then --type<7 -> string; >7 - function | these can't be any othere values
                                        Result[#Result+1]=b --string located
                                        operator=sub(operator,j+1)
                                    else
                                        b={b(Control,operator,word,index)} --if there is a special replacement function
                                        operator,word=b[1] or sub(operator,j+1),b[2] or word
                                    end
                                    break -- operator found! break out...
                                end
                            end
                        end
                        --WORD
                        if #word>0 then
                            word=Control.Core(nil,word,index) or word --CORE module call
                            Result[#Result+1]=word
                        end
                    end
                end 
            end
            
            --FINISH COMPILE
            for k,v in pairs(Control.Finaliser)do
                local a,n,m,e=v(x,name,mode,env)--launch all finalizer function
                if Control.rt then  return a,n end -- if finaliser return something then return it vithout calling native load
                x=a or x
                name=n or name
                mode=m or mode
                env=e or env
            end
            x=concat(Result)
            if mode=="c" then  return Result end 
        end
    end
    return native_load(x,name,mode,env)
end

-- FEATURES of (C SuS SuS Language)
Features.PC = {
    ["/|"]=keywords_base[1],--if
    ["?"]=keywords_base[9],--then
    [":|"]=keywords_base[6],--elseif
    ["\\|"]=keywords_base[7]}--else
Features.platform_condition = Features.PC

Features.KS = {
    ["@"]=keywords_base[12],--local
    ["$"]=keywords_base[13],--return
    ["||"]=" or ",--or
    ["&&"]=" and ",--and
    ["!"]=" not ",--not
    [";"]=keywords_base[10]}--end
Features.keywords_shortcuts = Features.KS

Features.LF = {
    ["->"]= function (Ctrl,operator) --DO NOT PLACE LAMBDA AT THE START OF FILE!!! You will got ")" instead of "function(*args*)"
        local i,a,e,p=#Ctrl.Result,1
        e=Ctrl.Result[i]
        p=find(e,"^%)%s*") and "" or "("
        while i>0 and (#p>0 and (a and (match(e,"[%w_]+") or "..."==e) or ","==e) or #p<1 and  not find(e,"^%(%s*"))do --comma or word or ( if ) located
            i,a=i-1,not a
            e=Ctrl.Result[i] end
        insert(Ctrl.Result,#p<1 and i or i+1,keywords_base[2]..p)-- K[2] - function keyword K[13] - return
        Ctrl.Result[#Ctrl.Result+1]=(#p>0 and ")" or "")..(sub(operator,1,1)=="-" and keywords_base[13] or "") --WARNING!!! Thanks for your attention! =)
        if Ctrl.Level then --core exist
            Ctrl.previous_value=2 -- Lua5.3 operators compatability patch (and for some future things)
            Ctrl.Core.Level_ctrl("function",1)
        end
    end
}
Features.LF["=>"]=Features.LF["->"]
Features.lambda_functions = Features.LF


-- DEBUG REQUIRED

Features.KS[';']= function (Ctrl,operator,word)  -- any ";" that stand near ";,)]" or "\n" will be replaced by " end " for ex ";;" equal to " end  end "
     local a,p=match(operator,"(;*) *([%S\n]?)%s*")
     
     if #p>0 and p~="(" or #a>1 then 
        for i=1,#a do
            Ctrl.Result[#Ctrl.Result+1]=keywords_base[10]
            if Ctrl.Level then Ctrl.Core.Level_ctrl("end") end  --keywords_base[10]=" end "
        end
     else Ctrl.Result[#Ctrl.Result+1]=";" end 
     return sub(operator,#a+1)
end 
    
 --OBJ: object separator function
OBJ= function (operator) return type(operator)=='string' and match(operator,"%S+") or "" end 

---WARNING REMOVE
--[===[
do --CSSC Environmet table (CC:T-f)
local o=setmetatable({},{__index=os})
clone= function (value,arg)
     local D,v,a=debug,value,arg or {}
     local t=type(v)
     if t=="function" then 
         local I=D.getinfo(v)
         local f=NL(t.dump(v),I.source,nil,a.env or getfenv(v))
        for i=1,I.nups do
             if a.ref then D.upvaluejoin(f,i,v,i)
             else  local n,d=D.getupvalue(v,i)D.setupvalue(f,i,d) end 
                      end  return f
     elseif t=="table" then 
        t={}for k,v in pairs(v)do t[k]=v end 
         return setmetatable(t,a.meta or getmetatable(v)) end  end 
 local m={__index=_G}
env={os=o,
     clone=clone,
     load=L,
     loadfile=clone(loadfile,{env=setmetatable({load=L},m)}),
     include= function (name,force)
          local e=getfenv(2)
          local r=e.require
          if  not r then error("Unable to include '"..name.."', _ENV has no require function!",2) end 
          local f,t=pcall(r,name)
          if  not f then error(t,2) end 
         for k,v in pairs(t)do
             e[k]= not force and e[k] or v
                           end  return t end }

 local e={env=setmetatable({loadfile=env.loadfile},m)}
o.run=clone(os.run,e)
o.loadAPI=clone(os.loadAPI,e)
end
-- ]===]--
---WARNING REMOVE

 --Error detector
err= function (Ctrl,err_msg)
    Ctrl.err=Ctrl.err or "SuS["..Ctrl.line.."]:"..err_msg
end
Features.err={ function (Ctrl)
    Ctrl.Finaliser.err= function ()
         if Ctrl.err then Ctrl.rt=1 return  nil,Ctrl.err end
    end 
end }

 --Preload feature
Features.pre={ function (Ctrl,script_id,x,name,mode,env)
     if  not __PROJECT_NAME__.preload then __PROJECT_NAME__.preload={} end 
     local P=__PROJECT_NAME__.preload
     if P[script_id] then return native_load(P[script_id],name,mode,env) end 
     Ctrl.Finaliser.pre= function ()
         P[script_id]=concat(Ctrl.Result) 
     end
end }

 --Debug feature (old debug will be removed in final version)
Features.dbg={ function (Ctrl,Value) -- V - argument
    local v=Value
    Ctrl.Finaliser.dbg= function (x,n,m)
       --if v=="P" then require"cc.pretty".pretty_print(Ctrl.Result)
         if v=="p" then print(concat(Ctrl.Result)) end
         if m=="c" then
             Ctrl.rt=1
             return Ctrl.Result
         elseif m=="s" then
             Ctrl.rt=1
             return concat(Ctrl.Result)
         end 
    end 
end }

 --0b0000000 and 0o0000.000 number format support (avaliable exponenta: E+-x)
Features.NF={ function (Ctrl) --return function that will be inserted in special extensions table
    Features.CSSC_Core[1](Ctrl)
    Ctrl.Core.Word_event_reactors.before= function (operator,word)
        local a,b,c,r,t=match(word,"^0([bo])(%d*)([eE]?.*)")  --RUSH EEEEEEEEEEEEE for exponenta
        if Ctrl.floating_point and Ctrl.Result[#Ctrl.Result]=="." then
            t,b,c=Ctrl.floating_point,match(word,"(%d+)([eE]?.*)") --b located! posible floating point!
        else
            Ctrl.floating_point=nil
        end 
        if b then  --number exist
          t,r=t or (a>"b" and "8" or "2"),0 --You are a good person if you read this (^_^)
          for i,k in gmatch(b,"()(.)") do
             if k>=t then err(Ctrl,"This is not a valid number: 0"..a..b..c) end  --if number is weird
             r=r+k*t^(#b-i) -- t: number base system, r - result, i - current position in number string
          end
          r=Ctrl.floating_point and sub(tostring(r/t^#b),3) or r --this is a floating point! recalculate required!
          Ctrl.floating_point= not Ctrl.floating_point and #c<1 and t or nil --floating point support
          return r..c
        end
    end
end }
Features.number_formats = Features.NF


 --This function works as #include directive in C++
 --include"module" inserts all module values to _ENV (_ENV must have 'require' inside it!)
do
 -- Add path
 --local N=fs.combine
 --adp= function (str,full)cssc.path=full and cssc.path..N(str,"?;")..N(str,"?.lua;")..N(str,"?/init.lua;")or cssc.path..str..";" end 

--ATP: Attempt to perform
ATP= function (Ctrl,wt,on)err(Ctrl,"Attempt to perform '"..wt.."' on '"..on.."'!") end 

 --C SuS SuS LANGUAGE CORE
Features.CSSC_Core={ function (Ctrl)
    if Ctrl.Core_Loaded then  return  end 
    Ctrl.Core_Loaded=1 --mark & skip
    Ctrl.Level={{start_of_object=1,type_of_lvl="main"},on_lvl_open={},on_lvl_close={}} --leveling table [o -> on lvl open, c -> on lvl close]
    local l=Ctrl.Level
    local r=Ctrl.Result
     --add uncatched operators
    for k in gmatch ("=~<>",".")do k=k..'='Ctrl.Operator[k]=k end
     --EVENT invocator
    local event_invocator =function(Events,operator,word,index)for k,v in pairs(Events)do word=v(operator,word,index)or word end  return word end 
     --table print f
    local print_tab= function (Tab) local r=""for k in pairs(Tab)do r=r..k.."' or '"end return sub(r,1,-7) end 
     --CORE table
    Ctrl.Core={Word_event_reactors={},Operator_event_reactors={},All_event_reactors={},Keyword_event_reactors={},operator={['and']=1,['or']=1,['not']=1},  -- o for operators
     --LEVELING controller
        level_ends={["for"]="do",["while"]="do",["repeat"]="until",["if"]="then",["then"]={["else"]=1,["elseif"]=1,["end"]=1},["elseif"]="then",["else"]="end",["do"]="end",["function"]="end",["{"]="}",["("]=")",["["]="]"}, --level ends table (then has no end because it can has multiple ones)
        Level_ctrl= function (operator,val)
            if val then
                l[#l+1]=event_invocator(l.on_lvl_open,operator,{type_of_lvl=operator})      -- level+
            else 
                local cur_end=Ctrl.Core.level_ends[l[#l].type_of_lvl]             -- level-
                local t=#type(cur_end)==5 -- is table?
                if  not t and cur_end and cur_end~=operator or t and  not cur_end[operator] then 
                    err(Ctrl,"Expected '"..(t and print_table(cur_end) or cur_end).."' after '"..l[#l].type_of_lvl.."' but got '"..operator.."'!") 
                end  --level error detection
                if #l<2 then err(Ctrl,"Unexpected '"..operator.."'!") end 
                local cl=l[#l]
                l[#l]=#l<2 and l[#l] or nil
                event_invocator(l.on_lvl_close,operator,cl)
            end 
        end } -- level-      ||Core_Table_END
    local c=Ctrl.Core
    Ctrl.Finaliser[1]= function (x,n,m,e)
         if #l>1 then err(Ctrl,"Unclosed construction! Missing '"..(c.level_ends[l[#l].type_of_lvl] or "end").."'!"..#l) end 
         --local p=e and e.package  --CC:T require 
         --if p then p.path=p.path..cssc.path --if package.path exist then add additional path
         --   setfenv(p.loaders[2],setmetatable({loadfile=env.loadfile},{_index=_G}))
         --   for k,v in pairs(env)do e[k]=rawget(e,k) or v end end  
    end 
    
     --CORE function
    setmetatable(Ctrl.Core,{__call= function (S,operator,word,index)
        if operator=='"' or operator=='\0' then  return  end  --skip string markers and comments
        Ctrl.previous_value=Ctrl.current_value  -- set previous value
        Ctrl.current_value=nil
         if #type(word)==6 then 
             local ow=OBJ(word)
             local k=keywords_ids[ow] --get keyword id if keyword
             if k then Ctrl.current_value=1 --KEYWORD
                 --keywords leveling part
                 if k>5 and k<12 then c.Level_ctrl(ow) end  --end  level
                 if k<10 then c.Level_ctrl(ow,1) end     --open level
                 word=event_invocator(c.Keyword_event_reactors,operator,word,index) or word
             elseif c.operator[ow] then 
                 Ctrl.curent_value=2 
                 word=event_invocator(c.Operator_event_reactors,operator,word,index) or word 
             end  
         end     --OPERATOR (and or not)
         if  not Ctrl.current_value then 
             if  not operator then 
                 Ctrl.current_value=find(word,"^['\"%[]") and 6 or 3 word=event_invocator(c.Word_event_reactors,operator,word,index) or word                        --KEYWORD(1)  WORD(3)         STRING(6)
             else Ctrl.current_value=find(operator,"^[%[%({]") and 4 or find(operator,"^[%]%)}]") and 5 or 2
                 if Ctrl.current_value==4 then c.Level_ctrl(operator,1) end   --breaket+
                 if Ctrl.current_value==5 then c.Level_ctrl(operator) end     --breaket-
                 word=event_invocator(c.Operator_event_reactors,operator,word,index) or word 
             end  
         end    --OPERATOR(2) BREAKET_OPEN(4) BREAKET_CLOSE(5)
         word=event_invocator(c.All_event_reactors,operator,word,index) or word --ALL
         return word 
     end }) --CORE Function End
    
     --START SEARCHER
     --@lb=->OBJ(r[#r]):find"^ ?[%]%)}\"']";
    l.on_lvl_open[#l.on_lvl_open+1]= function (operator,level_table) --on level open
         local s=#r+1
         if Ctrl.previous_value and Ctrl.previous_value<3 then l[#l].start_of_object=s end  --previous level
        level_table.start_of_object=s+1
    end  --next level table
    c.Word_event_reactors.st= function (o,w)
         local p=OBJ(r[#r])
         if find(p,"[.:]") and #p<2 then  return  end  --default start searcher allowed operators
         if Ctrl.current_value==6 and Ctrl.previous_value>2 then  return  end  --current word is string and previous word was an operator or keyword
         l[#l].start_of_object=#r+1 
    end 
    end }
end

 --UE:Unexpected value
UE= function (Ctrl,operator)err(Ctrl,"Unexpected '"..operator.."'!") end 

 -- Default function arguments feature
Features.DA={ function (Ctrl)
    Features.CSSC_Core[1](Ctrl)
    local l=Ctrl.Level
    local r=Ctrl.Result
    
    l.on_lvl_open[#l.on_lvl_open+1]= function (o,lvl_tab)
         if lvl_tab.type_of_lvl=="function" then lvl_tab.ada=1 end  -- allow_default_args for nex level
         if l[#l].ada then
            l[#l].ada=nil
            if lvl_tab.type_of_lvl=="(" then lvl_tab.da={} end  
         end 
    end 
    
    l.on_lvl_close[#l.on_lvl_close+1]= function (o,lvl_tab) --on level close
        l[#l].ada=nil
        if lvl_tab.da and #lvl_tab.da>0 and lvl_tab.type_of_lvl=="(" then   -- da - default_args
            r[#r+1]=")"
            lvl_tab.da[#lvl_tab.da].nd=lvl_tab.da[#lvl_tab.da].nd or #r-1  --set last index if not exist
             --remove default statements and finalise default args
            for i=#lvl_tab.da,1,-1 do
             --print("A",r[lvl_tab.da[i].st],lvl_tab.da[i].nd,#r,lvl_tab.type_of_lvl)
                local ob=r[lvl_tab.da[i].st-1]
                r[#r+1]="if "..ob.."==nil then "..ob.."=" --insert start
                for j=lvl_tab.da[i].st,lvl_tab.da[i].nd do r[#r+1]=r[j]end --insert obj
                r[#r+1]=" end " --insert end
                for j=lvl_tab.da[i].nd,lvl_tab.da[i].st,-1 do remove(r,j)end --remove default arg
            end
            lvl_tab.da=nil
            Ctrl.Core.All_event_reactors.da= function () Ctrl.Core.All_event_reactors.da=nil return placeholder_func end  
        end --
    end     --this part is required to switch off the ')' insertion (because we already inserted one)
    
    Ctrl.Core.Operator_event_reactors.da= function (operator)  --catch coma and ';' (word arg disabled)
        local d=l[#l].da
        if d and operator==';' then UE(Ctrl,';') end 
        if d and #d>0 and operator==',' then 
            d[#d].nd=d[#d].nd or #r 
        end  
    end 
    
    Ctrl.Operator[":="]= function (Ctrl) -- operator and word args disabled
         if  not l[#l].da then UE(Ctrl,':=') --emit an error
         else
             local d=l[#l].da
             d[#d+1]={st=#r+1}
         end 
    end 
end }
Features.default_arguments = Features.DA

 --Prohibited area check
PAch= function (t) return find(t,"[{(%[]") or t=="if" or t=="elseif" or t=="for" or t=="while" end 


 -- Nil forgiving operators feature
do
local c,d=setmetatable --nil returning object | nilF feature: nil forgiving operators | d -> default c-> colon
d=c({},{__call= function () return nil end ,__index= function () return nil end }) --TODO: Try replace with place holder function
c=c({},{__index= function () return  function () return nil end  end })

NIL_Forgive= function (o,i) -- o -> object, i -> index
     if o==nil then  return i and c or d end  --> obj not exist (false and other variables are allowed)
     if i then  return o[i] and o or c end  --> obj and index exist -> colon mode
     return o 
end  -- obj exist but not index

Features.N={ function (Ctrl)
    Features.CSSC_Core[1](Ctrl)
    Ctrl.Core.Operator_event_reactors.N= function (o) 
        if Features.N[o] then 
            Ctrl.current_value=Ctrl.previous_value
        end
    end
end } --mark F.N operators as start searcher allowed (core-invisible)
Features.nil_forgiving = Features.N

for v,k in gmatch('.:"({',"()(.)")do
    Features.N['?'..k]= function (Ctrl,operator,word)
        local r=Ctrl.Result
        if #r<2 or Ctrl.previous_value<3 then ATP(Ctrl,k,r[#r]) end  --previous value was a keyword or operator
        if find(sub(operator,3),"[^\0%s]") then ATP(Ctrl,OBJ(sub(operator,3)),k) end 
        insert(r,Ctrl.Level[#Ctrl.Level].start_of_object," __PROJECT_NAME__.nilF(") --first part
        r[#r+1]=v==2 and ",'"..word.."')" or ')'
        if v==1 then  --no error and index detected
            Ctrl.ci=#r --index of ? 
            Ctrl.pc=#r+2 -- index of word
            Ctrl.Core.All_event_reactors.str= function (operator)
                if Ctrl.pc<=#r then  
                    --print(Ctrl.current_value,word,r[#r],r[#r-1],r[#r-2],#r,operator)
                    if Ctrl.current_value>5 or Ctrl.current_value>3 and  not find(operator,'^[)%]}]') then 
                        insert(r,Ctrl.ci,",'"..word.."'") 
                    end 
                    Ctrl.Core.All_event_reactors.str=nil
                end
            end
        end 
        return sub(operator,2)
    end 
end

end

 -- X= operators feature.
 --WARNING! They don't support multiple asignemnt (a,b X= *code*) - is prohibited!

 --Add initialiser function to F.K feature to enable support of &&= and ||= 
Features.KS[1]= function (Ctrl)
    Ctrl.EQ={"&&","||",unpack(Ctrl.EQ or {})} 
end 
 -- ?= function
local qeq= function (b,a)  --b - base, a - adition
    if a==nil then return b
    else return a end
end 
Features.CA={ function (Ctrl)
    Features.CSSC_Core[1](Ctrl) --load start searcher
     --EQ - table with operators that support *op*= behaviour
    Ctrl.EQ={"+","-","*","%","/","..","^","?",unpack(Ctrl.EQ or {})}
    local l=Ctrl.Level
    local r=Ctrl.Result
    Ctrl.Core.All_event_reactors.br= function (operator,word)
        if l[#l].br and (Ctrl.previous_value==3 or Ctrl.previous_value>4) and (Ctrl.current_value==1 or Ctrl.current_value==3 or (operator==',' or operator==';')) then   --breaket request located and end of block located
            l[#l].br=nil
            r[#r+1]=")" 
        end
    end
    l.on_lvl_close[#l.on_lvl_close+1]= function (o,lvl_tab) if lvl_tab.br then r[#r+1]=")" end  end   -- on level end
    Ctrl.Finaliser.c= function () if l[#l].br then r[#r+1]=")" end  end 
     --operator main parce function
    local op= function (Ctrl,operator,word)
        local lt=l[#l].type_of_lvl
        if PAch(lt) then err(Ctrl,"Attempt to use X= operator in prohibited area! '"..lt.." *var* X= *val* "..Ctrl.Core.level_ends[lt].."'") end 
        if OBJ(r[l[#l].start_of_object-1] or "")=="," then err(Ctrl,"Comma detected! X= operators has no multiple assignments support!") end 
        if #r<2 or Ctrl.previous_value<3 then ATP(Ctrl,k,r[#r]) end 
        operator=match(operator,"(.-)=") --for this we need only the first part of operator
        r[#r+1]="="..(operator=="?" and "__PROJECT_NAME__.q_eq(" or "") --insert equality or ?=
        l[#l].m={bor=#r+1}  --Lua5.3 feature support
        for i=l[#l].start_of_object,#r-1 do r[#r+1]=r[i]end  --copy variable from the start of an object
        local t=#type(Ctrl.Operator[operator])
        if operator=="?" then r[#r+1]=","
        elseif t==6 then r[#r+1]=Ctrl.Operator[operator] --string
        elseif t==3 then r[#r+1]=operator --operator
        else Ctrl.Operator[operator](Ctrl,operator,word) 
        end  --function
        --print(C,o,w)
        if operator~="?" then r[#r+1]="(" end   --add opening breaket
        l[#l].br=1   --request closing breaet for this level
        l[#l].m={bor=#r+1} 
    end   --Lua5.3 feature support
     -- main function initialiser        
    for i=1,#Ctrl.EQ do Ctrl.Operator[Ctrl.EQ[i].."=" ]=op end
end  --END OF Features.CA
}
Features.C_assignment_addition=Features.CA

 --IS keyword simular to typeof()
local tof= function (o) return (getmetatable(o) or {}).__type or type(o) end 
local is=setmetatable({},{__concat= function (v,a) return setmetatable({a}, --is inited
    {__concat= function (v,a)  --a args v value
        if type(a[1])=="table" then a=a[1] end 
        for i=1,#a do
            if tof(v)==a[i] then  return true end 
        end
        return false 
    end }) 
end })
_G.typeof=tof --include typeof into global environment

Features.IS={ function (Ctrl)
    Features.CSSC_Core[1](Ctrl) 
    Ctrl.Core.operator['is']=1 --add new "word" operator
    local l=Ctrl.Level
    Ctrl.Core.Operator_event_reactors[1]= function (operator,word)
        word=OBJ(word)
        if word=='is' then 
            if #Ctrl.Result<2 or Ctrl.previous_value<3 then ATP(Ctrl,'is',Ctrl.Result[#Ctrl.Result]) end 
            return " ..__PROJECT_NAME__.is.. " 
        end
    end 
end }


--Lua5.3 operators feature! Bitwise and idiv operators support!
do
local B={}
for k,v in pairs(bit32)do B[k]=v end
B.idiv= function (a,b) return floor(a/b) end 
B.shl=B.lshift
B.shr=B.rshift

local bt={shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
local kp={} gsub('and or , = ; > < >= <= ~= == ',"%S+", function (x)kp[x]=1 end )  -- all operators that has lower priority than bitise operators
local f= function (t,m) return "Attempt to perform "..t.." bitwise operation on a "..m.." value" end

--Lua5.3 operation functions
M={bnot=setmetatable({},{
    __pow= function (a,b)
         local m=(getmetatable(b) or {}).bnot
         if m then  return m(b) end 
         m=type(b)
         if m~='number' then error(f('bitwise',m),3) end 
         return B.bnot(b)
    end })}

for k,v in pairs(bt)do
    local n='__'..k  --name of metamethod
    local t='number' --number value type
    local e=v=='//' and 'idiv' or 'bitwise'
    local f= function (a,b) --base calculation function
        local m=(getmetatable(a[1]) or {})[n] or (getmetatable(b) or {})[n]
        if m then  return m(a,b) end  --metamethod located! Calculation override!
        m=type(a[1])
        m=m==t and type(b) or m
        if m~=t then error(f(e,m),3) end 
        return B[k](a[1],b)
    end 
    M[k]=v=='//' and {__div=f} or {__concat=f}
end

Features.M={ function (Ctrl)
    Ctrl.EQ={">>","<<","&","|",unpack(Ctrl.EQ or {})} --additional equality
    Features.CSSC_Core[1](Ctrl) --enable core
    local l=Ctrl.Level
    local r=Ctrl.Result
    l[#l].m={bor=1}
     --on level open
    l.on_lvl_open[#l.on_lvl_open+1]= function (o,lvl_tab)
        if o=="function" and Ctrl.previous_value==2 then l[#l].m.sk=1 end  -- curent value is function keyword and previous value was an operator -> mark function end on skip
        lvl_tab.m={bor=#r+2} 
    end 
     --function to correct priority of sequence (set on O and on W)
    Ctrl.Core.All_event_reactors.pc= function (operator,word)
        local i=#r+2
        local b=Ctrl.current_value<2 and  not l[#l].m.sk or operator and kp[operator] --current value is equal to keyword or operator and has lower priority than bitwises
        l[#l].m.sk=nil --reset end skip
        if b then l[#l].m={bor=i} end  --reset the starter table
        if b or operator and find(" .. + -",' '..operator..' ',1,1) then l[#l].m.idiv=i end 
    end  --start of sequence and reset!
    
    for k,v in pairs(bt)do
        Ctrl.Operator[v]= function (Ctrl,operator,word)
            local p=OBJ(r[#r]) -- grep the value, skip the comments
            if v=='~' and  --posible unary operator
                (( find(p,"[^%)}%]'\"%P]") and  not find(p,"%[=*%[")) or  --there is no breaket or string before op or string
                keywords_ids[p] or kp[p]) then  -- there is no keyword before op
                    r[#r+1]="__PROJECT_NAME__.mt.bnot^"  return 
            end     --bnot located. Insert and return...
            
            insert(r,l[#l].m[k] or l[#l].m.bor or l[#l].start_of_object,"__PROJECT_NAME__.setmetatable({")
            r[#r+1]="},__PROJECT_NAME__.mt."..k..(v=='//' and ')/' or ')..')
            local i=#r+1
            local l=l[#l] --relocate l var
            if v=='|' then l.m.bxor=i end 
            if find(v,'[|~]') then l.m.band=i end 
            if find(v,'[|~&]') then l.m.shl,l.m.shr,l.m.idiv=i,i,i end  -- Full support of bitwizes!111 Finaly!
            if find(v,"([><])%1") then l.m.idiv=i end 
        end             -- Full support of idiv
    end 
end }
Features.lua53=Features.M
end


--DEFAULT: ALL INCLUSIVE (E feature disabled!)
Features.A={ function (Ctrl)
 Features.M[1](Ctrl)  -- Lua5.3 opts
 Features.KS[1](Ctrl)  -- Keyword shortcuts
 Features.IS[1](Ctrl)  -- IS keyword
 Features.N[1](Ctrl)  -- nil forgiving operators
 Features.CA[1](Ctrl)  -- X= operators
 Features.DA[1](Ctrl)  -- default function arguments
 Features.NF[1](Ctrl)  -- octal and binary number formats
 Ctrl.Operator['..']=' ..'  --fix number concatenation bug
 for K,V in pairs{Features.KS,Features.LF,Features.N}do
     for k,v in pairs(V)do
         Ctrl.Operator[k]=v
     end
 end
end }
Features.All=Features.A

__PROJECT_NAME__.setmetatable=setmetatable
__PROJECT_NAME__.features=Features
__PROJECT_NAME__.nilF=NIL_Forgive
__PROJECT_NAME__.mt=M
__PROJECT_NAME__.version="4.1-alpha"
__PROJECT_NAME__.creator="M.A.G.Gen."
__PROJECT_NAME__._ENV=_ENV
__PROJECT_NAME__.is=is
__PROJECT_NAME__.q_eq=qeq

_G.__PROJECT_NAME__ = __PROJECT_NAME__

return __PROJECT_NAME__

