local A,E,S,T,F,__PROJECT_NAME__,Kb,Ki,Ks=assert,"__PROJECT_NAME__ load failed because of missing libruary method!",string,table,{},{},{},{},"if function for while repeat elseif else do then end until local return in break "
local SM,Sm,SF,Sf,SS,Ss,Ti,Tc,Tr,Tu,Mf,Gt,Gp,Ge,Gr,Gg,Gs,Gb,pf,NL=A(S.gmatch,E),A(S.match,E),A(S.format,E),A(S.find,E),A(S.gsub,E),A(S.sub,E),A(T.insert,E),A(T.concat,E),A(T.remove,E),A(unpack,E),A(math.floor,E),A(type,E),A(pairs,E),A(error,E),A(tostring,E),A(getmetatable,E),A(setmetatable,E),bit32 or pcall(require,"bit32")and require"bit32"or print"Warning! Bit32 libruary not found! Bitwize operators module disabled!"and nil,function()end
if Gb then
T={}for k,v in Gp(Gb)do T[k]=v end
T.shl,T.shr,T.lshift,T.bshift=T.lshift,T.bshift
Gb=T
end
do
local Lt,Ll,Ls=A(loadstring,E),A(load,E),A(setfenv,E)
NL=function(x,name,mode,env)local r,e=(Gt(x)=="string"and Lt or Ll)(x,name)if env and r then Ls(r,env)end return r,e end
end
SS(Ks,"(%S+)( )",function(w,s)Kb[#Kb+1]=s..w..s Ki[w]=#Kb end)
A,E,S,T=nil