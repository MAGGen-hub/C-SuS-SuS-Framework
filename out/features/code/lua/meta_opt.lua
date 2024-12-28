
local TS=ENV(23)local place_mark=...
local call_prew,call_nxt=TS{7,10,3},TS{7,9}local stat_end_prew,stat_end_nxt=TS{3,10,7,8,6},TS{3,4,8,6}return 2,function(prew,nxt,spifc)if call_prew[prew]and call_nxt[nxt]then
place_mark(1)elseif stat_end_prew[prew]and stat_end_nxt[nxt]or prew==4 and not spifc then
place_mark(-1)end
end