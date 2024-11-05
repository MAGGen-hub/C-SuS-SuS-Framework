

-- prioritized wrap
-- function that wraps part of the statement into binary argument function (sets ups breaket closure alrorithm)
-- params: func="lsh" priority=LSH_PRIOR close_momentaly_with=nil
-- source: local a = 1 + 3 and     6 * 8 >> 1 + 4  and 1
-- result: local a = a + 3 and lsh(6 * 8 ,  1 + 4) and 1
-- params: func="nilF" priority=CALL_INDEX close_momentaly_with="."
-- source: local a = table?.concat
-- result: local a = nilF(table).concal
function prioritized_func_wrap(func,priority,close_momentaly_with) -- third parameter equal to nil by default

function enable_breaket_closure