--ARG CHECK FUNC
local arg_check=function(Control)
	if(getmetatable(Control)or{}).__type~="cssf_unit"then 
		error(format("Bad argument #1 (expected cssf_unit, got %s)",type(Control)),3)
	end 
end
--TAB RUN helping function to execute all funcs in table
local tab_run=function(Control,t,b)for k,v in pairs(Control[t])do if v(Control)and b then break end end end
--LOCALS
local _arg,load_lib,load_libs,clear,run,read_control_string,load_control_string={'arg'},--constrol_string_arg_accessor
function(Control,l_path,...)--arg_check(Control)--LOAD_LIB function
	local l_loaded,l_arg,rez_tp=Control.Loaded[">"..l_path],{}
	if false~=l_loaded then--__SINGLECALL__ -> default mode
		Control.log("Load %s",">"..l_path)--log func loading
		if l_loaded and"function"==type(l_loaded)then l_arg={l_loaded(...)} remove(l_arg,1)return unpack(l_arg)end--__RECALLABLE__ mode
		if l_loaded and"table"==type(l_loaded)then return unpack(l_loaded)end--__RESULTABLE__ mode
		--FIRST LOAD or __RELOADABLE__ mode
		local r,e=native_loadfile(base_path.."features/"..gsub(l_path,"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))
		e=e and error("Lib ["..l_path.."]:"..e)
		l_arg={r(...)}
		rez_tp=remove(l_arg,1)or false --if no return -> __SINGLECALL__ mode (only one launch allowed)
		Control.Loaded[">"..l_path]=__RESULTABLE__==rez_tp and l_arg or (rez_tp==__RECALLABLE__) and r or rez_tp--setup reaction to future call(deny_lib_load/recal/return_old_rez)
	end
	return unpack(l_arg)--__FIRST LOAD return
end
do --advanced lib loader (cursed a litle, but useful)
	local m m = {
		__index=function(s,p)insert(s.p,p)return s end,--
		__call=function(s,l,...)
			if s==m then return setmetatable({r={},p={l},C=...},m) end--constructor
			if type(l)=="string"then insert(s.r,{load_lib(s.C,concat(s.p,".").."."..l,...)}) return s end --loader
			if type(l)=="number" then local r,i = {},1
				for _,v in pairs{l,...}do for _,v1 in pairs(s.r[v]or{(v<0 and s)or(v<1 and s.r)or nil})do r[i]=v1 i=i+1 end end
				return unpack(r) --return results 
			end 
			remove(s.p)
			return s
		end
	}
	load_libs=function(Control,l_path)local s=m.__call(m,l_path,Control) return s end
end

clear=function(Obj)arg_check(Obj)tab_run(Obj.data,"Clear")end--clear

run=function(Obj,x,...)arg_check(Obj)
	local Control=Obj.data
	tab_run(Control,"Clear")
	Control.src=x
	Control.args={...}
	
	tab_run(Control,"PreRun")--PRE RUN

	while not Control.Iterator(__MAIN_CYCLE__)do tab_run(Control,"Struct",1)end--COMPILE

	tab_run(Control,"PostRun")--POST RUN

	local e=type(Control.Return)--FINISH COMPILE
	if"function"==e then
		return Control.Return()
	elseif"table"==e then
		return unpack(Control.Return)
	else
		return Control.Return
	end
end



--CONTROL STRING READER
read_control_string=function(s,C)--RECURSIVE FUNC: turn control string into table and load configs
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
	e=C[t and e or s]
	t=1
	for k,v in pairs(e and read_control_string(e,C)or{})do --read config
		if"number"==type(k)then insert(l,t,v) t=t+1 else l[k]=v end
	end
	return l,a
end


--CONTROL STRING LOADER
load_control_string=function(Control,main,subm,l_path,cur_aliases)--RECURSIVE FUNC: load readed control string and fill Control table with contents of loaded modules
	local path_prt,l_mod,e,aliases --part of ctrl string; module func; error ; shotcuts/aliases 
	if l_path then--LOAD MODULE
		path_prt=remove(main,1)
		l_path=l_path..((cur_aliases or{})[path_prt] or path_prt)--apply aliases if exists 
		--try_load mofule from file
		l_mod,e=native_loadfile(base_path.."modules/"..gsub(sub(l_path,2),"%.","/")..".lua",nil,setmetatable({C=Control,Control=Control,ENV=env_load,_G=_G,_E=_ENV},{__index=Control}))
		e=e and error(format('Error loading module "%s": %s',l_path,e),4)
		--try_run module from <l_mod>
		Control.Loaded[l_path],e=pcall(function()
			if Control.Loaded[l_path]then return end --prevent double load
			Control.log("Load %s",l_path)
			aliases=(l_mod or placeholder_func)(l_path,main[_arg][path_prt])--run module initializer and push args if exists
		end)
		e=e and error(format('Error loading module "%s": %s',l_path,e),4)

	else --INIT LOADER
		l_mod=__TRUE__
		subm=main
		main={}
	end

	--if core module exist
	if l_mod and aliases~=__TRUE__ then  --load sub_modules if exist
		l_path=l_path and l_path.."."or"@"
		if #main>0 then load_control_string(Control,main,subm,l_path,aliases)
		else for k,v in pairs(subm or{})do
			e=e or"string"==type(v)--set correct loading mode (depends on ctrl string view)
			v=e and{v}or v
			v="number"==type(k)and{v}or{k,v}
			load_control_string(Control,v[1],v[2],l_path,aliases)
		end end
	end
end

-- Configs for C SuS SuS Programming Language.
-- cssc_basic -> stable & compy, just a few new features, common for other programming languages.
-- cssc_user  -> recomended configuration, still stable & comfy, contains more freatures, but can be a bit "tricky" to use.
-- cssc_full  -> all inclusive mode, experimental & cursed & unstable but very fun XD.
-- usage:
--     requre("cssc_lib_name")"config=cssc_*type*"

__PROJECT_NAME__=setmetatable({Configs={
cssc_basic="sys.err,cssc={NF,KS,BO,CA,ncbf}",--configs
cssc_user="sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}",
cssc_full="sys.err,cssc={NF,KS(ret,loc,sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}",
lua_53="sys.err,cssc={BO,ncbf}"},
creator="M.A.G.Gen.",version='__VERSION__'},
{	--PROJECT MAKER
	__type="cssf",
	__name="cssf",
	__call=function(S,l_ctrl_str)
		if"string"~=type(l_ctrl_str)then error(format("Bad argument #2 (expected string, got %s)",type(l_ctrl_str)))end--ARG CHECK

		--INITIALISE PREPROCESSOR OBJECT
		local i,Control,Obj,r=1
		r={__call=function(S,s,...)
			if#S>999 then remove(S,1)end
			insert(S,format("%-16s : "..s,format("[%0.3d] [%s]",i,S._),...))
			i=i+1
		end}

		--PROCESSING OBJECT
		Control={
			--MAIN FUNCTIONS
			load_lib=load_lib,load_libs=load_libs,--clear=clear,continue=continue,ctrl=ctrl_str,
			--MAIN OBJECTS TO WORK WITH
			PostLoad={},PreRun={},PostRun={},Struct={},Loaded={},Clear={},Result={},
			--SYSTEM PLACEHOLDERS
			error=setmetatable({_=" Error "},r),--send error msg TODO:Rework
			log=setmetatable({_="  Log  "},r),  --send log msg
			warn=setmetatable({_="Warning"},r), --send warning msg
			Core=placeholder_func,
			Iterator=native_load"return 1",}
		
		--USER ACCESS OBJECT
		Obj=setmetatable({run=run,info="C SuS SuS Framework"},{__type="cssf_unit",__name="cssf_unit",__index={data=Control}})
		Control.User=Obj--link to user accessable object (Control Parent)
		
		load_control_string(Control,read_control_string(l_ctrl_str,S.Configs))--CONTROL STRING LOAD AND PARCE
		--POST LOAD
		tab_run(Control,"PostLoad")
		return Obj
	end}
)
@@DEBUG _G.__PROJECT_NAME__=__PROJECT_NAME__
return __PROJECT_NAME__
