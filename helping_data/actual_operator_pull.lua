     op_resert_space      ;
     ,
     = 
     or
     and
     <     >     <=    >=    ~=    ==
     ..
     +     -
     *     /     //    %
     unary operators (not   #     -)
     ^
     index(.     :     [val]) call( val() val"" val{} ) 
--Lua5.1 Original operator priority table


local a = 1 local i = 0 + 1 + table.aaa()
^     ^   ^ ^     ^   ^   ^   ^     ^
1     2   1 1     2   7   7   11    11

унарный оператор обозначает стартом объекта сам себя
local a = 1 local i. a = 0 + # "" + table.aaa()
^     ^   ^ ^     ^  ^   ^   ^ ^    ^     ^
1     2   1 1     11 2   7   9 7    11    11


local a = 1 local i. a = 0 + 1 + table.aaa()
^     ^   ^ ^     ^  ^   ^   ^   ^     ^
1     2   1 1     11 2   7   7   11    11

unary experiment
local a = 1 local i. a = 0 + 1$# "" + table.aaa(  )  .aaaa
^     ^   ^ ^     ^  ^   ^   ^ ^ ^    ^     ^         ^
1     2   1 1     11 2   7   9 9 7    11    11        11

local a = 1 local i. a = 0 + 1 $# "" + table.aaa(  )  .aaaa  --[|->end
1     3 3 1 1     11 3 3 8 8 1 10 8  8 12   12  12 12 12
                   11           10           12        1

local a = 1 local i. a = 0 + 1 $# "" + table.aaa(  )  .aaaa  --[|->end
1     1 3 3 1     1  11  3 8 8 1  10 8 8    12  12 12 12
                   11  3        10           12        12
                   

local i = 1 or And(a.b + 2, sft(4 , 1 + 3)) and 1
local i = 1 or a.b + 2 & 4 >> 1 + 3 and 1
1     1 3 3 4   11  8 8 6.5 6.6 8 8 5   5
               4 11      6.5  6.6
local i = shr(shr(1,1),1)       
local i = 1 << 1 << 1  (<< -> 6.6)
        3   6.6  6.6

local i = 1 or a.b + 2 & 4 >> 1 + 3 and 1
        3   4   11 8   6.5 6.6  8   5

local i = ("" + )               
1     1 3 3   
           1
    
local i = And(1,shr(1,1))       
local i = 1 & 1 << 1  (<< -> 6.6)
1     1 3 3 6.5 6.6
              6.5  6.6

local i = And(#1,shr(1,1))       
local i = 1 or #1  & 1 << 1  (<< -> 6.6)
1     1 3 3 4  10  6.5 6.6
                10   6.5  6.6


local i = And(#1,shr(1,1))       
local i = ##1  & 1 << 1  (<< -> 6.6)
1     1 3 3 10 6.5 6.6
           10    6.5  6.6

local i = #dol(""^2)+1
local i = #$""^2  +  1 word
1     1 3 10  11  8  8 1
           10  11

local i = #dol("")^2+1
local i = #$""^2  +  1 word
1     1 3 10  11  8  8 1
           12  11

local i = #dol(""^2+1)
local i = #$""^2  +  1 word
1     1 3 10  11  8  8 1
           7   11

local i = #dol(""^2)+1
local i = #$""^(2  +  1) word
1     1 3 10  11       12
           10  12        1

priority resset -> __NOT_OPERATOR__ -> __WORD__ or __KEYWORD__ or __NUMBER__
                   __WORD__
                   __KEYWORD__
                   __STRUCT__ (not comment)
                   __NUMBER__

before_insert -> вствляет скобу с названием функции перед itemom с приоритетом ниже(НЕ РАВНЫМ!!!) требуемого  (в случае с And -> это литерал "a" с приоритетом 4)
after_insert -> вставляет завершающую скобу сразу перед itemom с приоритетом ниже требуемого (в случае с And и sft это литерал "and" c приоритетом 5)

методы нахождения сиуаций (псевдо алгортимы)

старт_текущего_объекта
     последний_приоритет=взять_последний_приоритет_в_выражении()
     предпоследний_приоритет=взять_предпоследний_приоритет_в_выражении()
     ЕСЛИ предпоследний_приоритет существует и сравним с наивысшим (в данной ситуации 11)
     	 ТО идти к началу до тех пор пока строка приоритета не законциться либо следующий по ней приоритет не будет ниже 11 -- это и есть старт объекта
     	 ИНАЧЕ координата последний_приоритета равна старту объекта

структура очереди (стека) приоритетов
stat = { [1] = (нуль-старт)
...
[n] = (приоритет_оператора_перед_объектом, индекс_объекта_в_результирующей_таблице, третий параметер существует только если оператор унарный)
}

нулевые ситуации -> те случае когда проритет оператора равен нулю -> то есть оператора НЕТ
wnkw = word/number or keyword
str = string :: 'str' "str" [=n=[]=n=] 
1. wnkw wnkw
2. ]    wnkw
3. }    wnkw
4. )    wnkw
5. str  wnkw
6. 

any -> anything exept keyword
resets:
  op   keyword (not function)
  word word
  str  word
  ]    word
  )    word
  }    word
  num  word
  num  [
  num  (
  num  {
  num  str
  ...  word
  ...  [
  ...  (
  ...  {
  ...  str
continues:


default lua statement behaviour: open-breaket, string -> continues statement
	word, string, close_br,
resetting behaviour:
	keyword,number,var_arg,boolean,nill
	

__VALUE__ = {__NUMBER__,__VARARG__,__BOOLEAN__,__NIL__,__KEYWORD__} --cant be called or continued
__STATE_PART__= {__WORD__,__STRING__,} --__TABLE__,__RD_BREAKET__,__IDX__} --can be called or continued with '.'

*nil* b.a""?.ccc.vvv
1     \11  11   11

local i = 1 + function() end + 1
        3   8                8
