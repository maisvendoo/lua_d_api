# Lua API for D language

D language modules for access to Lua API functions

# Usage

1. Clone this project by git clone https://github.com/maisvendoo/lua_d_api.git
2. Copy all *.d files in your project foldel
3. Import required libraris in your code

For example:

import	lua.d;
import	lualib.d;
import	lauxlib.h;

4. Link programm with key '-llua'

You can use Lua API functions in your D program (same as in Lua C API)
