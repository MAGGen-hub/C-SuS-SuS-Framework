-- FEATURES of (C SuS SuS Language)

Features.PC={opts={
    ["/|"]=keywords_base[1],--if
    ["?"]=keywords_base[9],--then
    [":|"]=keywords_base[6],--elseif
    ["\\|"]=keywords_base[7]}}--else
Features.platform_condition = Features.PC

Features.KS={opts={
    ["@"]=keywords_base[12],--local
    --["$"]=keywords_base[13],--return  --DEPRECATED!!!
    ["||"]=" or ",--or
    ["&&"]=" and ",--and
    ["!"]=" not ",--not
    [";"]=keywords_base[10]}}--end
Features.keywords_shortcuts = Features.KS

Features.LF={opts={
    ["->"]= function (Ctrl,operator)
        print(operator)
        local i,a,e,p=#Ctrl.Result,1
        e=Ctrl.Result[i]
        p=find(e,"^%)%s*") and "" or "("
        while i>0 and (#p>0 and (a and (match(e,"[%w_]+") or "..."==e) or ","==e) or #p<1 and  not find(e,"^%(%s*"))do --comma or word or ( if ) located
            i,a=i-1,not a
            e=Ctrl.Result[i] end
        insert(Ctrl.Result,#p<1 and i or i+1,keywords_base[2]..p)-- K[2] - function keyword K[13] - return
        Ctrl.Result[#Ctrl.Result+1]=(#p>0 and ")" or "")..(sub(operator,1,1)=="-" and keywords_base[13] or "")
        if Ctrl.Level then --core exist
            Ctrl.previous_value=2 -- Lua5.3 operators compatability patch (and for some future things)
            Ctrl.Core.Level_ctrl("function",1)
            Ctrl.Result[#Ctrl.Result+1]=""
	    --Ctrl.Core.All_event_reactors.pc("==")
	    --Ctrl.Level[#Ctrl.Level].start_of_object = #Ctrl.Result-3
        end
    end}
}
Features.LF.opts["=>"]=Features.LF.opts["->"]
Features.lambda_functions = Features.LF


Features.KS.opts[';']= function (Ctrl,operator,word)  -- any ";" that stand near ";,)]" or "\n" will be replaced by " end " for ex ";;" equal to " end  end "
     local a,p=match(operator,"(;*) *([%S\n]?)%s*")
     
     if #p>0 and p~="(" or #a>1 then 
        for i=1,#a do
            Ctrl.Result[#Ctrl.Result+1]=keywords_base[10]
            if Ctrl.Level then Ctrl.Core.Level_ctrl("end") end  --keywords_base[10]=" end "
        end
     else Ctrl.Result[#Ctrl.Result+1]=";" end 
     return sub(operator,#a+1)
end 

 --0b0000000 and 0o0000.000 number format support (avaliable exponenta: E+-x)
Features.NF={core="Lang_Core_41",
    init= function (Ctrl) --return function that will be inserted in special extensions table
    Ctrl.Core.Word_event_reactors.before= function (operator,word)
        local a,b,c,r,t=match(word,"^0([bo])(%d*)([eE]?.*)")  --E for exponenta
        if Ctrl.floating_point and Ctrl.Result[#Ctrl.Result]=="." then
            t,b,c=Ctrl.floating_point,match(word,"(%d+)([eE]?.*)") --b located! posible floating point!
        else
            Ctrl.floating_point=nil
        end 
        if b then  --number exist
          t,r=t or (a>"b" and "8" or "2"),0 
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

 -- Default function arguments feature
Features.DA={core="Lang_Core_41",
    init= function (Ctrl)
    local l=Ctrl.Level
    local r=Ctrl.Result
    
    l.on_lvl_open[#l.on_lvl_open+1]= function (o,lvl_tab)
         if lvl_tab.type_of_lvl=="function" then lvl_tab.ada=1 end  -- allow_default_args for next level
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
        if d and operator==';' then err(Ctrl,UE,';') end 
        if d and #d>0 and operator==',' then 
            d[#d].nd=d[#d].nd or #r 
        end  
    end 
    
    Ctrl.Operator[":="]= function (Ctrl) -- operator and word args disabled
         if  not l[#l].da then err(Ctrl,UE,':=') --emit an error
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

Features.N={core="Lang_Core_41",init= function (Ctrl)
    Ctrl.Core.Operator_event_reactors.N= function (o) 
        if match(o,'%?[.:"({]') then --old variant : Features.N.opts[o]
            Ctrl.current_value=Ctrl.previous_value
        end
    end
end,opts={} } --mark F.N operators as start searcher allowed (core-invisible)
Features.nil_forgiving = Features.N

for v,k in gmatch('.:"({',"()(.)")do
    Features.N.opts['?'..k]= function (Ctrl,operator,word)
        local r=Ctrl.Result
        if #r<2 or Ctrl.previous_value<3 then err(Ctrl,ATP,k,r[#r]) end  --previous value was a keyword or operator
	if find(sub(operator,3),"[^%z%s]") then -- %z for \0
		err(Ctrl,ATP,OBJ(sub(operator,3)),k) end 
        insert(r,Ctrl.Level[#Ctrl.Level].start_of_object," ____PROJECT_NAME__.nilF(") --first part
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
Features.KS.init= function (Ctrl)
    Ctrl.EQ={"&&","||",unpack(Ctrl.EQ or {})} 
end 
 -- ?= function
local qeq= function (b,a)  --b - base, a - adition
    if a==nil then return b
    else return a end
end 
Features.CA={core="Lang_Core_41",init= function (Ctrl)
     --EQ - table with operators that support *op*= behaviour
    Ctrl.EQ={"+","-","*","%","/","..","^","?",unpack(Ctrl.EQ or {})}
    local l=Ctrl.Level
    local r=Ctrl.Result
    Ctrl.Core.All_event_reactors.br= function (operator,word)
        if l[#l].br and (Ctrl.previous_value==3 or Ctrl.previous_value>4) and (Ctrl.current_value==1 or Ctrl.current_value==3 or (operator==',' or operator==';')) then   --breaket request located and end of block located
            l[#l].br=nil
            r[#r+1]=")"
            l[#l].start_of_object = #r+1
        end
    end
    l.on_lvl_close[#l.on_lvl_close+1]= function (o,lvl_tab) if lvl_tab.br then r[#r+1]=")" end  end   -- on level end
    Ctrl.Finaliser.c= function () if l[#l].br then r[#r+1]=")"  end  end 
     --operator main parce function
    local op= function (Ctrl,operator,word)
        local lt=l[#l].type_of_lvl
        if PAch(lt) then err(Ctrl,format("Attempt to use X= operator in prohibited area! '%s *var* X= *val* %s'",lt,Ctrl.Core.level_ends[lt])) end 
        if OBJ(r[l[#l].start_of_object-1] or "")=="," then err(Ctrl,"Comma detected! X= operators has no multiple assignments support!") end 
        if #r<2 or Ctrl.previous_value<3 then err(Ctrl,ATP,k,r[#r]) end 
        operator=match(operator,"(.-)=") --for this we need only the first part of operator
        r[#r+1]="="..(operator=="?" and "____PROJECT_NAME__.q_eq(" or "") --insert equality or ?=
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

Features.IS={core="Lang_Core_41",init= function (Ctrl)
    Ctrl.Core.operator['is']=1 --add new "word" operator
    local l=Ctrl.Level
    Ctrl.Core.Operator_event_reactors[1]= function (operator,word)
        word=OBJ(word)
        if word=='is' then 
            if #Ctrl.Result<2 or Ctrl.previous_value<3 then err(Ctrl,ATP,'is',Ctrl.Result[#Ctrl.Result]) end 
            return " ..____PROJECT_NAME__.is.. " 
        end
    end 
end }


--Lua5.3 operators feature! Bitwise and idiv operators support! (only if bit32 exist)!
if bit32 then

local bt={shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
local kp={} gsub('and or , = ; > < >= <= ~= == ',"%S+", function (x)kp[x]=1 end )  -- all operators that has lower priority than bitise operators
local f= function (t,m) return "Attempt to perform "..t.." operation on a "..m.." value" end
local ATPO = "Attempt to perform %s operation on a %s value"

--Lua5.3 operation functions
M={bnot=setmetatable({},{
    __pow= function (a,b)
         local m=(getmetatable(b) or {}).__bnot
         if m then  return m(b) end 
         m=type(b)
         if m~='number' then error(format(ATPO,'bitwise',m),3) end 
         return bit32.bnot(b)
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
        if m~=t then error(format(ATPO,e,m),3) end 
        return bit32[k](a[1],b)
    end 
    M[k]=v=='//' and {__div=f} or {__concat=f}
end

Features.M={core="Lang_Core_41",init= function (Ctrl)
    Ctrl.EQ={">>","<<","&","|",unpack(Ctrl.EQ or {})} --additional equality
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
                    r[#r+1]="____PROJECT_NAME__.mt.bnot^"  return 
            end     --bnot located. Insert and return...
            
            insert(r,l[#l].m[k] or l[#l].m.bor or l[#l].start_of_object,"____PROJECT_NAME__.setmetatable({")
            r[#r+1]="},____PROJECT_NAME__.mt."..k..(v=='//' and ')/' or ')..')
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


--DEFAULT: ALL INCLUSIVE (Plantform feature disabled!)
Features.A={core="Lang_Core_41",init= function (Ctrl)
 if bit32 then
 	Features.M.init(Ctrl)  -- Lua5.3 opts
 end
 Features.KS.init(Ctrl)  -- Keyword shortcuts
 Features.IS.init(Ctrl)  -- IS keyword
 Features.N.init(Ctrl)  -- nil forgiving operators
 Features.CA.init(Ctrl)  -- X= operators
 Features.DA.init(Ctrl)  -- default function arguments
 Features.NF.init(Ctrl)  -- octal and binary number formats
 Ctrl.Operator['..']=' ..'  --fix number concatenation bug
 for K,V in pairs{Features.KS.opts,Features.LF.opts,Features.N.opts}do
     for k,v in pairs(V)do
         Ctrl.Operator[k]=v
     end
 end
end }
Features.All=Features.A

__PROJECT_NAME__.setmetatable=setmetatable
__PROJECT_NAME__.features=Features
__PROJECT_NAME__.version="4.1-alpha"
__PROJECT_NAME__.creator="M.A.G.Gen."
__PROJECT_NAME__._ENV=_ENV

__PROJECT_NAME__.data = {q_eq=qeq,is=is,mt=M,nilF=NIL_Forgive,setmetatable=setmetatable}

_G.__PROJECT_NAME__ = __PROJECT_NAME__

return __PROJECT_NAME__