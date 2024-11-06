local p = require"cc.pretty".pretty_print
l= cssc_beta.load([==[<dbg(p)>

----    
1
3
---aaa
3
 ---nnn

]==],nil,"c")
p(l)


local f=fs.open("test/lzss.lua","r")
local lzss=f.readAll()
f.close()
local f=cssc_beta.load("<M,dbg(p)>\n"..lzss,nil,"s")
local f2 = fs.open("test/lzss.lua.cssc","w")
f2.write(f)
f2.close()
