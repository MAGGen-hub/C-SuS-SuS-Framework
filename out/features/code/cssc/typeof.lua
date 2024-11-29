local pht,ltp,lmt={},ENV(13,18) --type,getmetatable
--typeof function used for "DA" and "IS" modules
return 2,function(obj) return (lmt(obj)or pht).__type or ltp(obj)end