Lua 5.3 operator pull
     or
     and
     <     >     <=    >=    ~=    ==
     |
     ~
     &
     <<    >>
     ..
     +     -
     *     /     //    %
     unary operators (not   #     -     ~)
     ^
     
Lua5.1 operator pull
0     or
1     and
2     <     >     <=    >=    ~=    ==
3     ..
4     +     -
5     *     /     //    %
6     unary operators (not   #     -)
7     ^

Lua:
local i = 1 or 1 + 2 - 4 >> 1 + 3 and 1
local i = 1 or 1 + 2 - 4 >> 1 >> 3 and 1

CSSC:
local i = 1 or sft(1 + 2 - 4 , 1 + 3) and 1
local i = 1 or sft(sft(1 + 2 - 4 , 1), 3) and 1

priority_lvl_extractor
priority_closure_table



local i = 1 or 1 + 2 * 4 >> 1 + 3 and 1
          ^    ^   ^   ^
          0    4   5 2<X<3
                       2.5?



local i = 1 or 1 + 2 ..4 >> 1 + 3 and 1
          ^    ^   ^   ^
          0    4   3 2<X<3


local i = 1 or And(1 + 2, sft(4 , 1 + 3)) and 1
local i = 1 or 1 + 2 & 4 >> 1 + 3 and 1
      ^   ^    ^   ^   ^    ^   ^     ^
     -1   0    4   2.4 2.5  4   0    -1 --end of statement
          
statment_priority_quence 



local i = 1 or 1 + 2 ..4 >> 1 + 3 and 1


statement resetters: "=", "," ";" ""
statement_mode





current_level.stat

stat structure

1     2 3   4 5  6 7 8 9 10 11 12 13 14 15  16
local i =   1 or 1 + 2 & 4  >> 1  +  3  and 1
        ^   ^
       new  0






