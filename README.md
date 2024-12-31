# C SuS SuS Framework
<img src="https://raw.githubusercontent.com/MAGGen-hub/C-SuS-SuS-Framework/refs/heads/master/C_SuS_SuS_logo.svg" style="width: 270px;height: 230px; overflow: hidden;">
C SuS SuS Framework - data processing system made in lua.

Currently it's main purpouse - expand default Lua functional and make coding in Lua a bit more comfy than it was before.

Current version: 4.5-beta

Supported Lua versions:
- Lua 5.1
- Lua 5.2 (no `goto` `:: label ::` support - requires more testing)
- CraftOS (no `goto` `:: label ::` support - requires more testing)
## Project Features

**At this moment project can provide next functional:**
- New number formats: binary and octal (binnary exponenta supported)
 - `local a,b,c = 0B101, 0b101.1, 0b1P-3 -- a,b,c = 5, 5.5, 0.125`
 - `local d,e = 0o21.1, 0O0.12P1 -- local d,e = 17.125, 20`
- Backported operators! Full support of operators from Lua5.3 including their metamethods:\
  `>>` `<<` `&` `|` `~` `//`  `unary ~`
- Additional asignment operators:\
  `+=` `-=` `*=` `/=` `%=` `^=` `..=` `&&=` `||=`\
  `>>=` `<<=` `|=` `&=`\
  Operator `?=` (sets value to variable only if ti was `nil` before)\
  **P.S.** Multy-assgnment is unsuported, so this `a,b,c += 1,2,3` is prohibited (for now).
- Keywords shortcuts (probably the most cursed feature, that will be removed in future):
  -  `@` - `local`
  -  `$` - `return`
  -  `||` - `or`
  -  `&&` - `and`
  -  `!` - `not`
  -  `;` - `end` (`\;` -> `;`) 
  -  `/|` -`if`
  -  `:|`- `esleif`
  -  `\|` - `else`
  - `?` - `then`
- Auto `nil` checking operatos:
  - `obj?.idx`, `obj?[*idx*]`, `obj?:idx()` 
  - `obj?'str'`, `obj?"str"`,  `obj?[[STR]]`
  - `obj?{*tab*}` 
  - `obj?(*args*)`
   `"attempt to *action* 'nil' value"` error wil not happen if `obj==nil` here.
 - Lambda-functions:
  - `*args*->` --> `function(*args*)return`  -  (must contain at least one argument)
  - `*args*=>` --> `function(*args*)` -  (must contain at least one argument)
  - `(*args*)->`  --> `function(*args*)return`
  - `(*args*)=>` --> `function(*args*)`\
    **P.S.** better to use it with keyword shortcuts: so `;` can be used instead of `end`
 - Keyword `is` (support custom types `{__type} - metamethod`):
  - `obj is 'string'` --> checks if `type(object)==string`
  - `obj is {'string','number'}` --> checks if `type(obj)` is one from the table
 - Default args and strict arg types for function constructor (support custom types `{__type} - metamethod`):
  - `function(arg = def_arg)` --> defualt argument
  - `function(arg : string)` --> strict type
  - `function(arg : "type1,type2" = def_arg)` --> defualt argument & strict types
  - `function(arg : "string,number" = def_arg)` - default `arg` calculates at runtime and can be an expression with local/global values.
 - Number concatenation bug fix:\
   Turn `*num*..*obj*` into `*num* ..*obj*`\
   So first dot of `operator` will not be recognised as number floating point.
 - Basic error detection for each feature:\
   Unfortunately it stil can't detect every posible typos, but common mistakes and errors will be detected and with `sys.err` module compilation will be stopt after first found error.
 - Minification module:\
   Simple module that removes all unnesesary spaces and commnets from your code,\
   so it can be uploaded directly to MCU flash memory, where every byte matters.
## Instalation
### From src:
1. Download next files/dirs to choosen `*dir*`
   - `/out/release/cssc__*lua_version*__original.lua` - main file
   - `/out/release/modules` - functional modules
   - `/out/release/features` - project libruaries
2. Install one of 'bit' libruaryes to your Lua version\
   (required for `Backport operators` feature, but project can run without it):
	- bit-lua5.1 (recomended)
	- bit32-lua5.1
	- bitop-lua5.1 (made in lua):\
   	  https://github.com/AlberTajuelo/bitop-lua/blob/master/src/bitop/funcs.lua \
	  (Command:`package.path['bitop']=loadfile"funcs.lua"`)
