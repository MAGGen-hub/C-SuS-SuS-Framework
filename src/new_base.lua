--ARG CHECK FUNC
local arg_check=function(Control)
	if(getmetatable(Control)or{}).__type~="cssc_unit"then 
		error(format("Bad argument #1 (expected cssc_unit, got %s)",type(Control)),3)
	end 
end
--LOCALS
local Configs,_arg,load_lib,continue,clear,make,run,read_control_string,load_control_string=
{cssc_basic="sys.err,cssc={NF,KS,LF,BO,CA}",--configs
 cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS}",
 cssc_full="sys.err,cssc={NF,KS(sc_end,pl_cond),LF,DA,BO,CA,NC,IS}"},
{'arg'},--constrol_string_arg_accessor
function(Control,path,...)arg_check(Control)--LOAD_LIB function TODO:REWORK
	local ld,arg,tp=Control.Loaded[">"..path],{}
	if false~=ld then
		Control.log("Load %s",">"..path)
		if ld and ld~=__RECALLABLE__ then return unpack(ld)end--return previous result (__RESULTABLE__ mode)
		--arg={native_load("return "..path.."(...)","Feature Loader",nil,Features)(Control,...)}
		local r,e=native_loadfile(base_path.."features/"..gsub(path,"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))
		e=e and error("Lib ["..path.."]:"..e.."; "..base_path.."features/"..path..".lua")--error(format('Error loading libruary "%s": %s',path,e))
		arg={r(...)}
		tp=remove(arg,1)or false --if no return -> default mode (only one launch allowed)
		Control.Loaded[">"..path]=__RESULTABLE__==tp and arg or tp--setup reaction to future call(deny_lib_load/recal/return_old_rez)
	end
	return unpack(arg)
end,
function(Control,x,...)arg_check(Control)--continue
	Control.src=x
	Control.args={...}
	
	Control:tab_run"PreRun"--PRE RUN
	
	while not Control.Iterator(__MAIN_CYCLE__)do Control:tab_run("Struct",1)end--COMPILE

	Control:tab_run"PostRun"--POST RUN

	local e=type(Control.Return)--FINISH COMPILE
	if"function"==e then
		return Control.Return()
	elseif"table"==e then
		return unpack(Control.Return)
	else
		return Control.Return
	end
end,
function(Control)arg_check(Control)Control:tab_run"Clear"end--clear

run=function(Control,x,...)arg_check(Control)
	Control:clear()return Control:continue(x,...)
end

make=function(ctrl_str)
	if"string"~=type(ctrl_str)then error(format("Bad argument #2 (expected string, got %s)",type(ctrl_str)))end--ARG CHECK

	--INITIALISE PREPROCESSOR OBJECT
	local m,i,Control,r={__type="cssc_unit",__name="cssc_unit"},1
	r={__call=function(S,s,...)if#S>999 then remove(S,1)end insert(S,format("%-16s : "..s,format("[%0.3d] [%s]",i,S._),...)) i=i+1 end}
	Control=setmetatable({
		--MAIN FUNCTIONS
		ctrl=ctrl_str,run=run,clear=clear,continue=continue,load_lib=load_lib,
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
	
	load_control_string(Control,read_control_string(ctrl_str))--CONTROL STRING LOAD AND PARCE
	--POST LOAD
	Control:tab_run"PostLoad"
	return Control
end

--CONTROL STRING READER
read_control_string=function(s)--RECURSIVE FUNC: turn control string into table and load configs
	local c,t,l,e,m={"config",[_arg]={}}--config and arg marks!
	m={__index=function(s,i)s=s==c and setmetatable({c[1],[_arg]={}},m)or s s[#s+1]=i return s end,
		__call=function(s,...)
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
	for k,v in pairs(e and read_control_string(e)or{})do --read config
		if"number"==type(k)then insert(l,t,v) t=t+1 else l[k]=v end
	end
	return l,a
end


--CONTROL STRING LOADER
load_control_string=function(Control,main,subm,path,cur_sc)--RECURSIVE FUNC: load readed control string and fill Control table with contents of loaded modules
	local prt,mod,e,sc --part of ctrl string; module func; error ; shotcuts/aliases 
	if path then--LOAD MODULE
		prt=remove(main,1)
		path=path..((cur_sc or{})[prt] or prt)--apply aliases if exists 
		--try_load mofule from file
		mod,e=native_loadfile(base_path.."modules/"..gsub(sub(path,2),"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))
		e=e and error(format('Error loading module "%s": %s',path,e),4)
		--try_run module from <mod>
		Control.Loaded[path],e=pcall(function()
			if Control.Loaded[path]then return end --prevent double load
			Control.log("Load %s",path)
			sc=(mod or placeholder_func)(path,main[_arg][prt])--run module initializer and push args if exists
		end)
		e=e and error(format('Error loading module "%s": %s',path,e),4)

	else --INIT LOADER
		mod=__TRUE__
		subm=main
		main={}
	end

	--if core module exist
	if mod and sc~=__TRUE__ then  --load sub_modules if exist
		path=path and path.."."or"@"
		if #main>0 then load_control_string(Control,main,subm,path,sc)
		else for k,v in pairs(subm or{})do
			e=e or"string"==type(v)--set correct loading mode (depends on ctrl string view)
			v=e and{v}or v
			v="number"==type(k)and{v}or{k,v}
			load_control_string(Control,v[1],v[2],path,sc)
		end end
	end
end

__PROJECT_NAME__={make=make,Configs=Configs,creator="M.A.G.Gen.",version="4.5-beta"}
@@DEBUG __PROJECT_NAME__.continue=continue --curently in testing 
@@DEBUG _G.__PROJECT_NAME__=__PROJECT_NAME__
return __PROJECT_NAME__
