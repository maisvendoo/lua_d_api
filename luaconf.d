/*
**	$Id: luaconf.d, v 0.0.1, 2015/01/16 by maisvendoo
**	For Copyright info see end of lua.d file
*/
module	luaconf;

import	std.c.stdio;
import	lua;

enum	int		LUA_IDSIZE			= 60;

enum	int		LUAL_BUFFERSIZE		= BUFSIZ;

enum	int		LUAI_MAXSTACK		= 1000000;

enum	int		LUAI_FIRSTPSEUDOIDX	= (-LUAI_MAXSTACK - 1000);


alias	lua_Number 					= double;
alias	lua_Integer 				= ptrdiff_t;
alias	lua_Unsigned 				= uint;

alias	lua_CFunction 				= int function(lua_State *L);
