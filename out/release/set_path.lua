
local path = arg[1]
if path:match("^%s*%.") then error("Path must be absolute (from root to file).") end

local dir = path:gsub("^(.+/)[%w_]-%.lua$","%1")
if not dir  then error("Incorrect file path...")end
print("New path", dir)

local file = io.open(path, "r")
if not file then error("Can't open file: "..path) end
local content = file:read "*a"
file:close()

local new_content, changes = content:gsub("(local base_path=%[%[)(.-)(%]%])",function(a,b,c)
    print("Previous path:",b)
    --print("New path     :",dir)
    return a..dir..c
end,1)
if changes<1 then error("Base path local not found in file!")end

local file = io.open(path, "w")
if not file then error("Can't open file: "..path) end
file:write(new_content)
file:close()
print("Path change successful.")

