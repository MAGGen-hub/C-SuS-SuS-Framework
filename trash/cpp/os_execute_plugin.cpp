#include <CraftOS-PC.hpp>

//#ifdef _WIN32
//#include <windows.h>
//#endif

// works for me without that... 
//#include <chrono>
//#include <string>
//#include <cstdlib>

static PluginInfo info("os_execute");

static int execute(lua_State *L) {
    system(luaL_checkstring(L, 1));
    return 0;
}

extern "C" {
	DLLEXPORT int luaopen_os_execute(lua_State *L) {
		//fill the stack
	    lua_getglobal(L,"os");      //0 first value in stack
	    lua_pushstring(L,"execute");//1 stack 1 before top
	    lua_pushcfunction(L,execute);  //2 stack top
	    
	    //inject "system" function to _G.os table
	    lua_settable(L,-3);// INDEX = -3
	    // t[k] = v
	    // t from lua_stack:top-INDEX+1
	    // k from lua_stack:top-1
	    // v from lua_stack:top
	    
	    //clear the stack (not required, but "why not?")
	    lua_pop(L,3);
	    
	    lua_pushnil(L);// "delete" os_execute form _G (top value on the stack will try to be assigned to _G.os_execute)
	    return 1;
	}
		
	DLLEXPORT PluginInfo * plugin_init(const PluginFunctions * func, const path_t& path) { return &info; }

}
