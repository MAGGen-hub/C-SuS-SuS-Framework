-- PROTECTION LAYER
-- This local var layer was created to prevent unpredicted behaviour of preprocessor if one of the functions in _G table was changed.
local A,E=assert,"cssc_beta load failed because of missing libruary method!"

-- string.lib
local gmatch = A(string.gmatch,E)
local match  = A(string.match,E)
local format = A(string.format,E)
local find   = A(string.find,E)
local gsub   = A(string.gsub,E)
local sub    = A(string.sub,E)

-- table.lib
local insert = A(table.insert,E)
local concat = A(table.concat,E)
local remove = A(table.remove,E)
local unpack = A(table.unpack or unpack,E)

-- math.lib
local floor = A(math.floor,E)

-- generic.lib
local assert       = A
local type         = A(type,E)
local pairs        = A(pairs,E)
local error        = A(error,E)
local tostring     = A(tostring,E)
local getmetatable = A(getmetatable,E)
local setmetatable = A(setmetatable,E)
local pcall        = A(pcall,E)
--Bit32 libruary prepare section
local bit32        = bit32 or print"Warning! Bit32 libruary not found! Bitwize operators module disabled!"and nil
if bit32 then
    local b = {}
    for k,v in pairs(bit32)do b[k]=v end
    b.shl=b.lshift
    b.shr=b.rshift
    b.lshift,brshift=nil --optimisation
    bit32=b
end

-- Lua5.2 load mimicry
local native_load = A(load,E)

A,E=nil
local cssc_beta = {}
local placeholder_func = function()end

-- BASE VARIABLES LAYER END
--ARG CHECK FUNC
local arg_check,t_copy,t_swap,Modules,Features=function(Control)if(getmetatable(Control)or{}).__type~="cssc_unit"then error(format("Bad argument #1 (expected cssc_unit, got %s)",type(Control)),3)end end,function(s,o,f) for k,v in pairs(s)do o[k]=f and o[k]or v end end,function(t,o)o=o or {}for k,v in pairs(t)do o[v]=k end return o end
--LOCALS
local Configs,_init,_modules,_arg,load_lib,run,clear,make,clear_run,read_control_string,load_control_string={cssc="lua.cssc=M.KS.IS.N.CA.DA.NF.LF"},setmetatable({},{__tostring=native_load"return'init'"}),setmetatable({},{__tostring=native_load"return'modules'"}),{'arg'},
function(Control,path,...)arg_check(Control)--load_lib
	local ld,arg,tp=Control.Loaded[">"..path],{}
	if false~=ld then
		Control.log("Load %s",">"..path)
		if ld and ld~=1 then return unpack(ld)end--return previous result (2 mode)
		arg={native_load("return "..path.."(...)","Feature Loader",nil,Features)(Control,...)}
		tp=remove(arg,1)or false --if no return -> default mode (only one launch allowed)
		Control.Loaded[">"..path]=2==tp and arg or tp--setup reaction to future call(deny_lib_load/recal/return_old_rez)
	end
	return unpack(arg)
end,
function(Control,x,...)arg_check(Control)--run
	Control.src=x
	Control.args={...}
	--PRE RUN
	Control:tab_run"PreRun"
	--COMPILE
	while not Control.Iterator(0)do
		Control:tab_run("Struct",1)
		--for k,v in pairs(Control.Struct)do --custom structure system
		--	if v(Control)then break end
		--end
	end
	--POST RUN
	Control:tab_run"PostRun"
	--FINISH COMPILE and return result
	local e=type(Control.Return)
	if"function"==e then
		return Control.Return()
	elseif"table"==e then
		return unpack(Control.Return)
	else
		return Control.Return
	end
end,
function(Control)arg_check(Control)Control:tab_run"Clear"end--clear
clear_run=function(Control,x,...)Control:clear()return Control:run(x,...)end
make=function(ctrl_str)
	--ARG CHECK
	if"string"~=type(ctrl_str)then error(format("Bad argument #2 (expected string, got %s)",type(ctrl_str)))end
	--INITIALISE PREPROCESSOR OBJECT
	local m,i,Control,r={__type="cssc_unit",__name="cssc_unit"},1
	r={__call=function(S,s,...)if#S>999 then remove(S,1)end insert(S,format("%-16s : "..s,format("[%0.3d] [%s]",i,S._),...)) i=i+1 end}
	Control=setmetatable({
		--MAIN FUNCTIONS
		ctrl=ctrl_str,run=run,clear=clear,clear_run=clear_run,load_lib=load_lib,
		tab_run=function(Control,tab,br)for k,v in pairs(Control[tab])do if v(Control)and br then break end end end,
		--MAIN OBJECTS TO WORK WITH
		PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},
		--SYSTEM PLACEHOLDERS
		error=setmetatable({_=" Error "},r),--send error msg
		log=setmetatable({_="  Log  "},r),  --send log msg
		warn=setmetatable({_="Warning"},r), --send warning msg
		Core=placeholedr_func,
		Iterator=native_load"return 1",
		--META
		meta=m},m)
	--Control.push_error=function(str,...)insert(Control.Errors,{format(str,...),...})end--default error inserter
	--CONTROL STRING LOAD
	load_control_string(Control,read_control_string(ctrl_str))
	--POST LOAD
	Control:tab_run"PostLoad"
	return Control
