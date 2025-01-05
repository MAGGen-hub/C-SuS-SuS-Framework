# cssf-4.6-beta
Small rework and improvements.

### Added
- CHANGELOG.md
- Version fields to `cssc` and `minify` modules.
- Beta version of CraftOS CSSF linstaller. GUI & CLI avaliable. (still need more testing)
### Changed
- Project Logo.
- A few things in compile system.
- `make_env` function from runtime lib, now accessable from `cssf_instance` if lib loaded.
- `os.execute-plugin` now used to automatize release archives creation.
- `set_path.lua` removed from release archives.
- `cssf_instance.run` replaced by `compile` function when `cssc` module used
- `cssf_instance.load` now compiles scripts automaticaly (if script is not bytecode).
- `cssf_instance.load` : if `mode=='c'` - function will recognise `x` as already compilled script.
- moved all Lua version related macros into `macro` folder
### Fixed
- Minified `IS` module bug
- Pattern matching class error in some LuaVM's (Java based)
- Typo in `parcer` lib name -> `parser`
- `cssc` typo. Was replaced with `cssf` where it means `C SuS SuS Framework`.
- Some other typos...

# cssf-4.5-beta
**C SuS SuS Framework** - Initial release & Beta test.

## Features

 - Minmal working project
 - Data parsing modules configuration system
 - Basic libruaries to work with text/lua code
 - Logger system.
 - Basic parse error detection system.

### C SuS SuS Compiller  *(4.1-beta)*

Lua5.1 - Lua5.2 functional extension system.

 - Weird keyword shortcuts from old project
 - Operators backport from Lua5.3:`>>`,`<<`,`|`,`&`,`~`,`//`
 - Additional assignment opts: `X=`
 - Keyword `is`, custom types support
 - Function: `typeof` (private)
 - Default function arguments: `function(*arg* : *type* = *default*)`
 - Lambda functions: `=>` and `->`
 - Auto `nil` checking opts.
 - Number concatenation bug fix.
 - New number formats: binnary and octal.

### Basic minify module  *(1.1-beta)*

Code minification (spagettification) system.
 - Comment remove
 - Unnesesary spaces remove
