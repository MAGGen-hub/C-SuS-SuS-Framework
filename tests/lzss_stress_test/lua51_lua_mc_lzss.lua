
package.path=package.path..";/home/maggen/.local/share/craftos-pc/computer/0/?.lua"--add previous directory to require check
lzss_orig = [===[
    --[[----------------------------------------------------------------------------
    
        LZSS - encoder / decoder
    
        This is free and unencumbered software released into the public domain.
    
        Anyone is free to copy, modify, publish, use, compile, sell, or
        distribute this software, either in source code form or as a compiled
        binary, for any purpose, commercial or non-commercial, and by any
        means.
    
        In jurisdictions that recognize copyright laws, the author or authors
        of this software dedicate any and all copyright interest in the
        software to the public domain. We make this dedication for the benefit
        of the public at large and to the detriment of our heirs and
        successors. We intend this dedication to be an overt act of
        relinquishment in perpetuity of all present and future rights to this
        software under copyright law.
    
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
        EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
        MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
        IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
        OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
        ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
        OTHER DEALINGS IN THE SOFTWARE.
    
        For more information, please refer to <http://unlicense.org/>
    
    --]]----------------------------------------------------------------------------
    --------------------------------------------------------------------------------
    local M = {}
    local string, table = string, table
    
    --------------------------------------------------------------------------------
    local POS_BITS = 12
    local LEN_BITS = 16 - POS_BITS
    local POS_SIZE = 1 << POS_BITS
    local LEN_SIZE = 1 << LEN_BITS
    local LEN_MIN = 3
    
    --------------------------------------------------------------------------------
    function M.compress(input)
        local offset, output = 1, {}
        local window = ''
    
        local function search()
            for i = LEN_SIZE + LEN_MIN - 1, LEN_MIN, -1 do
                local str = string.sub(input, offset, offset + i - 1)
                local pos = string.find(window, str, 1, true)
                if pos then
                    return pos, str
                end
            end
        end
    
        while offset <= #input do
            local flags, buffer = 0, {}
    
            for i = 0, 7 do
                if offset <= #input then
                    local pos, str = search()
                    if pos and #str >= LEN_MIN then
                        local tmp = ((pos - 1) << LEN_BITS) | (#str - LEN_MIN)
                        buffer[#buffer + 1] = string.pack('>I2', tmp)
                    else
                        flags = flags | (1 << i)
                        str = string.sub(input, offset, offset)
                        buffer[#buffer + 1] = str
                    end
                    window = string.sub(window .. str, -POS_SIZE)
                    offset = offset + #str
                else
                    break
                end
            end
    
            if #buffer > 0 then
                output[#output + 1] = string.char(flags)
                output[#output + 1] = table.concat(buffer)
            end
        end
    
        return table.concat(output)
    end
    
    --------------------------------------------------------------------------------
    function M.decompress(input)
        local offset, output = 1, {}
        local window = ''
    
        while offset <= #input do
            local flags = string.byte(input, offset)
            offset = offset + 1
    
            for i = 1, 8 do
                local str = nil
                if (flags & 1) ~= 0 then
                    if offset <= #input then
                        str = string.sub(input, offset, offset)
                        offset = offset + 1
                    end
                else
                    if offset + 1 <= #input then
                        local tmp = string.unpack('>I2', input, offset)
                        offset = offset + 2
                        local pos = (tmp >> LEN_BITS) + 1
                        local len = (tmp & (LEN_SIZE - 1)) + LEN_MIN
                        str = string.sub(window, pos, pos + len - 1)
                    end
                end
                flags = flags >> 1
                if str then
                    output[#output + 1] = str
                    window = string.sub(window .. str, -POS_SIZE)
                end
            end
        end
    
        return table.concat(output)
    end
    
    return M
    ]===]
lzss_bit32=[===[  --[[----------------------------------------------------------------------------

LZSS - encoder / decoder

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

--]]  ------------------------------------------------------------------------------------------------------------------------------------------------------
local M = {}
local string, table = string, table

----------------------------------------------------------------------------
local POS_BITS = 12
local LEN_BITS = 16 - POS_BITS
local POS_SIZE = bit32.lshift(1,POS_BITS)
local LEN_SIZE = bit32.lshift(1,LEN_BITS)
local LEN_MIN = 3

----------------------------------------------------------------------------
function M.compress(input)
local offset, output = 1, {}
local window = ''

local function search()
    for i = LEN_SIZE + LEN_MIN - 1, LEN_MIN, -1 do
        local str = string.sub(input, offset, offset + i - 1)
        local pos = string.find(window, str, 1, true)
        if pos then
            return pos, str
        end
    end
end

while offset <= #input do
    local flags, buffer = 0, {}

    for i = 0, 7 do
        if offset <= #input then
            local pos, str = search()
            if pos and #str >= LEN_MIN then
                local tmp = bit32.bor(bit32.lshift(pos-1,LEN_BITS), #str - LEN_MIN)
                buffer[#buffer + 1] = string.pack('>I2', tmp)
            else
                flags = bit32.bor(flags,bit32.lshift(1,i))
                str = string.sub(input, offset, offset)
                buffer[#buffer + 1] = str
            end
            window = string.sub(window .. str, -POS_SIZE)
            offset = offset + #str
        else
            break
        end
    end

    if #buffer > 0 then
        output[#output + 1] = string.char(flags)
        output[#output + 1] = table.concat(buffer)
    end
end

return table.concat(output)
end

----------------------------------------------------------------------------
function M.decompress(input)
local offset, output = 1, {}
local window = ''

while offset <= #input do
    local flags = string.byte(input, offset)
    offset = offset + 1

    for i = 1, 8 do
        local str = nil
        if bit32.band(flags,1) ~= 0 then
            if offset <= #input then
                str = string.sub(input, offset, offset)
                offset = offset + 1
            end
        else
            if offset + 1 <= #input then
                local tmp = string.unpack('>I2', input, offset)
                offset = offset + 2
                local pos = bit32.rshift(tmp,LEN_BITS) + 1
                local len = bit32.band(tmp,LEN_SIZE - 1) + LEN_MIN
                str = string.sub(window, pos, pos + len - 1)
            end
        end
        flags = bit32.rshift(flags,1)
        if str then
            output[#output + 1] = str
            window = string.sub(window .. str, -POS_SIZE)
        end
    end
end
return table.concat(output)
end
return M]===]

--getpath
test_path = "cssc_final/out/release/cssc__lua51__original"

test_string_template="function function function test test test test test lzss lzss lzss lzss lzss 1-283-29018-2098-2"
test_string = (test_string_template):rep(120000)
lua53 = string.match(_VERSION,"5%.3")
larg= {}
nxt_t=false
tests_count=10
for _,v in pairs(arg)do 
    larg[v]=_ 
    if v=="tests"then nxt_t = true end 
    if nxt_t then 
        tests_count=tonumber(v) or tests_count
        nxt_t=false 
    end 
end
lzss_src= larg.bit32 and lzss_bit32 or lzss_orig
local T=os.clock

print("Testring LZSS "..(larg.bit32 and "bit32"or"").." algoritm in ".._VERSION)
if lua53 then
    tm= T()
    lzss = load(lzss_src)()
    s_tm=T()-tm
else
    print("With usage of CSSC module...")
    if larg.direct then print("Direct enabled... Backported operators will not suport metatables, but work faster!")end
    bit32=require"bit32"
    require"compat53"
    lua_mc=require(test_path)--load system
    comp1=lua_mc"cssc.BO"
    tm=T()
    comp_lzss=comp1:run(lzss_src, larg.direct and "cssc.BO.direct" or"") -- cssc.BO.direct
    lzss = comp1.load(comp_lzss,"lzss",nil,setmetatable({},{__index=_G}))()
    s_tm=T()-tm
end
print("Script compilation & loading time:",s_tm)

print("Test string length:",#test_string,"chars")
print("Tests count:",tests_count)
print("\nTesting compression:")
c_tm=0
for i=1,tests_count do
    if not larg.time then io.write(("\b \b"):rep(100)) io.write("Current test: "..i) io.flush() end
    if larg.time then io.write(string.format("Test %2d",i)) io.flush() end
    tm=T()
    compressed_string = lzss.compress(test_string)
    tm=T()-tm
    if larg.time then print(" - time:",tm) end
    c_tm=c_tm+tm
end

print("\nTesting decompression:")
d_tm=0
for i=1,tests_count do
    if not larg.time then io.write(("\b \b"):rep(100)) io.write("Current test: "..i) io.flush() end
    if larg.time then io.write(string.format("Test %2d",i)) io.flush() end
    tm=T()
    decompressed_string = lzss.decompress(compressed_string)
    tm=T()-tm
    if larg.time then print(" - time:",tm) end
    d_tm=d_tm+tm
end
print("\nData:")
print("Test string length    :",#test_string,"chars")
print("Tests count           :",tests_count)
print()
print("Results:")
print("Script comp&load time :",s_tm)
print("Mid comptession time  :",c_tm/tests_count)
print("Mid decomptession time:",d_tm/tests_count)
print()
print("String equality check :",decompressed_string==test_string)


