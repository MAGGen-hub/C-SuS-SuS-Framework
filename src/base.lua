-- PREPROCESSOR BASE MODULE
__PROJECT_NAME__.load = function (x,name,mode,env)
    if type(x)=="string" then -- x might be a function or a string
        local control_string=match(x,"^<.->") or match(x,"^#!.-\n?<.->") -- locate control string
        if control_string then --control string exists!
        
            --INITIALISE LOCALS
            local previous_operator,Result,Word,Operator,Control,string_mode,temp,a,b,l,e="",{"local ____PROJECT_NAME__=__PROJECT_NAME__.data;"},{},{['"']=placeholder_func ,["\0"]= function (Ctrl) local r=Ctrl.Result r[#r]=r[#r]..(remove(Ctrl.comments,1) or "") end ,['..']='..',['...']='...'} -- " - for strings \0 - for comments
            x=sub(x,#control_string+1) --remove control string to start parsing
            Control={Operator=Operator,Word=Word,Core=placeholder_func ,Result=Result,Finaliser={},comments={},line=1,previous_value=1} -- initialise control tablet for special functions call
                 --S -> the core module (empty by default)
            --INITIALIZE COMPILLER
            for K,V in gmatch(control_string,"([%w_]+)%(?([%w_. ]*)")do--load flags that used in control string: K - feature name V - feature argument
                if Features[K] then -- feature exist
                    for k,v in pairs(Features[K].opts or{})do Operator[k]=v end
                    for k,v in pairs(Features[K].words or{})do Word[k]=v end
                    Control.Core=Control.Core==placeholder_func and Cores[Features[K].core or 1](Control,V,x,name,mode,env) or Control.Core
                    l=Features[K].init and Features[K].init(Control,V,x,name,mode,env) -- [1] index is used to store special compiller directives
                    if l then  return l end --PRELOAD CHECK
                end                                          -- if special has argumet V ex: "<pre(V)>" then F["pre"][1](ctrl_table,"V")
            end
            
            --COMPILE -- o: operator, w: word
            l=#x+1
            for operator,word,index in gmatch(x,"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%[-`{-~\\-_%s]*[^\n%S]*)()")do
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
                    --operator=gsub(operator,"-%-%s-\n","\n")--remove all empty comments (they may corrupt a lot of things!)
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
                                if b and #operator>0 then --if O[posible_operator] -> Lua-MC enabled operator (or something else) found and must be parced
                                    b=Control.Core(a,b,index) or b -- CORE module call
                                    if 7>#type(b) then --type<7 -> string; >7 - function | these can't be any other values
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
            --if mode=="c" then  return Result end 
        end
    end
    return native_load(x,name,mode,env)
end
