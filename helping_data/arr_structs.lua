level_hash:--REWORK! (DO problem)
    {
        [1] = {[level_end]=true}, --supported/expected level ends if token opens level 
        [2] = true, --marker -> token closes the level.
        --TODO:
        [3] = false, --makrer [can be standalone?] -> if true closing prewious level is optional
    }
opts_hash:--REWORK!
{
    [1] = base_priority, --base binary operator priority
    [2] = unary_priority,--unary_operator priority (if binary not exist == -1)
}
kwrd_hash:
{
    [keyword]=true, -- this keyword is exist in language
}