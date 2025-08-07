-- parser.lua
--
-- Parses a token list and turns it into an AST of sorts.
-- The AST is a flat structure, and is meant to be read by the compiler. It's
-- an "Intermediate Representation" of the code before it's compiled into either
-- bytecode, or Lua. Perhaps another language later.

-- The IR uses parentheses and S expressions to declare what things are. Think
-- of the IR used in Bismuth: https://enikofox.com/posts/hello-world-in-bismuth/
-- or the Web assembly text format: https://developer.mozilla.org/en-US/docs/WebAssembly/Guides/Understanding_the_text_format

-- IR Definitions:
--[[
  () : expression delimiter. Whatever is placed in here has a side effect and
      returns a value.
  ([type] [attribute]*) : In our parens we have a series of attributes that
      define the behaviour. Assuming we'll translate this into an OP_CODE or
      something, the first statement is the opcode. Subsequent statements are
      optional inputs or more S expressions.
  
  # Node:
    module: defines a module, every file is a module by default. accepts a series:
      (module)
    global: defines a global variable. Accepts a name as input:
      (global name), (global person), (global thing)
    local: defines a local variable. Accepts a name as input:
      (local name), (local person), (local thing)
    get: gets a named variable, object, or type:
      (get name)
    data: defines some data that will be put into the stack. like a value. must
      be a data type defined below:
      (data number 15), (data string "This is interesting"), (data bool false)
    func: A function declaration. Declaring a reusable function in scope:
      (func <signature> <locals> <body>)
    operation: An operator node, accepts the operator name, and two s expression
      attributes:
      (operation add (data number 15) (data number 16))
      
  ## Signatures:
    like WAT a signature is a sequence of parameters with names and an optional type:
      (param name int) (param rank) (param station)
      
  ## Operators by precedence
    assignment (=): (operation assignment (global name) (data number 15))
    log_or (or): (operation log_or (data bool true) (data bool false))
    log_and (and): (operation and (data bool false) (data bool false))
    log_equal (==): (operation log_equal (data number 15) (data number 16))
    log_not_equal (!=): (operation log_not_equal (data number 15) (data number 16))
    is (is): (operation is (data number 15) (data type 16))
    add: (operation add (data number 15) (data number 16))
    subtract: (operation subtract (data number 15) (data number 16))
    modulo: (operation modulo (data number 15) (data number 16))
    divide: (operation divide (data number 15) (data number 16))
    factor: (operation factor (data number 15) (data number 16))
      
  # Data types:
    number: a floating point, integer, or hexadecimal number:
      (data number 15), (data number 19.99, (data number 0x6E6379)
    int: an 64 bit integer
    float: a 64 bit floating point number
    hex: a hexadecimal number
    string: A double quoted string:
      (data string "captain kirk")
    bool: A boolean value of either true or false\;
      (data bool true), (data bool false)
    object: An object reference, or a name that refers to an object in scope:
      (data object phil),  (data object sylar), (data object dictionary),
      (data object _what_is_this).
    list: An array object that can contain any number of values as a space
      delimited sequence of s expresions:
      (data list
        (data number 15)
        (data number 16)
        (data number 17)
      )
    any: represents any value that can be returned by an expression.
    type: represents a concrete declared type found in scope. The next attribute
      is the name of the type:
      (data type Well)
    
]]

require "scanner"

-- make namespace
Parser = {}

-- create a new Parser object
function Parser:new(source)
  local u = {
    source=source,
    scanner=Scanner:new(source)
  }
  
  -- sets the metatable of the new u object to self. In this instance,
  -- it's the Parser namespace that's getting filled up with functions.
  setmetatable(u,self)
  self.__index = self
  
  -- sets the supertable of the parserFunctions switch
  -- to be our scanner table. This means that later, when
  -- we define scanTokenFunctions, the functions will
  -- reference our parser. make sense?
  self.parserFunctions.supertable = u
  return u
end

-- a list of functions that we 'index' in our parser. That is we look up the
-- index like this:
--[[
  function Parser:do_something()
    local functionthing = self.parserFunctions[c]
    if functionthing ~= nil then functionthing(self) end
  end
]]

Parser.parserFunctions = {
  ["whatever"] = function (s)
    s:this_is_my_united_tates_of_whatever()
  end,
}

-- Set upt the super table for the Parser.parserFunctions table.
local stf, stfmt = Parser.parserFunctions, {}
stf.supertable = {}
setmetatable(stf, stfmt)

-- add an __index meta entry into the stfmt meta table for
-- Scanner.scanTokenFunctions. Use this to apply default cases.
stfmt.__index = function (table, key)
  -- if table.supertable:do_something(key) then
  --   do_something()
  -- elseif table.supertable:do_something_else(key) then
  --   do_something()
  -- else
  --   local key_s = key
  --   if key == '\0' then key_s = '\\0' end
  --   error("Unexpected function referenced: "..key_s..", at line "..table.supertable.line, 2)
  -- end
end
