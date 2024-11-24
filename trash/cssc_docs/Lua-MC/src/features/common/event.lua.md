API система событий.
Особая система позволяющая регистрировать реакции на события и вызывать их при необходимости.
Функции:
reg(name,func,id,gl) - регистрирует реакцию на событие
- name - имя события
- func - функция реакции срабатывающая при вызове события
- id - номер реакции в списке регулирующий порядок её исполнения
- gl - глобальное событие, остается в системе даже после отчистки данных

run(name, ...) - запуск события
- name - имя события 
- ... - аргументы события (передаются в функцию события "как есть")