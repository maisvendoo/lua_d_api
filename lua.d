/*
**		$Id:lua.d, v 0.0.1	2015/01/15	01:47 by maisvendoo
**		Lua API for D language		
**		Based by Lua C API
**		For Copyright info see end of this file
*/

module	lua;

import	std.c.stdarg;
import	std.conv;

public 
{
	import	luaconf;
}

struct	lua_State{};

/*
**		Constants
*/

enum	string		LUA_VERSION_MAJOR	= "5";
enum	string		LUA_VERSION_MINOR	= "2";
enum	lua_Number	LUA_VERSION_NUM		= 502;
enum	string		LUA_VERSION_RELEASE	= "3";

enum	string		LUA_SIGNATURE		= "\033Lua";


/* option for multiple returne in 'lua_pcall' and 'lua_call' */
enum	int		LUA_MULTRET			= -1;

/* thread status */
enum	int		LUA_OK 				= 0;
enum	int		LUA_YIELD 			= 1;
enum	int		LUA_ERRRUN 			= 2;
enum	int		LUA_ERRSYNTAX		= 3;
enum	int		LUA_ERRMEM			= 4;
enum	int		LUA_ERRGCMM			= 5;
enum	int		LUA_ERRERR			= 6;

/*
**	functions that read/write blocks when loading/dumping Lua chunks
*/
alias	lua_Reader				= char* function(lua_State *L, void *ud, size_t *sz);
alias	lua_Writer				= int function(lua_State *L, const void* p, size_t sz, void* ud); 

/*
**	prototype for memory-allocation function
*/
alias	lua_Alloc				= void* function(void* ud, void* ptr, size_t osize, size_t nsize);

/*
**	basic types
*/
enum	int		LUA_TNONE			= -1;
enum	int		LUA_TNIL			= 0;
enum	int		LUA_TBOOLEAN		= 1;
enum	int		LUA_TLIGHTUSERDATA	= 2;
enum	int		LUA_TNUMBER			= 3;
enum	int		LUA_TSTRING			= 4;
enum	int		LUA_TTABLE			= 5;
enum	int		LUA_TFUNCTION		= 6;
enum	int		LUA_TUSERDATA		= 7;
enum	int		LUA_TTHREAD			= 8;

enum	int		LUA_NUMTAGS			= 9;

/* minimum Lua stack available to a C function  */
enum	int		LUA_MINSTACK		= 20;

/* predefined values int the registry */
enum	int		LUA_RIDX_MAINTHREAD	= 1;
enum	int		LUA_RIDX_GLOBALS	= 2;
enum	int		LUA_RIDX_LAST		= LUA_RIDX_GLOBALS;

/*
**	pseudo-indices
*/
enum	int		LUA_REGISTRYINDEX	= LUAI_FIRSTPSEUDOIDX;

int		lua_upvalueindex(int i)
{
	return LUA_REGISTRYINDEX - i;
}

