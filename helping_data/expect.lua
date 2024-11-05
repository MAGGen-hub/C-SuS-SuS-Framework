EXPECT

type:name
desc: single word

type:name_list
desc: name,name,name,...

new_stat:
1: var
2: stat_keyword (local,if,for,while,repeat,goto,

src: local
exp: name_lst
exp: 'new_stat' or '='


assignment
var_list '=' expression_list


chunk   block
		{stat}

name_list -> var_list -> exp_list

require_change


Statements

Asignment
{var_list} '=' {exp_list}

Lambda
{name_list} '->' block 'end'

Index
[value]

value -> 