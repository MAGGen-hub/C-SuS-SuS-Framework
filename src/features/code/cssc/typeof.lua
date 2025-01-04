local p,L,l={},ENV(__ENV_TYPE__,__ENV_GETMETATABLE__) --type,getmetatable
--typeof function used for "DA" and "IS" modules
User.typeof=function(o) return (l(o)or p).__type or L(o)end
return __RESULTABLE__,User.typeof