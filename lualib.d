/*
**	$Id: lualib.d, v 0.0.1 2015/01/15 22:11 by maisvendoo
**	Lua standard libraries
**	For Copyright info see end of lua.d file
*/

module	lualib;

import	lua;

enum	string	LUA_COLIBMANE		= "coroutine";
enum	string	LUA_TABLIBNAME		= "table";
enum	string	LUA_IOLIBNAME		= "io";
enum	string	LUA_OSLIBNAME		= "os";
enum	string	LUA_STRLIBNAME		= "string";
enum	string	LUA_BITLIBNAME		= "bit32";
enum	string	LUA_MATHLIBNAME		= "math";
enum	string	LUA_DBLIBNAME		= "debug";
enum	string	LUA_LOADLIBNAME		= "package";

extern(C)
{
	
	int		luaopen_base(lua_State *L);
	int		luaopen_coroutine(lua_State *L);
	int		luaopen_table(lua_State *L);
	int		luaopen_io(lua_State *L);
	int		luaopen_os(lua_State *L);
	int		luaopen_string(lua_State *L);
	int		luaopen_bit32(lua_State *L);
	int		luaopen_math(lua_State *L);
	int		luaopen_debug(lua_State *L);
	int		luaopen_package(lua_State *L);

	/* open all previous libraries */
	void	luaL_openlibs(lua_State *L);
}

