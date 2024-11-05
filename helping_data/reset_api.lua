STRUCT
system

( w + a - # c )
b w o w o o w b
1   5   5 9   0
          1
          
          
object struct

type   - word/breaket/operator/string/other
open   - inform compiller that this object closes the level and shows where lvl close located (if closeing symbol reached)
close  - informs compiller that this object closed the level and shows where lvl start located
ignore - this thing is marked for ignorance -> comment/space/cssc_generated and must be skipped
prior  - priority of operator (only if type == __OPERATOR__)
optp   - operator type (UNARY = 1, BINARY = 2, POSTFIX = -1)
actval - if operator was replaced by cssc -> this must return it's actual look
statnd - end of the prewious statement -> MUST GO FORWARD

functions

get_cur_lvl_seq -> returns indexes of current level op sequence
get_prior_seq   -> returns indexes of operators with priority higher than selected
previous        -> get previous type


local variable   =  var1 + varbar2.varbar1 >> 13
k     w          o  w    o w      ow       o  v

local variable   = func( var1 + varbar2.varbar1 ,  13)
k     w          o I   I w    o w      ow       o  v I

local variable   = func( var1 + varbar2.varbar1 ,  13)
k     w          o w   b w    o w      ow       o  v b
                       \_____________________________/
                         
                       
if operator:
function() *code* end    -> continue sequence
"dasdadasd"              -> continue sequence
   

keyword (exept "function")
"end" -> can't affect priority (we have no idea what is the "start" of this "end"

function -> MUST check previous value (if operator (but not ";") -> function_constructor part of the sequence and can be continued with other operator
if then else elseif for do while until repeat in -> ALWAYS RESET


struct system MUST have reset API
VALUE => 1,2,3/ ... / true|false|nil
";" -> RESET (ONLY ONE OPERATOR VS RESET)
KEYWORD (exept function) -> RESET
function -> prew val check/RESET
ANY_BREAKET/STRING   WORD/KEYWORD/VALUE/UNARY_OPERATOR -> RESET END_OF_STATEMENT
VALUE NOT_OPERATOR -> RESET
WORD OPERATOR/ANY_BREAKET/STRING -> CONTINUE ELSE RESET
OPERATOR -> ALWAYS CONTINUE
STRING ANY_BREAKET/STRING -> must check string for prewious value (must be WORD/STRING/ANY_BREAKET else RESET)



















