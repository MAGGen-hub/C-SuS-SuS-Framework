local pht,ltp,lmt={},ENV(__ENV_TYPE__,__ENV_GETMETATABLE__) --type,getmetatable
--typeof function used for "DA" and "IS" modules
return __RESULTABLE__,function(obj) return (lmt(obj)or pht).__type or ltp(obj)end