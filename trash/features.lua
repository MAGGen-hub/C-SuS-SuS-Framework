local gmatch=string.gmatch
local match=string.match
local gsub=string.gsub
--KEYWORDS BASE
local keywords_base = {}
local level_hash = {}
for k in gmatch("if function for while repeat elseif else do then end until ] ) } { ( [ local return in break ","%S+")do keywords_base[#keywords_base+1]=k end
-- {open_lvl,close_lvl,level_ends}
for k,v,e in pairs(keywords_base) do
    e = keywords_base[({9,10,8,8,11,9,10,10,0,0,0,0,0,0,14,13,12})[k]or 0]
    level_hash[v]={k==9 and{["else"]=1,["elseif"]=1,["end"]=1}or e and {[e]=1} or nil,k>5 and k<15}
end --data_struct = {open_lvl_with_ends,close_lvl}

require"cc.pretty".pretty_print(level_hash)

--OPERATORS BASE
local opts_base = {}
local opts_hash = {}
local i = 1
for k,v in gmatch([[;
,
=
or
and
< > <= >= ~= ==
|
~
&
<< >>
..
+ -
* / // %
not # - ~
^
. : ]],'(%S+)(.)')do --basic operator pull
    opts_base[i] = opts_base[i] or {}
    opts_base[i][#opts_base[i]+1]=k
    opts_hash[k]= opts_hash[k] and {opts_hash[k][1],i} or {i}
    i = v=="\n"and i+1 or i
end --data_struct = {priority,unary_priority or 0}   if unary_priority==0 that means -> only unary operator exist 'nil'-> only binary
opts_hash["not"][2]=-1
opts_hash["#"][2]=-1

--MAIN FEATURES SYSTEM
load_lib=function(Control,path,...)
    local func=native_load("return "..path,"Load Lib",nil,Features)()--access table
    Control.Loaded[">"..path]=true
    
end


fast_insert=function(Control,s,j,i,t)-- t -> quence switch
    t=t and"word"or"operator"
    insert(Control.Result,s)
    Control[t]=sub(Control[t],j+1)
    Control.index=Control.index+j
    Control.Core(i)
end

--function to make quick override for default system reaction
local Features={help={
    make_react=function(Control,s,j,i,t)
        t=t and"word"or"operator"
        return function()
            insert(Control.Result,s)
            Control[t]=sub(Control[t],j+1)
            Control.index=Control.index+j
            Control.Core(i)
        end
    end
}}
Features.code={
    event=function(Control)--EVENT SYSTEM
        local e e={data={},
        reg=function(name,func,id)--id here to control order
            local l=e.data[name]or{}
            id=id or#l+1
            if"number"==type(id)then insert(l,id,func)else l[id]=func end
            e.data[name]=l
            return id
        end,
        run=function(name,...)--run all registered functions with args
            local l,rm=e.data[name]or{},{}
            for k,v in pairs(l)do rm[k]=v(...)end
            for k in pairs(rm)do 
                if"number"==type(k)then remove(t,k)else l[k]=nil end
            end
        end}
        Control.Event=e
    end,
    leveling=function(Control,level_hash)--LEVELING SYSTEM
        Control:load_lib("code.event")
        local a,l={["main"]=1} 
        level_hash[a]={a}--setup main level finalizer
        l={{type="main",index=1},
        data=level_hash,
        fin=function()
            if#l<2 then l.close("main",a)
            else Control.push_error("Can't close 'main' level! Found (%d) unfinished levels!",#l-1)end
        end,
        close=function(obj,f)
            f=f==a and a or{}
            local e,c,r=remove(l)
            if f~=a and#l<2 then Control.push_error("Attempt to close 'main'(%d) level with '%s'!",#l,obj)return end
            c=e.ends or f--setup level ends/fins
            if c[obj]then Control.Event.run("lvl_close",e,obj)return end
            r="'"for k in pairs(c)do r=r..k.."' or '"end r=sub(r,1,-6)
            Control.push_error(#r>0 and"Expected %s to close '%s' but got '%s'!"or"Attempt to close level with no ends!",r,e.type,obj)
        end,
        open=function(obj,ends)
            if#l<1 then Control.push_error("Attempt to open new level '%s' after closing 'main'!",obj)return end
            local e={type=obj,index=#Control.Result,ends=ends or(l.data[obj]or{})[1]}
            Control.Event.run("lvl_open",e)
            insert(l,e)
        end,
        ctrl=function(obj)
            local t=l.data[obj]
            t=t[2]and l.close(obj)or t[1]and l.open(obj,t[1])
        end}
        Control.Level=l
    end,
    priority=function(Control,opts_hash,level_hash,affect)--PRIORITY SYSTEM,priority value structure {priority, index in result table}
        Control:load_lib("code.leveling",level_hash or{})
        local l,p=Control.Level
        Control.Event.reg("lvl_open",function(lvl)lvl.pr_seq={{1,lvl.index,1}}end)--add field to lvl constructor
        p={data=opts_hash,lang_affect=affect,prew={__VALUE__,1},
        reg=function(prior,is_unary)insert(l[#l].pr_seq,{prior,#Control.Result,is_unary})end,--register new priority entity
        unary=function(op)return op[2]and(0>op[2]and op[1]or(p.prew==__OPERATOR__ or p.prew==__OPEN_BREAKET__)and op[2])end,--check curent operator type and return unary priority if exist
        run=function(obj,tp)
            if not p:lang_affect(obj,tp)then--affect priority sequecne using language statement rules
                if tp==__OPERATOR__ then
                    local op,u=l.data[obj]
                    u=p.unary(op)
                    p.reg(u or op[1],u)
                end
            end
            --TODO:set prew val (prewious)
            p.prew=tp~=__COMMENT__ and {tp,#Control.Result} or p.prew
        end}
        Control.Priority=p
    end,
    lua={
        struct=function(Control)--comment/string/number detector
            local get_number_part=function(nd,f) --function that collect number parts into num_data. 
                local ex                            --Returns 1 if end of number found or nil if floating point posible
                nd[#nd+1],ex,Control.word=match(Control.word,format("^(%s*([%s]?%%d*))(.*)",unpack(f)))--get number part
                Control.operator="" -- dot-able number protection (reset operator)
                if#Control.word>0 or#ex>1 then return 1 end--finished number or finished exponenta
                if#ex>0 then--unfinished exponenta #ex==1
                    Control.Iterator()-- update op_word_seq
                    ex=match(Control.operator or"","^[+-]$")
                    if ex then
                        nd[#nd+1]=ex
                        nd[#nd+1],Control.word=match(Control.word,"^(%d*)(.*)")
                        Control.operator=""
                    end --TODO: else push_error() end -> incorrect exponenta prohibited by lua
                    return 1
                end --unfinished exponenta #ex==1
            end
            local get_number,split_seq=function()--get_number:function to locate numbers with floating point;
                local c,d=match(Control.word,"^0x")d=Control.operator=="."and not c--dot-able number detection (t-> dot located | c->hex located)
                if not match(Control.word,"^%d")or not d and#Control.operator>0 then return end --number not located... return
                local num_data,f=d and{"."}or{},c and{"0x%x","Pp"}or{"%d","Ee"}
                if get_number_part(num_data,f)or"."==num_data[1]then return num_data end--fin of number or dot-able floating point number
                -- now: #ex==0 and #Control.word==0; all other ways are found
                --Control.word==0 -> number might have floating point
                Control.Iterator() --update op_word_sequences
                if Control.operator=="."then --floating point found
                    num_data[#num_data+1]="."
                    f[1]=sub(f[1],-2)
                    get_number_part(num_data,f)
                end
                return num_data
            end,
            function(data,i,seq)--split_seq:function to split operator/word quences
                seq=seq and"word"or"operator"
                data[#data+1]=i and sub(Control[seq],1,i)or Control[seq]
                Control[seq]=i and sub(Control[seq],i+1)or""
                Control.index=Control.index+(i or 0)
                return i
            end
            --STRUCTURE MODULE
            Control.Struct=function()
                local com,rez,mode,lvl,str=#Control.operator>0 and"operator"or"word",{}
                --SPACE HANDLER
                mode,Control[com]=match(Control[com],"^(%s*)(.*)")
                mode,com=gsub(mode,"\n",{})--line counter
                Control.line=Control.line+com
                Control.Result[#Control.Result]=Control.Result[#Control.Result]..mode--return space back to place
                --STRUCTURE HANDLER
                if#Control.operator>0 then --string structures
                    com,lvl=match(Control.operator,"^(-?)%1%[(=*)%[")--long strings and coments
                    com=match(Control.operator,"^-%-")
                    str=match(Control.operator,"^['\"]")--small strings/comments
                    if lvl then --LONG BUILDER
                        lvl="%]"..lvl.."()%]"
                        repeat
                            if split_seq(rez,match(Control.operator,lvl))then mode=com and __COMMENT__ or __STRING__ break end --structure finished
                            insert(rez,Control.word)
                        until Control.Iterator()
                    elseif str then --STRING BUILDER
                        str="(\\*()["..str.."\n])"
                        while Control.index do
                            com,mode=match(Control.operator,str)
                            if split_seq(rez,mode)then--end of string found
                                mode=match(com,"\n$")
                                lvl = lvl or mode --line counter
                                -- "ddd \
                                -- abc" --still correct string because there is an "\" before "\n"
                                if #com%2>0 then mode=not mode and __STRING__ break end --end of string or \n found
                            else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
                                if split_seq(rez,match(Control.word,"()\n"),1)then break end --unfinished string "word" mode split seq
                                Control.Iterator()
                            end
                        end
                    elseif com then --COMMENT BUILDER
                        repeat
                            if split_seq(rez,match(Control.operator,"()\n"))or split_seq(rez,match(Control.word,"()\n"),1)then Control.line=Control.line+1 break end --comment end found
                        until Control.Iterator()
                        mode=__COMMENT__
                    else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
                        rez=get_number()
                        mode=rez and __VALUE__--__NUMBER__
                    end
                elseif#Control.word>0 then --NUMBER BUILDER
                    rez=get_number()
                    mode=rez and __VALUE__ --__NUMBER__
                end
                if rez then
                    rez=concat(rez)
                    if lvl then
                        rez,com=gsub(rez,"\n",{})
                        Control.line=Control.line+com --line counter for long structures
                    end
                    Control.Result[#Control.Result+1]=rez
                    Control.Core(mode or __UNFINISHED__,rez)-- mode==nul or false -> unfinished structure PUSH_ERROR required
                    return true --inform base that structure is found and structure_module_restart required before future processing
                end
            end
            --RETURN LOCALS FOR FUTURE USE
            return get_number_part,split_seq
        end,
        prior_affect=function(Control)
            return function(p,obj,tp)
                local pt,pi=unpack(p.prew)
                if pt~=__OPERATOR__ and(tp==__VALUE__ or tp==__WORD__)or pt==__VALUE__ and(tp==__OPEN_BREAKET__ or tp==__STRING__)then
                    p.reg(1,1)
                    Control.Event.run("stat_end",obj,tp,pt,pi)
                end
            end
        end,
        all=function(Control)--final version of lua analizer
            local lvl_hash,opts_hash = Features.code.lua.base(Control)
            Features.code.priority(Control,lvl_hash,opts_hash,Features.code.lua.prior_affect(Control))
            Control.num_part,Control.split_seq=Features.lua.struct(Control)--setup local functions as part of FUNCTIONAL EXTENDOR API
        end
}}

Features.code.lua.base=function(Control)
    if not Control.make_react then Features.help.make_react(Control)end--init helping systems (make_react)
    local l_opts_h,l_lvl_h,kwd={},{},{}
    --SETUP REACTIONS FOR KEYWORDS AND BREAKETS
    for k,v in pairs(level_hash)do l_lvl_h[k]=v --localize leveling hash
        if match(k,"%w")then Control.Words[k]=Control:make_react(k,#k,__KEYWORD__,1)kwd[k]=v --setup keywords
        else Control.Operators[k]=Control:make_react(k,1,match(k,"[})%]]")and __CLOSE_BREAKET__ or __OPEN_BREAKET__)end--breakets
    end
    for k,v in pairs(opts_hash)do l_opts_h[k]=v --localize operator hash
        if match(k,"%w") then Control.Words[k]=Control:make_react(k,#k,__OPERATOR__,1)
        else Control.Operators[k]=k end --setup operators
    end
    Control.Operators["..."]=Control:make_react("...",3,__VALUE__)--var_args
    Control.Words["nil"]=Control:make_react("nil",3,__VALUE__)
    Control.Words["true"]=Control:make_react("true",4,__VALUE__)
    Control.Words["false"]=Control:make_react("false",5,__VALUE__)
    Control.is_keyword=kwd
    Control.is_operator=l_opts_h
    return l_lvl_h,l_opts_h --return calculated values for future use
end

--LOAD FEATURE Section
load_feature=function(Control,name,...)
    
end


--cssc_function_extend -> module

cssc_func_extend=function()






