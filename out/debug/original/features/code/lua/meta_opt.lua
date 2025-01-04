--LUA CALL AND STAT_END (statement_separation) MARKERS
local t_swap = ENV(23)
local call_prew,call_nxt,stat_end_prew,stat_end_nxt,place_mark=
-- call marker:    local a = print *call_mark* ("Hello World")
t_swap{7,10,3},t_swap{7,9},
-- calculation statement marker: function() *stat_end* local *stat_end* a = v + a.b:c("s") + function()end+1 *stat_end* return *stat_end* a *stat_end* end
t_swap{3,10,7,8,6},t_swap{3,4,8,6},...

--function to detect statements separation and function calls
return 2,function(prew,nxt,spifc)--cpf -> call_prew_is_function_kwrd spf -> stat_prew_is_function_construction
    if call_prew[prew] and call_nxt[nxt] then --CALL DETECTED (or function constructor start)
        place_mark(1)
    elseif stat_end_prew[prew] and stat_end_nxt[nxt] or prew==4 and not spifc then --STAT END DETECTED
        --:local a = b + function()end + 1 --valid statment!!!
        place_mark(-1)
    end
end