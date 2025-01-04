local p,L,l={},ENV(12,17) --type,getmetatable
--typeof function used for "DA" and "IS" modules
User.typeof=function(o) return (l(o)or p).__type or L(o)end
return 2,User.typeof