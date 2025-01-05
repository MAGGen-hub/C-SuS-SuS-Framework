# C SuS SuS Framework
<img src="https://raw.githubusercontent.com/MAGGen-hub/C-SuS-SuS-Framework/refs/heads/master/C_SuS_SuS_logo.svg" style="width: 36%;height: 250px; overflow: hidden;" align="right">\
C SuS SuS Framework ( Very Suspicious C++ or Cඞඞ ) - Modular data processing system made in lua.

Currently it's main purpouse - expand default Lua functional and make coding in Lua a bit more comfy than it was before.

Current version: 4.6-beta

Legacy version (C SuS SuS esoteric pseudo coding language) can be found [here](https://github.com/MAGGen-hub/C_sus_sus_legacy).

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
  Operator `?=` (sets value to variable only if ti was `nil` before)
  
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
  - `*args*-> *exp* end` --> `function(*args*)return *exp* end`  -  (must contain at least one argument)
  - `*args*=> *code* end` --> `function(*args*) *code* end` -  (must contain at least one argument)
  - `(*args*)-> *exp* end`  --> `function(*args*)return *exp* end`
  - `(*args*)=> *code* end` --> `function(*args*) *code* end`
    
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
   - `/out/release/*version*/cssf__*lua_version*.lua` - main file
   - `/out/release/*version*/modules` - functional modules
   - `/out/release/*version*/features` - project libruaries

   **P.S.** `*version*` -> original or minified code
2. Install one of 'bit' libruaryes to your Lua version\
   (required for `Backport operators` feature, but project can run without it):
	- bit-lua5.1 (recomended)
	- bit32-lua5.1
	- bitop-lua5.1 (made in lua):\
   	  https://github.com/AlberTajuelo/bitop-lua/blob/master/src/bitop/funcs.lua \
	  (Command:`package.path['bitop']=loadfile"funcs.lua"`)
3. Copy `/set_path.lua` to `*dir*` and run:\
   `lua ./set_path.lua absolute_path_to:cssf__*lua_version*.lua`
4. Inject path to `*dir*` into `package.path`
5. `cssf=require"cssf__*lua_version*"`
   
### From releases (recomended):
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
3. Download `set_path.lua`.
4. Run `set_path.lua`:\
   `lua ./set_path.lua absolute_path_to:*dir*/cssf.lua`\
   **P.S.** Or you can set `local base_path` in `cssf.lua` manualy (located at the start)
5.  Inject path to `*dir*` into `package.path`
6. `cssf=require"cssf"`
## Usage
1. Run `cssf=require"*cssf_module_name*"`
2. Choose one of configuartions:
 - **Basic configuartion:** `cssf_instance = cssf"config=cssc_basic"`\
    Stable & compy, just a few new features, common for other programming languages.
   
    **Build:** `sys.err,cssc={NF,KS,BO,CA,ncbf}`
    
    **Provides:** 
    - number formats 
    - keyword shortcuts: `!` `||` `&&`
    - backport operators 
    - additional assignment
    - number concatenation bug fix
  - **Recomended configuration:** `cssf_instance = cssf"config=cssc_user"`\
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
  - **Full configuration:** `cssf_instance = cssf"config=cssc_full"`\
    All inclusive mode, experimental & cursed & unstable but very fun XD
    
    **Build:** `sys.err,cssc={NF,KS(ret,loc,sc_end,pl_cond),LF,DA,BO,CA,NC,IS,ncbf}`
    
    **Provides:** every existing feature avaliable (excluding minification)
  - **Minify configuration:** `cssf_instance = cssf"minify"`\
    Minification module to decrease code size, sacrificing code readability.
    
    **Build:** `cssf_instance = cssf"minify"`
    
    **Provides:** minification feature.
    
3. `local prep_code = cssf_instance:compile(source_code)`
4. `local func,err = cssf_instance.load(prep_code,chunk_name,'c',environment)`
5. Run compilled `func`

**P.S.** by default `cssf_instance` has `run` function in it, but `cssc` (C SuS SuS Compiller) module\
replaces it with `compile` and `load`. Calling `compile` to load code is not required actualy.\
In this example `cssf_instance.load` called with `'c'` mode, which tells `load` that code was already compilled.\
Without `mode=='c'` - load will try to compile code automaticaly\
(if it's not in bytecode form, which also means that code was compilled). 
## Custom configuration
 If all configuartions avaliable is not what you are searching for, you can create your own configuartion using project build system.\
  **Examples:**

  
  - `cssf"cssc.BO"` - backport operators
  - `cssf"cssc.KS` - keyword shortcuts `!` `||` `&&`
  - `cssf"cssc.KS(sc_end)"` - keyword shortcuts `!` `||` `&&` `;` `\;`
  - `cssf"cssc.KS(loc,ret)"` -  keyword shortcuts `!` `||` `&&` `@` `$`
  - `cssf"cssc.KS(pl_cond)"` -   keyword shortcuts `!` `||` `&&` `/|` `?` `:|` `\|`
  - `cssf"cssc={BO,CA,KS(*arg*)}"` - multiple features

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