end
read_control_string=function(s)--RECURSIVE FUNC: turn control string into table and load configs
	local c,t,l,e,m={"config",[_arg]={}}--config and arg marks!
	m={__index=function(s,i)s=s==c and setmetatable({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,__call=function(s,...)
			local l={...}
			for i=1,#l do l[i]="table"==type(l[i])and l[i][_arg]and concat(l[i],".")or l[i] end
			s[_arg][s[#s]]=#l==1 and"table"==type(l[1])and l[1]or l
			return s end}
	l,e=native_load(gsub(format("return{%s}",s),"([{,])([^,]-)=","%1[%2]="),"ctrl_str",t,setmetatable({},{__index=function(s,i)return setmetatable(i==c[1]and c or{[_arg]={},i},m) end}))
	l=e and error(format("Invalid control string: <%s> -> %s",s,e))or l()
	s,l[c]=l[c]
	t,e=pcall(concat,s)
	e=Configs[t and e or s]
	t=1
	for k,v in pairs(e and read_control_string(e)or{})do
		-- l["number"==type(k)and#l+1 or k]=v
		if"number"==type(k)then insert(l,v,t) t=t+1 else l[k]=v end
	end
	return l,a
end
load_control_string=function(Control,main,sub,nxt,path)--RECURSIVE FUNC: load readed control string and fill Control table with contents of loaded modules
	local prt,mod,e
	if nxt then--LOAD MODULE
		prt=remove(main,1)
		mod=nxt[prt]or{}
		path=path..prt
		Control.Loaded[path],e=pcall(function()
			if Control.Loaded[path]then return end --prevent double load
			Control.log("Load %s",path)
			--prt=mod[_modules]and{}or#main>0 and main or sub or{}
			--for k,v in pairs(prt)do if"table"==type(v)then prt={}break end end
			--   print(path,mod[_init])
			;(mod[_init]or placeholder_func)(Control,mod,main[_arg][prt])
			--write(path)write"Args: "p(prt)
		end)
		mod=e and error(format('Error loading module "%s": %s',path,e),4)or mod[_modules]
	else
		mod=Modules--INIT LOADER
		sub=main
	end
	--mod={}--DEBUG! Show all modules without any rules
	if mod then  --load sub_modules if exist
		path=path and path.."."or"@"
		if nxt and#main>0 then load_control_string(Control,main,sub,mod,path)
		else for k,v in pairs(sub or{})do
			e=e or"string"==type(v)--set correct mode
			v=e and{v}or v
			v="number"==type(k)and{v}or{k,v}
			load_control_string(Control,v[1],v[2],mod,path)
		end end
	end
end
--TODO: giper native load with auto _ENV set
do
--__PREPARE_FEATURES__

Features={code={cdata=function(Control,opts_hash,level_hash)--API to save code data to specific table
    local c,clr
    clr=function()
        c={opts=c.opts,lvl=c.lvl,run=c.run,reg=c.reg,del=c.del,tb_until=c.tb_until,tb_while=c.tb_while, {11}}
        Control.Cdata=c
    end
    c={opts=opts_hash,lvl=level_hash,
    run=function(obj,tp)--to call from core
        local lh,rez=c.lvl[obj]
        --if obj=="(" then print(lh,rez) end
        if lh and lh[2] then --object with lvl props
            rez=Control.Level[#Control.Level]
            rez ={tp,rez.ends[obj] and rez.index}
        elseif tp==2 then
            local pd,lt,un = c.opts[obj],c[#c][1]--priority_data,last_type,is_unary
            un = pd[2] and (not pd[1] or not (lt==2 or  lt==4 or lt==9))--unary or binary
            rez={tp,not un and pd[1],un and pd[2]}--inser operator data handle
        else
            rez={tp}
        end
        c[#c+1]=rez
    end,
    reg=function(tp,id,...)--reg custom value in specific field
        local rez = args and {tp,...} or {tp}
        insert(c,id or #c+1,rez)
    end,
    del=function(id)--del specific value from index
        return remove(c,id or #c+1)
    end,
    tb_until=function(type_tab,i)--thaceback_until:
        i=i or#c+1
        repeat i=i-1 until i<1 or type_tab[c[i][1]]
        return i,c[i]
    end,
    tb_while=function(type_tab,i)--thaceback_while:
        i=i or#c
        while i>0 and type_tab[c[i][1]]do i=i-1 end
        return i,c[i]
    end, {11}
    }
    Control.Cdata=c
    insert(Control.Clear,clr)
end,
lua={base=function(Control,O,W)-- O - Control.Operators or other table; W - Control.Words or other table (depends on current text parceing system)
--BASE LUA SYNTAX STRING (keywords/operators/breakets/values)
local make_react,lvl,kw,kwrd,opt,t,p,lua51=Control:load_lib"text.dual_queue.make_react",{},{},{},{},{},1,
[[K
end
else 1
elseif
then 1 2 3
do 1
in 5
until
if 4
function 1
for 5 6
while 5
repeat 7
elseif 4
local
return
break
B
{ }
[ ]
( )
V
...
nil
true
false
O
;
=
,
or
and
< > <= >= ~= ==




..
+ -
* / // %
not # -
^
. : [ ( { "
]]
--INSERT VERSION DIFF
Control:load_lib"text.dual_queue.base"
Control:load_lib"code.syntax_loader"(lua51,{
     K=function(k,...)--keyword parce
        kw[#kw+1]=k
        t=lvl[k]or{}
        for k,v in pairs{...}do
            v=tonumber(v)--or error("Expected number got: "..v)
            t[1]=t[1]or{}--open lvl
            t[1][kw[v]]=1--expected end
            lvl[kw[v]][2]=1--closing lvl
        end
        kwrd[k]=1
        lvl[k]=t
        W[k]=make_react(k,4)
    end,
    B=function(o,c)--breaket parce
        lvl[o]={{[c]=1}}--open with exepected end == c
        lvl[c]={nil,1}--closing
        O[o]=make_react(o,9)
        O[c]=make_react(c,10)
    end,
    V=function(v)--value parce
        (match(v,"%w")and W or O)[v]=make_react(v,8)
    end,
    O=function(...)--opt parce
        for k,v in pairs{...}do if""~=v then
            opt[v]=opt[v]and{opt[v][1],p}or{p}
            if match(v,"%w")then W[v]=W[v] or make_react(v,2)
            else O[v]=O[v] or v end
        end end
        p=p+1--increade priority
    end
})
lvl["do"][3]=1 --do can be standalone level and init block on it's own
opt["not"]={nil,opt["not"][1]}--unary opts fix
opt["#"]={nil,opt["#"][1]}
--TODO:coorect 'not'; '#' unary
return 1,lvl,opt,kwrd--(leveling_hash,operator_hash<with_priority>,keywrod_hash)
end,
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
		if data then
			data[#data+1]=i and sub(Control[seq],1,i)or Control[seq]
		end
		Control[seq]=i and sub(Control[seq],i+1)or""
		Control.index=Control.index+(i or 0)
		return i
	end
	--STRUCTURE MODULE
	insert(Control.Struct,function()
		local com,rez,mode,lvl,str=#Control.operator>0 and"operator"or"word"
		--SPACE HANDLER
		--mode,Control[com]=match(Control[com],"^(%s*)(.*)")
		--mode,com=gsub(mode,"\n","\n")--line counter
		--Control.line=Control.line+com
		--Control.Result[#Control.Result]=Control.Result[#Control.Result]..mode--return space back to place
		--STRUCTURE HANDLER
		if#Control.operator>0 then --string structures
			rez,com,lvl={},match(Control.operator,"^(-?)%1%[(=*)%[")--long strings and coments
			com=match(Control.operator,"^-%-")
			str=match(Control.operator,"^['\"]")--small strings/comments
			if lvl then --LONG BUILDER
				lvl="%]"..lvl.."()%]"
				repeat
					if split_seq(rez,match(Control.operator,lvl))then mode=com and 11 or 7 break end --structure finished
					insert(rez,Control.word)
				until Control.Iterator()
			elseif str then --STRING BUILDER
				split_seq(rez,1)--burn first simbol of structure
				str="(\\*()["..str.."\n])"
				while Control.index do
					com,mode=match(Control.operator,str)
					if split_seq(rez,mode)then--end of string found
						mode=match(com,"\n$")
						lvl = lvl or mode --line counter
						-- "ddd \
						-- abc" --still correct string because there is an "\" before "\n"
						if #com%2>0 then mode=not mode and 7 break end --end of string or \n found
					else -- operator may look like that : [[ \" \" \\"  ]] -- and algorithm will detect ALL three segms, that why this "else" is here
						if split_seq(rez,match(Control.word,"()\n"),1)then break end --unfinished string "word" mode split seq
						Control.Iterator()
					end
				end
			elseif com then --COMMENT BUILDER
				repeat
					if split_seq(rez,match(Control.operator,"()\n"))or split_seq(rez,match(Control.word,"()\n"),1)then Control.line=Control.line+1 break end --comment end found
				until Control.Iterator()
				mode=11
			else --DOT-ABLE NUMBER (posible number like this: " *code* .124E-1 *code* ")
				rez=get_number()
				mode=rez and 6 --6
			end
		elseif#Control.word>0 then --NUMBER BUILDER
			rez=get_number()
			mode=rez and 6 --6
		end
		if rez then
			rez=concat(rez)
			if lvl then
				rez,com=gsub(rez,"\n",{})
				Control.line=Control.line+com --line counter for long structures
			end
			Control.Result[#Control.Result+1]=rez
			Control.Core(mode or 12,rez)-- mode==nul or false -> unfinished structure PUSH_ERROR required
			return true --inform base that structure is found and structure_module_restart required before future processing
		end
	end)
	--RETURN LOCALS FOR FUTURE USE
	return __REZULTABLE__,get_number_part,split_seq
end
,
},--Close lua
syntax_loader=function()--simple function to load syntax data
	return 2,function(str,f)
		local mode,t=placeholder_func,{}
		for o,s in gmatch(str,"(.-)(%s)")do
			t[#t+1]=o
			if s=="\n"then
				mode=#t==1 and f[o]or mode(unpack(t))or mode
				t={}
			end
		end
	end
end,
},--Close code
common={event=function(Control)--EVENT SYSTEM
	local clr,e
	clr=function()e.temp={}end
	e={main={},
	reg=function(name,func,id,gl)--id here to control order
		local l=e.temp[name]or{}
		id=id or#l+1
		if"number"==type(id)then insert(l,id,func)else l[id]=func end
		e[gl and"main"or"temp"][name]=l
		return id
	end,
	run=function(name,...)--run all registered functions with args
		local l,rm=e.temp[name]or{},{}
		for k,v in pairs(e.main[name]or{})do v(...)end--global events
		for k,v in pairs(l)do rm[k]=v(...)end--local events
		for k in pairs(rm)do 
			if"number"==type(k)then remove(t,k)else l[k]=nil end--events cleanup
		end
	end}
	clr()--make temp event table
	Control.Event=e
	insert(Control.Clear,clr)
end
,
level=function(Control,level_hash)--LEVELING SYSTEM
	--Control:load_lib"common.event"
	local a,clr,l={["main"]=1}
	clr=function()for i=1,#l do l[i]=nil end l[1]={type="main",index=1,ends=a}end
	--level_hash[a]={a}--setup main level finalizer
	l={{type="main",index=1,ends=a},
	data=level_hash,
	fin=function()
		if#l<2 then l.close("main",nil,a)
		else Control.error("Can't close 'main' level! Found (%d) unfinished levels!",#l-1)end
	end,
	close=function(obj,nc,f0)
		f=f==a and a or{}
		local lvl,e,r=remove(l)
		if f~=a and#l<1 then Control.error("Attempt to close 'main'(%d) level with '%s'!",#l,obj)return end
		e=lvl.ends or f--setup level ends/fins
		if e[obj]then Control.Event.run("lvl_close",lvl,obj)return --Level end found! Invoke close event and return!
		elseif nc then return end -- level is standalone [like "do" kwrd] and can be opened without closeing prewious
		--Unexpected end! Push error
		r="'"for k in pairs(e)do r=r..k.."' or '"end r=sub(r,1,-6)
		Control.error(#r>0 and"Expected %s to close '%s' but got '%s'!"or"Attempt to close level with no ends!",r,lvl.type,obj)
	end,
	open=function(obj,ends,i)
		if#l<1 then Control.error("Attempt to open new level '%s' after closing 'main'!",obj)return end
		local lvl={type=obj,index=i or #Control.Result,ends=ends or(l.data[obj]or{})[1]}
		Control.Event.run("lvl_open",lvl)
		insert(l,lvl)
	end,
	ctrl=function(obj)
		local t=l.data[obj]
		t=t and(t[2]and l.close(obj,t[3])or t[1]and l.open(obj,t[1]))
		if not t and l[#l].ends[obj]then l.close(obj)end --custom ends
	end}
	Control.Level=l
	clr()
	insert(Control.Clear,clr)
end
,
},--Close common
text={dual_queue={base=function(Control)--base API for text/code related data
	Control.Operators={}
	Control.operator=""
	Control.word=""
	Control.Words={}
	Control.Result[1]=""
	Control.max_op_len=3
	Control.line=1
	Control.Return=function()return concat(Control.Result)end
	insert(Control.Clear,function()Control.Result={""}Control.operator=""Control.word=""end)
end,
init=function(Control)--default initer placer (has no Control)
	return 2,function(Control,mod)
		Control:load_lib"text.dual_queue.base"
		for k,v in pairs(mod.operators or{})do
			Control.Operators[k]=v
		end
		for k,v in pairs(mod.words or{})do
			Control.Words[k]=v
		end
	end
end,
iterator=function(Control,seq)-- default text system interator
	insert(Control.PreRun,function()
		local s=gmatch(Control.src,seq or"()([%s!-/:-@[-^{-~`]*)([%P_]*)")--default text iterator
		Control.Iterator=function(m)
			if m and(#(Control.operator or'')>0 or#(Control.word or'')>0)then return end --blocker for main cycle (m) can be anything
			Control.index,Control.operator,Control.word=s()
			return not Control.index
		end
	end)
end,
make_react=function(Control)--function that created sefault reactions to different tokens
	return 2, function(s,i,t,j) -- s -> replacer string, i - type of reaction, t - type of sequnece, j - local length
		t=t or match(s,"%w")and"word"or"operator"
		j=j or#s
		return function(Control)
			insert(Control.Result,s)
			Control[t]=sub(Control[t],j+1)
			Control.index=Control.index+j
			Control.Core(i,s)
		end
	end
end,
parcer=function(Control)
	local func=function(react_obj,t,j,i)
		if"string"==type(react_obj)then Control.Result[#Control.Result+1]=react_obj
		else react_obj=react_obj(Control) end --MAIN ACTION
		
		if react_obj then -- default reaction to string (functions can have default reactions if they return anything(expected string!))
			Control[t]=sub(Control[t],j+1)
			Control.index=Control.index+j
			Control.Core(i,react_obj)
		end
	end
	Control.Struct.final=function() --base handler for two sequences
		local posible_obj,react_obj
		if#Control.operator>0 then --OPERATOR PROCESSOR
			for j=Control.max_op_len,1,-1 do --split the operator_seq
				posible_obj=sub(Control.operator,1,j)
				react_obj=Control.Operators[posible_obj]
				if react_obj or j<2 then func(react_obj or posible_obj,"operator",j,react_obj and 2 or 1)break end
			end
		elseif#Control.word>0 then--WORD PROCESSOR
			posible_obj=match(Control.word,"^%S+") --split the word_seq temp=#posible_object
			react_obj=Control.Words[posible_obj]or posible_obj
			func(react_obj,"word",#posible_obj,3)
		end
	end
end,
space_handler=function(Control)-- function to proccess spaces
	insert(Control.Struct,function()--SPACE HANDLER
		local temp,space = #Control.operator>0 and"operator"or"word"
		space,Control[temp]=match(Control[temp],"^(%s*)(.*)")
		space,temp=gsub(space,"\n",{})--line counter
		Control.line=Control.line+temp
		Control.Result[#Control.Result]=Control.Result[#Control.Result]..space--return space back to place
	end)
end,
},--Close dual_queue
},--Close text
}--END OF FEATURES

end
do
--__PREPARE_MODULES__

Modules={cssc={[_init]=function(Control)
	--code parceing system
	Control:load_lib"text.dual_queue.base"
	Control:load_lib"text.dual_queue.parcer"
	Control:load_lib"text.dual_queue.iterator"
	Control:load_lib"text.dual_queue.space_handler"
	
	--base lua data (structs/operators/keywords)
	local lvl, opt, kwrd = Control:load_lib("code.lua.base",Control.Operators,Control.Words)
	Control.get_num_prt,Control.split_seq=Control:load_lib"code.lua.struct"
	
	--load analisys systems

	Control:load_lib("code.cdata",opt,lvl,placeholder_func)
	Control:load_lib("common.event")
	Control:load_lib("common.level",lvl)
	Control.inject = function(id,obj,type,...)
		if id then insert(Control.Result,id,obj) else insert(Control.Result,obj)end
		Control.Cdata.reg(type,id,...)
	end
	Control.eject = function(id)
		return {remove(Control.Result,id),unpack(remove(Control.Cdata,id))}
	end
	--core setup
	local t={3,4,6,7,8}
	t=t_swap(t)
	Control.Core=function(tp,obj)--type_of_text_object,object_it_self
		
		Control.Cdata.run(obj,tp)
		Control.Event.run(tp,obj,tp)--single event for single struct
		if t[tp]then Control.Event.run("text",obj,tp)end --for any text code values
		Control.Event.run("all",obj,tp)-- event for all structs
		
		--Control.Priority.run(obj,tp)--priority ctrl
		Control.Level.ctrl(obj)--level ctrl
	end
end
,
[_modules]={DA={[_init]=function(Control)
    local l,pht,ct = Control.Level,{},t_swap{11}

    local mt=setmetatable({},{__index=function(s,i)return i end})
    local def_arg_runtime_func = function(...)
        local data,res,val,tp,def,ch={...},{}
        for i=1,#data,4 do
            val=data[i+1]
            def=data[i+3]
            if val==nil and def then insert(res,def)--arg not inited, replace with default
            else
                ch =data[i+2]
                if ch then --type check
                    tp=type(val)
                    ch=ch==1 and {[type(def)]=1} or t_swap{(native_load("return "..ch,nil,nil,mt)or placeholder_func)()}--> dynamic type! must be equal to def_arg type
                    ch=not ch[tp] and error(format("bad argument #%d (%s expected, got %s)",data[i],data[i+2],tp),2)
                end
                insert(res,val)
            end
        end
        return unpack(res)
    end
    Control.defa=def_arg_runtime_func
    Control.Event.reg("lvl_open",function(lvl)-- def_arg initer
        if lvl.type=="function" then lvl.DA_np=1 end --set Def_Args_next_posible true
        if lvl.type=="(" and l[#l].DA_np then lvl.DA_d={c_a=1} end--init Def_Args_data for "()" level
        l[#l].DA_np=nil--set Def_Args_next_posible false
    end,"DA_lo",1)

    Control.Event.reg(2,function(obj)
        local da,i,err=l[#l].DA_d
        if da then i=da.c_a --DA data found
            if obj==":"then
                --Control.log("nm :'%s'",Control.Result[Control.Cdata.tb_while(ct,#Control.Cdata-1)])
                da[i]=da[i]or{[4]=Control.Result[Control.Cdata.tb_while(ct,#Control.Cdata-1)]}
                if not da[i][2]then --block if inside def_arg
                    err,da[i][1]=da[i][1],#Control.Cdata--this arg has strict typing!
                end
            elseif obj=="="then da[i]=da[i]or{[4]=Control.Result[Control.Cdata.tb_while(ct,#Control.Cdata-1)]} err,da[i][2]=da[i][2],#Control.Cdata--def arg start
            elseif obj==","then da.c_a=da.c_a+1 (da[i]or pht)[3]=#Control.Cdata-1--next possible arg; arg state end
            else err=1 end
            if err then
                Control.error("Unexpected '%s' operator in function arguments defenition.",obj)
                l[#l].DA_d=nil--delete defective DA
            end
        end
    end,"DA_op",1)
    
    local err_text = "Unexpected '%s' in function argument type definition! Function argument type must be set using single name or string!"
    Control.Event.reg("lvl_close",function(lvl)-- def_arg injector
        if lvl.DA_d then --level had default_args
            local da,arr,name,pr,val,obj,tej,ac=lvl.DA_d,{},{},Control.Cdata.opts[","][1]
            for i=da.c_a,1,-1 do --parce args
                if da[i]then val=da[i] ac,tej=0,nil --def_arg exist
                    insert(name,{val[4],3})insert(name,{",",2,pr})
                    if not val[2] then insert(arr,{"nil",8}) insert(arr,{",",2,pr}) end --no def_arg -> insert nil -> type only
                    val[3]=val[3]or#Control.Result-1
                    --if val[3]-(val[2]or val[1])<1 then Control.error("Expected default argument after '%s'",Control.Result[val[2]or val[1]])end
                    
                    for j=val[3]or#Control.Result-1,val[1]or val[2],-1 do --to minimum value
                        obj=Control.eject(j)
                        if j==val[2] or j==val[1] then 
                            insert(arr,{",",2,pr}) --comma replace
                        elseif val[2]and j>val[2] then--def_arg
                            insert(arr,obj)
                            ac=11~=obj[2] and ac+1 or ac
                        elseif 11~=obj[2] then--strict_type (val[1] - 100% exist) val[2]--already parced
                            if not(obj[2]==3 or obj[2]==7 or match(obj[1],"^nil"))then 
                                Control.error(err_text,obj[1])
                            elseif tej then 
                                Control.error(err_text,obj[1])
                            else
                                if obj[2]==3 then obj={"'"..match(obj[1],"%S+").."'",7} end
                                insert(arr,obj)
                                tej=1
                            end
                        end
                    end
                    if ac<1 then Control.error("Expected default argument after '%s'",val[2]and"="or":")end
                    ac=not tej and val[1]
                    if ac or not val[1] then remove(ac and arr or pht) insert(arr,{ac and"1"or "nil",8}) insert(arr,{",",2,pr}) end --no strict type inset nil
                    insert(arr,{val[4],3}) insert(arr,{",",2,pr})
                    insert(arr,{tostring(i),8}) insert(arr,{",",2,pr})--insert index
                end
            end
            if not obj then return end --obj works as marker that something was found
            remove(name)
            for i=#name,1,-1 do Control.inject(nil, unpack(remove(name)))end
            Control.inject(nil,"=",2,Control.Cdata.opts["="][1])
            Control.inject(nil,"def_arg",3)--TODO: replace with api function
            Control.inject(nil,"{",9)
            val=#Control.Result
            remove(arr)--remove last comma
            for i=#arr,1,-1 do --inject args ([1]="," - is coma, so not needed)
                Control.inject(nil, unpack(remove(arr)))--TODO: mark internal contents as CSSC-data for other funcs to ignore
            end
            Control.inject(nil,"}",10,val)
            Control.inject(nil,"",2,0)--zero priority -> statement_end
        end
    end,"DA_lc",1)
end},
LF={[_init]=function(Control)
	local ct,fk = t_swap{11},"function"--mk hash table
	Control.Operators["->"]=function(Control)
		local s,ei,ed,cor,br=3,Control.Cdata.tb_while(ct)--get last esenshual_index,esenshual_data
		if match(Control.Result[ei],"^%)")then--breaket located
			ei=ed[2]
			Control.log("EI:%d - %s;%s;%s;",ei,Control.Result[ei],match(Control.Result[ei],"^[=%(,]"), ei and match(Control.Result[ei],"^[=%(,]"))
			cor = ei and match(Control.Result[ei-1]or"","^[=%(,]")--coma is acceptable here
			Control.log("COR:%s",cor)
		else--default args
			while ei>0 and(ed[1]==11 or ed[1]==s or s~=3 and match(Control.Result[ei],"^%,"))do
				ei,s=ei-1,s*(ed[1]~=11 and-1 or 1)--com skip/swap state 3/2(coma)
				ed=Control.Cdata[ei]
			end
			ei,br,cor=ei+1,1,ei>0 and s~=3 and match(Control.Result[ei],"^[=%(]")
		end
		if not cor then Control.error("Corrupted lambda arguments at line %d !",Control.line)Control.split_seq(nil,2) return end
		
		Control.inject(ei,fk,4)--inject function kwrd
		if br then --place breakets
			Control.inject(ei+1,"(",9)--inject open breaket
			Control.inject(nil,")",10,ei+1)--inject closeing breaket
		end
		if"-"==sub(Control.operator,1,1)then Control.inject(nil,"return ",4) end--inject return kwrd
		Control.Level.open(fk,nil,ei)--open new function level (auto end set)
		Control.split_seq(nil,2)-- remove ->/=> from Control.operator
	end
	Control.Operators["=>"]=Control.Operators["->"]
end},
NF={[_init]=function(Control)
	local e,nan="Number '%s' isn't a valid number!",-(0/0)
	local fin_num=function(nd,c)
		--Control.log("CSSC Number format located. System: '%s'", c=='b' and 'binary' or 'octal')
		nd=concat(nd)
		local f,s,ex=match(nd,"..(%d*)%.?(%d*)(.*)")
		c=c=="b" and 2 or 8 --bin/oct
		--Control.log("Num src: F'%s' f'%s' exp'%s'",f,s,ex)
		f=tonumber(#f>0 and f or 0,c)--base
		if #s>0 then s=(tonumber(s,c)or nan)/c/#s else s=0 end--float
		ex=tonumber(#ex>0 and sub(ex,2) or 0,c)--exp
		--Control.log("Num out: F'%s' f'%s' exp'%s'",f,s,ex)
		nd =(f and s==s and ex)and ""..(f+s)*(2^ex)or Control.error(e,nd)or nd
		--insert(Control.Result,""..(f+s)*(2^ex))
		insert(Control.Result,nd)
		Control.Core(6,nd)
	end
	
	insert(Control.Struct,2,function()--this stuff must run before lua_struct and after space_handler parts.
		local c =#Control.operator<1 and match(Control.word,"^0([ob])%d")
		if c then
			local num_data,f = {},{0 ..c.."%d","Pp"}
			if Control.get_num_prt(num_data,f)then fin_num(num_data,c)return true end
			Control.Iterator()
			if Control.operator=="."then
				num_data[#num_data+1]="."
				f[1]="%d"
				Control.get_num_prt(num_data,f)
			end
			fin_num(num_data,c)
			return true
		end
	end)
end},
},--Close modules
},--Close cssc
dq_dbg={[_init]=function(Control)
	--OperatorWordSystem-debug utilite
	
	--blit control
	local rep = string.rep --rep func import
	local blit_ctrl={
	space={colors.toBlit(colors.white)," "},
	[3]={colors.toBlit(colors.white)," "},
	[4]={colors.toBlit(colors.yellow)," "},
	[2]={colors.toBlit(colors.lightBlue)," "},
	[1]={colors.toBlit(colors.lightBlue)," "},
	[11]={colors.toBlit(colors.green)," "},
	[8]={colors.toBlit(colors.cyan)," "},
	[9]={colors.toBlit(colors.white)," "},
	[10]={colors.toBlit(colors.white)," "},
	[6]={colors.toBlit(colors.lime)," "},
	[7]={colors.toBlit(colors.red)," "},
	[12]={colors.toBlit(colors.pink)," "},
	}
	Control.BlitBack={}
	Control.BlitFront={}
	local burn_blit=function(tp,len)
		tp=blit_ctrl[tp]or{" "," "}
		len=len or #Control.Result[#Control.Result]
		Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)
		Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)
	end
	
	--load base lib
	Control:load_lib"text.dual_queue.base"
	Control:load_lib"text.dual_queue.parcer"
	Control:load_lib"text.dual_queue.iterator"
	--Control:load_lib"text.dual_queue.make_react"
	Control:load_lib"text.dual_queue.space_handler"
	
	--edit space handler
	local sp_h=remove(Control.Struct)
	insert(Control.Struct,function()
		local pl=#Control.Result[#Control.Result]
		sp_h(Control)
		burn_blit("space",#Control.Result[#Control.Result]-pl)
	end)

	Control.Core=function(tp)
		local len =#Control.Result[#Control.Result]
		burn_blit(tp)
	end
	Control.Return=function()
		local rez,blit,back=concat(Control.Result).."\n",concat(Control.BlitFront).." ",concat(Control.BlitBack).." "
		rez=sub(rez,-1)=="\n"and rez or rez.."\n"
		gsub(rez,"()(.-()\n)",function(st,con,nd)
			term.blit(gsub(con,".$","\x14"),
				sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),
				sub(back,st,nd))--back color
			print()
		end)
		return Control
	end
	insert(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)
end},
dq_dbg2={[_init]=function(Control)
	--OperatorWordSystem-debug utilite
	
	--blit control
	local rep = string.rep --rep func import
	local blit_ctrl={
	space={colors.toBlit(colors.white)," "},
	[3]={colors.toBlit(colors.white)," "},
	[4]={colors.toBlit(colors.yellow)," "},
	[2]={colors.toBlit(colors.lightBlue)," "},
	[1]={colors.toBlit(colors.lightBlue)," "},
	[11]={colors.toBlit(colors.green)," "},
	[8]={colors.toBlit(colors.cyan)," "},
	[9]={colors.toBlit(colors.white)," "},
	[10]={colors.toBlit(colors.white)," "},
	[6]={colors.toBlit(colors.lime)," "},
	[7]={colors.toBlit(colors.red)," "},
	[12]={colors.toBlit(colors.pink)," "},
	}
	Control.BlitBack={}
	Control.BlitFront={}
	local burn_blit=function(tp,len)
		tp=blit_ctrl[tp]or{" "," "}
		len=len or #Control.Result[#Control.Result]
		Control.BlitFront[#Control.BlitFront+1]=rep(tp[1],len)
		Control.BlitBack[#Control.BlitBack+1]=rep(tp[2],len)
	end
	
	--load base lib
	Control:load_lib"text.dual_queue.base"
	Control:load_lib"text.dual_queue.parcer"
	Control:load_lib"text.dual_queue.iterator"
	--Control:load_lib"text.dual_queue.make_react"
	Control:load_lib"text.dual_queue.space_handler"
	Control:load_lib"common.event"
	Control:load_lib"common.level"
	
	--edit space handler
	local sp_h=remove(Control.Struct)
	insert(Control.Struct,function()
		local pl=#Control.Result[#Control.Result]
		sp_h(Control)
		burn_blit("space",#Control.Result[#Control.Result]-pl)
	end)
	--setup event system
	--Control.Event.reg("temp",function(tp)print(tp)end,nil,1)
	Control.Core=function(tp)
		local len =#Control.Result[#Control.Result]
		burn_blit(tp)
		Control.Event.run("temp",tp)
	end
	Control.Return=function()
		local rez,blit,back=concat(Control.Result).."\n",concat(Control.BlitFront).." ",concat(Control.BlitBack).." "
		rez=sub(rez,-1)=="\n"and rez or rez.."\n"
		gsub(rez,"()(.-()\n)",function(st,con,nd)
			term.blit(gsub(con,".$","\x14"),
				sub(blit,st,nd-1)..colors.toBlit(colors.lightBlue),
				sub(back,st,nd))--back color
			print()
		end)
		return Control
	end
	insert(Control.Clear,function()Control.BlitBack={}Control.BlitFront={}end)
end},
lua={[_init]=function(Control)
	Control:load_lib("code.lua.base",Control.Operators,Control.Words)
	Control:load_lib"text.dual_queue.space_handler"
	Control:load_lib"code.lua.struct"
end
,
},--Close lua
sys={[_modules]={dbg={[_init]=function(Ctrl,Value) -- V - argument
	local v=Value
	Ctrl.Finaliser.dbg=function(x,n,m)
		if v=="p"then print(concat(Ctrl.Result))end
		if m=="c"then
			Ctrl.rt=1
			return Ctrl.Result
		elseif m=="s"then
			Ctrl.rt=1
			return concat(Ctrl.Result)
		end
	end
end},
err={[_init]=function(Ctrl)
	Ctrl.Finaliser.err=function()
		if Ctrl.err then Ctrl.rt=1 return nil,Ctrl.err end
	end
end},
log={[_init]=function(Ctrl,mod,value)
	--require"cc.pretty".pretty_print(value)
	local l=Ctrl.Loaded
	l= pairs(l)(l) and insert(Ctrl.Log,"Warning: Log wasn't the first loaded module! First logs may disapear!")
	l=Ctrl.log~=placeholder_func and insert(Ctrl.Log,"Waning: Log system override! Errors may apear!")
	Ctrl.log=function(str,...) insert(Ctrl.Log,format(str,...))end
end}
,
pre={[_init]=function(Ctrl,script_id,x,name,mode,env)
	if not cssc_beta.preload then cssc_beta.preload={}end
	local P=cssc_beta.preload
	if P[script_id] then return native_load(P[script_id],name,mode,env)end
		Ctrl.Finaliser.pre=function()
		P[script_id]=concat(Ctrl.Result) 
	end
end},
},--Close modules
},--Close sys
}--END OF MODULES

end

cssc_beta={make=make,run=run,clear=clear,clear_run=clear_run,Features=Features,Modules=Modules,Configs=Confgis}
 _G.cssc_beta=cssc_beta
 _G.cssc_beta.test=read_control_string
return cssc_beta

