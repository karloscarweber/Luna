-- Feed.lua
-- receives arguments from the commmand line and parses them for the program/
-- compiler thing.

-- command structure: luajit program.lua -o
-- where -o is the .luna file that we want to compile.

-- Compilation target is /build

File = {}

-- Accepts a file successfully opened using io.open:
--  ```
--    local file = io.open(args, "r")
--  ```
-- Like that.
function File:read(file, callback)
  io.input(file)
  local line, value = 0, ""
  while(not (type(value) == "nil"))
  do
    line = line + 1
    value = io.read()
    print(string.format("%d  %s", line, value))
    if(type(callback) == "function") then
      callback()
    end
  end
end


local file = io.open(ARGS, "r")
File:read(file)

-- local line = ""
-- while not type(line) == "nil"
-- do
  -- line = io.read()
  -- print(line)
-- end
-- local thing = io.read()
-- print(type(thing))
-- thing = io.read()
-- print(type(thing))
-- thing = io.read()
-- print(type(thing))

print("End of Line.")
