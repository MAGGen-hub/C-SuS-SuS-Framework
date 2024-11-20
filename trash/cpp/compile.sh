gcc -I /usr/include/CraftOS-PC/ ./os_execute_plugin.cpp -fPIC -shared -o ./linux/os_execute.so
x86_64-w64-mingw32-cpp -I /usr/include/CraftOS-PC/ -I /usr/include ./os_execute_plugin.cpp -fPIC -shared -o ./win/os_execute.dll
