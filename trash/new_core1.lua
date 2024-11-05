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
local i = 0
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
. : [ ( { " ]],'(%S+)(.)')do --basic operator pull
    opts_base[i] = opts_base[i] or {}
    opts_base[i][#opts_base[i]+1]=k
    opts_hash[k]= opts_hash[k] and {opts_hash[k][1],i} or {i}
    i = v=="\n"and i+1 or i
end --data_struct = {priority,unary_priority or -1}   if unary_priority==-1 that means -> only unary operator exist
opts_hash["not"][2]=-1
opts_hash["#"][2]=-1

--local br_hash ={}
--for k,v in gmatch("(){}[]","(.)(.)") do
--    br_hash[k]={{v},false}
--    br_hash[v]={nil,true}
--end

--require"cc.pretty".pretty_print(opts_base)
--require"cc.pretty".pretty_print(opts_hash)

--function that collect number parts into num_data. Returns 1 if end of number found or nil if floating point is posible
function get_number_part(nd,f,ex) --ex here NOT an arg, just local var
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

function get_number(t) -- t here not an arg -> just local var
    t=Control.operator=="."
    if not match(Control.word,"^%d")or not t and#Control.operator>0 then return end --number not located... return
    local num_data,f=t and{"."}or{},match(Control.word,"0x")and{"0x%x","Pp"}or{"%d","Ee"}
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
end

function split_seq(data,i,seq)
    data[#data+1]=i and sub(Control[seq],1,i)or Control[seq]
    Control[seq or"operator"]=i and sub(Control[seq],i+1)or""
    Control.index=Control.index+(i or 0)
    return i
end
--comment and string detector
Control.Struct = function()
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
                    if mode or#com%2>0 then mode=not mode and __STRING__ break end --end of string or \n found
                else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
                    if split_seq(rez,match(Control.word,"()\n"),"word")then break end --unfinished string
                    Control.Iterator()
                end
            end
            Control.line=Control.line+(mode and 0 or 1)
        elseif com then --COMMENT BUILDER
            repeat
                if split_seq(rez,match(Control.operator,"()\n"))or split_seq(rez,match(Control.word,"()\n"),"word")then Control.line=Control.line+1 break end --comment end found
            until Control.Iterator()
            mode=__COMMENT__
        else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
            rez=get_number()
            mode=rez and __NUMBER__
        end
    elseif#Control.word>0 then --NUMBER BUILDER
        rez=get_number()
        mode=rez and __NUMBER__
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

do

    Control.Core=function(LOT,obj) --Loaded Object Type (ENUM:__COMMENT__,__STRING__,__NUMBER__,__WORD__,__KEYWORD__,__OPERATOR__,__UNFINISHED__)
        if LOT==__WORD__ or LOT==__OPERATOR__ then
        end
    end

end

