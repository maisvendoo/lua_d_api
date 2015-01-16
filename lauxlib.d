/*
**	$Id: lauxlib, v 0.0.1 2015/01/15 by maisvendoo
**	Auxiliary functions for building Lua libraries
**	For Copyright info see end of lua.d file
*/

module	lauxlib;

import	std.c.stdio;
import	lua;

/* extra error code for 'lauL_load' */
enum	int	LUA_ERRFILE 	= (LUA_ERRERR + 1);

struct	luaL_Reg
{
	char*			name;
	lua_CFunction	func;
}

extern(C)
{
	void 		luaL_checkversion_(lua_State *L, lua_Number ver);

	void	luaL_checkversion(lua_State *L)
	{
		luaL_checkversion_(L, LUA_VERSION_NUM);
	}

	int				luaL_getmetafield(lua_State *L, int obj, const char *e);
	int				luaL_callmeta(lua_State *L, int obj, const char	*e);
	char*			luaL_tolstring(lua_State *L, int idx, size_t *len);
	int				luaL_argerror(lua_State *L, int numarg, const char *extramsg);
	char*			luaL_checklstring(lua_State *L, int numArg, size_t *l);

	char*			luaL_optlstring(lua_State *L, int numArg, const char *def, size_t *l);

	lua_Number		luaL_checknumber(lua_State *L, int numArg);
	lua_Number		luaL_optnumber(lua_State *L, int nArg, lua_Number def);

	lua_Integer		luaL_checkinteger(lua_State *L, int numArg);
	lua_Integer		luaL_optinteger(lua_State *L, int nArg, lua_Integer def);
	
	lua_Unsigned	luaL_checkunsigned(lua_State *L, int numArg);
	lua_Unsigned	luaL_optunsigned(lua_State *L, int nArg, lua_Unsigned def);

	void			luaL_checkstack(lua_State *L, int sz, const char *msg);
	void			luaL_checktype(lua_State *L, int narg, int t);
	void			luaL_checkany(lua_State *L, int narg);

	int   			luaL_newmetatable(lua_State *L, const char *tname);
	void  			luaL_setmetatable(lua_State *L, const char *tname);
	void 			*luaL_testudata(lua_State *L, int ud, const char *tname);
	void 			*luaL_checkudata(lua_State *L, int ud, const char *tname);

	void 			luaL_where(lua_State *L, int lvl);
	int 			luaL_error(lua_State *L, const char *fmt, ...);

	int 			luaL_checkoption(lua_State *L, int narg, const char *def, char[] *lst);

	int 			luaL_fileresult(lua_State *L, int stat, const char *fname);
	int 			luaL_execresult(lua_State *L, int stat);

	/* pre-defined references */
	enum	int		LUA_NOREF	= (-2);
	enum	int		LUA_REFNIL	= (-1);
	
	int 			luaL_ref(lua_State *L, int t);
	void 			luaL_unref(lua_State *L, int t, int refr);

	int 			luaL_loadfilex(lua_State *L, const char *filename, const char *mode);
	
	int luaL_loadfile(lua_State *L, const char* filename)
	{
		return luaL_loadfilex(L, filename, null);
	}

	int 		luaL_loadbufferx(lua_State *L, const char *buff, size_t sz, const char *name, const char *mode);
	int 		luaL_loadstring(lua_State *L, const char *s);

	lua_State 	*luaL_newstate();

	int 		luaL_len(lua_State *L, int idx);

	char 		*luaL_gsub(lua_State *L, const char *s, const char *p, const char *r);

	void 		luaL_setfuncs(lua_State *L, luaL_Reg *l, int nup);

	int 		luaL_getsubtable(lua_State *L, int idx, const char *fname);

	void 		luaL_traceback(lua_State *L, lua_State *L1, const char *msg, int level);

	void 		luaL_requiref(lua_State *L, const char *modname, lua_CFunction openf, int glb);

		
	
	/*
	**	Some useful function's definitions
	*/	
	int luaL_dofile(lua_State *L, const char* filename)
	{
		return luaL_loadfile(L, filename) || lua_pcall(L, 0, LUA_MULTRET, 0);
	}

	void	luaL_newlibtable(lua_State *L, luaL_Reg[] l)
	{
		lua_createtable(L, 0, l.sizeof/l[0].sizeof - 1);
	}

	/* NEED TO TESTING!!!  */
	void	luaL_newlib(lua_State *L, luaL_Reg *l)
	{
		luaL_Reg[] tmp = new luaL_Reg[1];

		tmp[0] = *l;

		luaL_newlibtable(L, tmp);
		luaL_setfuncs(L, l, 0);
	}
	
	int		luaL_argcheck(lua_State* L, int cond, int numarg, const char* extramsg)
	{
		return (cond) || luaL_argerror(L, numarg, extramsg);
	}

	char*	luaL_checkstring(lua_State *L, int arg)
	{
		return luaL_checklstring(L, arg, null);
	}

	char *luaL_optlstring (lua_State *L, int arg, const char *d, size_t *l)
	{
		return luaL_optlstring(L, arg, d, null);
	}
	
	int		luaL_checkint(lua_State *L, int arg)
	{
		return cast(int) luaL_checkinteger(L, arg);
	}

	int 	luaL_optint(lua_State *L, int arg, int d)
	{
		return cast(int) luaL_optinteger(L, arg, d);
	}

	long	luaL_checklong(lua_State *L, int arg)
	{
		return cast(long) luaL_checkinteger(L, arg);
	}

	long	 luaL_optlong(lua_State *L, int arg, long d)
	{
		return cast(long) luaL_optinteger(L, arg, d);
	}

	char *luaL_typename(lua_State *L, int index)
	{
		return lua_typename(L, lua_type(L, index));
	}

	int luaL_dostring (lua_State *L, const char *str)
	{
		return (luaL_loadstring(L, str) || lua_pcall(L, 0, LUA_MULTRET, 0));
	}

	void luaL_getmetatable (lua_State *L, const char *tname)
	{
		lua_getfield(L, LUA_REGISTRYINDEX, tname);
	}

	int luaL_loadbuffer (lua_State *L, const char *buff, size_t sz, const char *name)
	{
		return luaL_loadbufferx(L, buff, sz, name, null);
	}


	/*
	**	Generic Buffer manipulations	
	*/

	struct luaL_Buffer
	{
		char					*b;
		size_t					size;
		size_t					n;
		lua_State				*L;
		char[LUAL_BUFFERSIZE]	initb;
	}

	void 	luaL_addchar(luaL_Buffer *B, char c)
	{
		cast(void) ( ( (*B).n < (*B).size ) || luaL_prepbuffsize(B, 1));

		(*B).b[(*B).n++] = c;
	}

	void	luaL_addsize(luaL_Buffer *B, size_t sz)
	{
		(*B).n += sz;
	}

	void 		luaL_buffinit(lua_State *L, luaL_Buffer *B);
	char 		*luaL_prepbuffsize(luaL_Buffer *B, size_t sz);
	void 		luaL_addlstring(luaL_Buffer *B, const char *s, size_t l);
	void 		luaL_addstring(luaL_Buffer *B, const char *s);
	void 		luaL_addvalue(luaL_Buffer *B);
	void 		luaL_pushresult(luaL_Buffer *B);
	void 		luaL_pushresultsize(luaL_Buffer *B, size_t sz);
	char 		*luaL_buffinitsize(lua_State *L, luaL_Buffer *B, size_t sz);

	char	*lua_prepbuffer(luaL_Buffer *B)
	{
		return luaL_prepbuffsize(B, LUAL_BUFFERSIZE);

	}

	/*
	**	File handles for IO library
	*/

	enum	string	LUA_FILEHANDLE		= "FILE*";

	struct luaL_Stream
	{
		FILE			*f;
		lua_CFunction	closef;
	}

	void 		luaL_pushmodule(lua_State *L, const char *modname, int sizehint);
	void		luaL_openlib(lua_State *L, const char *libname, const luaL_Reg *l, int nup);

	void	luaL_register(lua_State	*L, const char *libname, luaL_Reg *l)
	{
		luaL_openlib(L, libname, l, 0);
	}
}