/*
**		Extern library C functions 
**
*/
extern(C) 
{
	
	const char[] 	lua_ident;

	/*
	**	state manipulation
	*/
	lua_State		*lua_newstate(lua_Alloc f, void *ud);
	void 			lua_close(lua_State *L);
	lua_State		*lua_newthread(lua_State *L);
	lua_CFunction	lua_atpanic(lua_State *L, lua_CFunction panicf);
	lua_Number		lua_version(lua_State *L);
	
	
	/*
	**	'load' and 'call' functions (load and run Lua code)
	*/
	int				lua_callk(lua_State *L, int nargs, int nresults, int ctx, lua_CFunction k);
	
	int lua_call(lua_State *L, int nargs, int nresults)
	{
		return lua_callk(L, nargs, nresults, 0, null);
	}

	int 			lua_pcallk(lua_State *L, int nargs, int nresults, int errfunc, int ctx, lua_CFunction k);

	int				lua_getctx(lua_State *L, int *ctx);

	int lua_pcall(lua_State *L, int nargs, int nresults, int errfunc)
	{
		return lua_pcallk(L, nargs, nresults, errfunc, 0, null);
	}

	int				lua_load(lua_State *L, lua_Reader reader, void *dt, const char *chunkname, const char *mode);
	
	int				lua_dump(lua_State *L, lua_Writer writer, void *data);
	
	/*
	**	conroutine functions
	*/
	int				lua_yieldk(lua_State *L, int nresults, int ctx, lua_CFunction k);

	int lua_yield(lua_State *L, int nresults)
	{
		return lua_yieldk(L, nresults, 0, null); 
	}

	int				lua_resume(lua_State *L, lua_State *from, int narg);
	int				lua_status(lua_State *L);

	/*
	**	garbage-collection functions and options
	*/

	enum	int		LUA_GCSTOP				= 0;
	enum	int		LUA_GCRESTART			= 1;
	enum	int		LUA_GCCOLLECT			= 2;
	enum	int		LUA_GCCOUNT				= 3;
	enum	int		LUA_GCCOUNTR			= 4;
	enum	int		LUA_GCSTEP				= 5;
	enum	int		LUA_GCSETPAUSE			= 6;
	enum	int		LUA_GCSETSTEPMUL		= 7;
	enum	int		LUA_GCSETMAJORINC		= 8;
	enum	int		LUA_GCISRUNNING			= 9;
	enum	int		LUA_GCGEN				= 10;
	enum	int		LUA_GCINC				= 11;
	
	int				lua_gc(lua_State *L, int what, int data);
	
	/*
	**	miscallaneous functions
	*/
	
	int				lua_error(lua_State *L); 

	int				lua_next(lua_State *L, int idx);

	int				lua_concat(lua_State *L, int n);
	int				lua_len(lua_State *L, int idx);

	lua_Alloc		lua_getallocf(lua_State *L, int idx);
	void			lua_setallocf(lua_State *L, lua_Alloc f, void *ud);

	/*
	**	basic stack manipulation
	*/ 
	int				lua_absindex(lua_State *L, int idx);
	int 			lua_gettop(lua_State *L);
	void			lua_settop(lua_State *L, int idx);
	void			lua_pushvalue(lua_State *L, int idx);
	void			lua_remove(lua_State *L, int idx);
	void			lua_insert(lua_State *L, int idx);
	void			lua_replace(lua_State *L, int idx);
	void			lua_copy(lua_State *L, int fromidx, int toidx);
	int				lua_checkstack(lua_State *L, int sz);

	void			lua_xmove(void* from, void* to, int n);

	void lua_pop(lua_State *L, int idx)
	{
		lua_settop(L, -idx-1);
	}

	/*
	**	push functions (C -> stack)
	*/
	void			lua_pushnil(lua_State *L);
	void			lua_pushnumber(lua_State *L, lua_Number n);
	void			lua_pushinteger(lua_State *L, lua_Integer n);
	void			lua_pushunsigned(lua_State *L, lua_Unsigned n);
	char*			lua_pushlstring(lua_State *L, const char* s, size_t l);
	char*			lua_pushstring(lua_State *L, const char* s);
	char*			lua_pushvfstring(lua_State *L, const char* fmt, va_list argp);
	
	char*			lua_pushfstring(lua_State *L, const char* fmt, ...);
	void			lua_pushcclosure(lua_State *L, lua_CFunction fn, int n);
	void			lua_pushboolean(lua_State *L, int b);
	void			lua_pushlightuserdata(lua_State *L, void* p);
	int				lua_pushthread(lua_State *L);

	/*
	**	get functions (Lua -> stack)
	*/
	void 			lua_getglobal(lua_State *L, const char* var);
	void			lua_gettable(lua_State *L, int idx);
	void			lua_getfield(lua_State *L, int idx, const char* k);
	void			lua_rawget(lua_State *L, int idx);
	void			lua_rawgeti(lua_State *L, int idx, int n);
	void			lua_rawgetp(lua_State *L, int idx, void* p);
	void			lua_createtable(lua_State *L, int narr, int nrec);
	void*			lua_newuserdata(lua_State *L, size_t sz);
	int				lua_getmetatable(lua_State *L, int objindex);
	void			lua_getuservalue(lua_State *L, int idx); 

	/*
	**	set functions (stack -> Lua)
	*/
	void			lua_setglobal(lua_State *L, const char* var);
	void			lua_settable(lua_State *L, int idx);
	void			lua_setfield(lua_State *L, int idx, const char* k);
	void			lua_rawset(lua_State *L, int idx);
	void			lua_rawseti(lua_State *L, int idx, int n);
	void			lua_rawsetp(lua_State *L, int idx, void* p);
	int				lua_setmetatable(lua_State *L, int objindex);
	void			lua_setuservalue(lua_State *L, int idx); 

	/*
	**	access functions (stack -> C)
	*/

	int				lua_isnumber(lua_State *L, int idx);
	int				lua_isstring(lua_State *L, int idx);
	int 			lua_iscfunction(lua_State *L, int idx);
	int				lua_isuserdata(lua_State *L, int idx);

	int				lua_istable(lua_State *L, int idx)
	{
		return (lua_type(L, idx) == LUA_TTABLE);
	}

	int				lua_isnil(lua_State *L, int idx)
	{
		return (lua_type(L, idx) == LUA_TNIL);
	}

	int				lua_type(lua_State *L, int idx);
	char*			lua_typename(lua_State *L, int tp);

	lua_Number		lua_tonumberx(lua_State *L, int idx, int *isnum);
	lua_Integer		lua_tointegerx(lua_State *L, int idx, int *isnum);
	lua_Unsigned	lua_tounsignedx(lua_State *L, int idx, int *isnum);
	int				lua_toboolean(lua_State *L, int idx);
	char*			lua_tolstring(lua_State *L, int idx, size_t *len);
	size_t			lua_rawlen(lua_State *L, int idx);
	lua_CFunction	lua_tocfunction(lua_State *L, int idx);
	void*			lua_touserdata(lua_State *L, int idx);
	lua_State		*lua_tothread(lua_State *L, int idx);
	void*			lua_topointer(lua_State *L, int idx);

	lua_Number	lua_tonumber(lua_State *L, int idx)
	{
		return lua_tonumberx(L, idx, null);
	}

	lua_Integer lua_tointeger(lua_State *L, int idx)
	{
		return lua_tointegerx(L, idx, null);
	}

	lua_Unsigned lua_tounsigned(lua_State *L, int idx)
	{
		return lua_tounsignedx(L, idx, null);
	}

	string lua_tostring(lua_State *L, int idx)
	{
		return to!string(lua_tolstring(L, idx, null));
	}

	/*
	**	Comparison and arithmetic functions
	*/
	enum	int		LUA_OPADD		= 0;
	enum	int		LUA_OPSUB		= 1;
	enum	int		LUA_OPMUL		= 2;
	enum	int		LUA_OPDIV		= 3;
	enum	int		LUA_OPMOD		= 4;
	enum	int		LUA_OPPOW		= 5;
	enum	int		LUA_OPUNM		= 6;

	int				lua_arith(lua_State *L, int op);

	enum	int		LUA_OPEQ		= 0;
	enum	int		LUA_OPLT		= 1;
	enum	int		LUA_OPLE		= 2;

	int				lua_rawequal(lua_State *L, int idx1, int idx2);
	int				lua_compare(lua_State *L, int idx1, int idx2, int op);

	/*
	** {=============================================================
	**	Debug API
	** =============================================================}
	*/

	/*
	**	Event codes
	*/
	enum	int		LUA_HOOKCALL		= 0;
	enum	int		LUA_HOOKRET			= 1;
	enum	int		LUA_HOOKLINE		= 2;
	enum	int		LUA_HOOKCOUNT		= 3;
	enum	int		LUA_HOOKTAILCALL	= 4;

	/*
	**	Event masks
	*/
	enum	int		LUA_MASKCALL		= (1 << LUA_HOOKCALL);
	enum	int		LUA_MASKRET			= (1 << LUA_HOOKRET);
	enum	int		LUA_MASKLINE		= (1 << LUA_HOOKLINE);
	enum	int		LUA_MASKCOUNT		= (1 << LUA_HOOKCOUNT);

	struct	CallInfo
	{

	}

	/* activation record */
	struct	lua_Debug
	{
		int 				event;
		char 				*name;
		char				*namewhat;
		char				*what;
		char				*source;
		int					currentline;
		int					linedefined;
		int					lastlinedefined;
		ubyte				nups;
		ubyte				nparams;
		char				isvararg;
		char				istailcall;
		char[LUA_IDSIZE]	short_src;
		CallInfo 			*i_ci;
	}

	alias lua_Hook = void function(lua_State *L, lua_Debug *ar);

	int				lua_getstack(lua_State *L, int level, lua_Debug *ar);
	int				lua_getinfo(lua_State *L, const char *what, lua_Debug *ar);
	char*			lua_getlocal(lua_State *L, const lua_Debug *ar, int n);
	char*			lua_setlocal(lua_State *L, const lua_Debug *ar, int n);
	char*			lua_getupvalue(lua_State *L, int funcindex, int n);
	char*			lua_setupvalue(lua_State *L, int funcindex, int n);

	void*			lua_upvalueid(lua_State *L, int fidx, int n);
	void			lua_upvaluejoin(lua_State *L, int fidx1, int n1, int fidx2, int n2);

	int				lua_sethook(lua_State *L, lua_Hook func, int mask, int count);
	lua_Hook		lua_gethook(lua_State *L);
	int				lua_gethookmask(lua_State *L);
	int				lua_gethookcount(lua_State *L);

	/* }========================================================== */
}
	/******************************************************************************
	/
	/	Ported to D language by Dmitry Pritykin (maisvendoo)
	/	Russia, Rostov-on-Don, 2015/01/16
	/
	/*****************************************************************************/

	/******************************************************************************
	* Copyright (C) 1994-2013 Lua.org, PUC-Rio.
	*
	* Permission is hereby granted, free of charge, to any person obtaining
	* a copy of this software and associated documentation files (the
	* "Software"), to deal in the Software without restriction, including
	* without limitation the rights to use, copy, modify, merge, publish,
	* distribute, sublicense, and/or sell copies of the Software, and to
	* permit persons to whom the Software is furnished to do so, subject to
	* the following conditions:
	*
	* The above copyright notice and this permission notice shall be
	* included in all copies or substantial portions of the Software.
	*
	* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	******************************************************************************/
