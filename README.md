# Lua API for D language



D language modules for access to Lua API functions

## Usage


1. Clone this project by git clone https://github.com/maisvendoo/lua_d_api.git
2. Copy all \*.d files in your project foldel
3. Import required libraris in your code
4. Link programm with key '-llua'

For example:


	module	main;

	import	lua;
	import	lualib;
	import	lauxlib;

	void main()
	{
		lua_State *L = lauL_newstate();

		 

		lua_close(L);
	}


You can use Lua API functions in your D program (same as in Lua C API)
