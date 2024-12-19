local gmatch,insert=ENV(__ENV_GMATCH__,__ENV_INSERT__)
local seq=...
-- default text system interator
insert(C.PreRun,function()
	local s=gmatch(C.src,seq or"()([%s!-/:-@[-^{-~`]*)([%P_]*)")--default text iterator
	C.Iterator=function(m)
		if m and(#(C.operator or'')>0 or#(C.word or'')>0)then return end --blocker for main cycle (m) can be anything
		C.index,C.operator,C.word=s()
		return not C.index
	end
end)