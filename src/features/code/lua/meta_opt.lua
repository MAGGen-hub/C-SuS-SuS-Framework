--LUA CALL AND STAT_END (statement_separation) MARKERS
local t_swap = ENV(__ENV_T_SWAP__)
local call_prew,call_nxt,stat_end_prew,stat_end_nxt,place_mark=
-- call marker:    local a = print *call_mark* ("Hello World")
t_swap{__STRING__,__CLOSE_BREAKET__,__WORD__},t_swap{__STRING__,__OPEN_BREAKET__},
-- calculation statement marker: function() *stat_end* local *stat_end* a = v + a.b:c("s") + function()end+1 *stat_end* return *stat_end* a *stat_end* end
t_swap{__WORD__,__CLOSE_BREAKET__,__STRING__,__VALUE__,__NUMBER__},t_swap{__WORD__,__KEYWORD__,__VALUE__,__NUMBER__},...

--function to detect statements separation and function calls
return __RESULTABLE__,function(prew,nxt,spifc)--cpf -> call_prew_is_function_kwrd spf -> stat_prew_is_function_construction
    if call_prew[prew] and call_nxt[nxt] then --CALL DETECTED (or function constructor start)
        place_mark(1)
    elseif stat_end_prew[prew] and stat_end_nxt[nxt] or prew==__KEYWORD__ and not spifc then --STAT END DETECTED
        --:local a = b + function()end + 1 --valid statment!!!
        place_mark(-1)
    end
end