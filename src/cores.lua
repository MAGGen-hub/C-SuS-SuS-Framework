--OBJ: object separator function
local OBJ= function (operator) return type(operator)=='string' and match(operator,"%S+") or "" end

--Error detector
err= function (Ctrl,err_msg,...)Ctrl.err=Ctrl.err or "__PROJECT_NAME__["..Ctrl.line.."]:"..format(err_msg,...)end
local ATP="Attempt to perform '%s' on '%s'!"
local UE="Unexpected '%s'!"

-- C SuS SuS Language Core Version 45
Cores.Lang_Core_41= function (Ctrl)
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
                 Ctrl.current_value=find(word,"^['\"%[]") and 6 or 3 word=event_invocator(c.Word_event_reactors,operator,word,index) or word  --KEYWORD(1)  WORD(3)         STRING(6)
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
end