3. Copy `/set_path.lua` to `*dir*` and run:\
   `lua ./set_path.lua absolute_path_to:cssc__*lua_version*__original.lua`
4. Inject path to `*dir*` into `package.path`
5. `cssc=require"cssc__*lua_version*__original"`
   
### From releases:
1. Download one of the archives:\
   Original src with comments:
   - c_sus_sus_framework_b45_original_craftos_release.zip
   - c_sus_sus_framework_b45_original_lua51_release.zip
   - c_sus_sus_framework_b45_original_lua52_release.zip
     
   Compressed code (very small):
   - c_sus_sus_framework_b45_minified_craftos_release.zip
   - c_sus_sus_framework_b45_minified_lua51_release.zip
   - c_sus_sus_framework_b45_minified_lua52_release.zip
2. Unpack into choosen `*dir*`
3. Run `*dir*/set_path.lua`:\
   `lua ./set_path.lua absolute_path_to:*dir*/cssc.lua`
4.  Inject path to `*dir*` into `package.path`
5. `cssc=require"cssc"`
## Usage
1. Run `cssc=require"*cssc_module_name*"`
2. Choose one of configuartions:
 - **Basic configuartion:** `cssc_instance = cssc"config=cssc_basic"`\
    Stable & compy, just a few new features, common for other programming languages.
   
    **Build:** `sys.err,cssc={NF,KS,BO,CA,ncbf}`
    
    **Provides:** 
    - number formats 
    - keyword shortcuts: `!` `||` `&&`
    - backport operators 
    - additional assignment
    - number concatenation bug fix
  - **Recomended configuration:** `cssc_instance = cssc"config=cssc_user"`\
    Still stable & comfy, contains more freatures, but can be a bit "tricky" to use.
    
    **Build:** `sys.err,cssc={NF,KS(sc_end),LF,DA,BO,CA,NC,IS,ncbf}`
    
    **Provides:**
    - number formats 
    - keyword shortcuts: `!` `||` `&&` `;` `\;`
    - lambda functions
    - default argumnets & strict typing
    - backport operators 
    - additional assignment
    - `nil` checking operators
    - `is` keyword
    - number concatenation bug fix
  - **Full configuration:** `cssc_instance = cssc"config=cssc_full"`\
    All inclusive mode, experimental & cursed & unstable but very fun XD
    
    **Build:** `sys.err,cssc={NF,KS(ret,loc,sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}`
    
    **Provides:** every existing feature avaliable (excluding minification)
  - **Minify configuration:** `cssc_instance = cssc"minify"`\
    Minification module to decrease code size, sacrificing code readability.
    
    **Build:** `cssc_instance = cssc"minify"`
    
    **Provides:** minification feature.
    
3. `local prep_code = cssc_instance:run(source_code)`
4. `local func,err = cssc_instance.load(prep_code,chunk_name,nil,environment)`
5. Run compilled `func`
## Custom configuration
 If all configuartions avaliable is not what you are searching for, you can create your own configuartion using project build system.\
  **Examples:**

  
  - `cssc"cssc.BO"` - backport operators
  - `cssc"cssc.KS(sc_end)"` - keyword shortcuts `!` `||` `&&` `;` `\;`
  - `cssc"cssc.KS(loc,ret)"` -  keyword shortcuts `@` `$`
  - `cssc"cssc.KS(pl_cond)"` -   keyword shortcuts `/|` `?` `:|` `\|`
  - `cssc"cssc={BO,CA,KS(*arg*)}"` - multiple features

  \
  **Feature name aliases:**
  - backport_operators="BO"
  - back_opts="BO"
  - bitwizes="BO"
  - additional_assignment="CA"
  - c_like_assignment="CA"
  - AA="CA"
  - defautl_arguments="DA"
  - def_args="DA"
  - is_keyword="IS"
  - keyword_shortcuts="KS"
  - sort_keywords="KS"
  - lambda_functions="LF"
  - lambda_funcs="LF"
  - nil_forgiving="NC"
  - nil_checking="NC"
  - number_formats="NF"
  - number_concat_bug_fix="ncbf"
