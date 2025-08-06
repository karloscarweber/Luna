-- scanner.lua
--
-- Another Scanner written in Lua

-- Accepts a text file and then transforms it into an
-- IR language that is then compiled to Lua. Can spawn
-- more scanners.
--
-- Scanners are made by Compilers, which are made by VMs.
--
require 'token'

-- make namespace
Scanner = {}

-- create a new Scanner object
function Scanner:new(source)
  local u = {
    start=1, -- this starts at 1 because lua stuff is 1 based and we need to start there.
    current=0, -- current gets pushed to one when we start
    line=1,
    source=source,
    tokens={}
  }
  
  -- sets the metatable of the new u object to self. In this instance,
  -- it's the Scanner namespace that's getting fille dup with functions.
  setmetatable(u,self)
  self.__index = self
  
  -- sets the supertable of the scanTokenFunctions switch
  -- to be our scanner table. This means that later, when
  -- we define scanTokenFunctions, the functions will
  -- reference our scanner. make sense?
  self.scanTokenFunctions.supertable = u
  return u
end

-- scans the source code of the scanner
function Scanner:scan()
  while not self:isAtEnd() do
    self:scanToken()
  end
  
  self.tokens[(#self.tokens + 1)] = Token:new(EOF, "", "", self.line)
  return self.tokens
end

-- dumps the tokens one by one. Used for debugging.
function Scanner:spitTokens()
  for _, v in ipairs(self.tokens) do
    print(v:to_string())
  end
end

-- the identifier function. checks to see if the token we're scanning
-- is an identifier or a keyword.
function Scanner:identifier()
  while self:isAlphaNumeric(self:peekNext()) do self:advance() end
  local text = string.sub(self.source,self.start,self.current)
  local type = self.keywords[text];
  if (type == nil) then type = IDENTIFIER end
  self:addToken(type);
end

-- matches a number and adds the token.
function Scanner:number()
  while self:isDigit(self:peek()) do self:advance() end
  if (self:peek() == '.' and self:isDigit(self:peekNext())) then
    -- Consume the "."
    self:advance()

    while (self:isDigit(self:peek())) do self:advance() end
  end

  self:addToken(NUMBER, tonumber(string.sub(self.source,self.start,self.current)))
end

-- When we encounter the beginning of a string, that's a
-- quotation mark ["], then we repeat this function.
function Scanner:string()
  -- Once we hit this function, we're still at the ["] in the source, we need to advance to actually capture the string
  self:advance()
  while (self:peek() ~= '"' and not self:isAtEnd() ) do
    if self:peek() == '\n' then self.line = self.line + 1 end
    self:advance()
  end

  -- we only hit this error if we never get this string terminated.
  if self:isAtEnd() then
    error("unterminated string. at line: " .. self.line)
    return
  end

  self:advance()

  self:addToken(STRING, string.sub(self.source, self.start + 1, self.current - 1))
end

-- handles whitespace.
-- ignores whitespace and advances things.
-- when encountering a new line, increments the line.
function Scanner:whitespace(character)
  local c = character
  while (c == " " or c == "\r" or c == "\t" or c == "\n") do
    if c == "\n" then
      self.line = s.line + 1
    end
    c = self:advance()
    if self:peekNext() == '\0' then
      break
    end
  end
end

-- generic match function. We use this to assume a match to the
-- next character, if we don't have a match we move on.
function Scanner:match(expected)
  if (self:isAtEnd()) then return false end
  if (self:get_current() ~= expected) then return false end

  self.current = self.current + 1;
  return true;
end

-- gets the current character, with optional peek forward or backward
function Scanner:get_current(step)
  if not step then step = 0 end -- sets default value of step
  return string.sub(self.source, (self.current+step), (self.current+step))
end

-- peek ahead to the next character
-- which is the current character. The reason why is that when
-- we call advance, it returns the current character we're thinking
-- about.
function Scanner:peek(step)
  if (self:isAtEnd()) then return '\0' end
  return self:get_current(0)
end

-- peek ahead two characters
function Scanner:peekNext()
  if (self.current + 1 > #self.source) then return '\0' end
  return self:get_current(1)
end

-- looks at the previous character
function Scanner:peekBack()
  -- short circuits to see if it's the end.
  if (self.current == #self.source) then return '\0' end
  return self:get_current(-1)
end

-- Check to see if we're getting strings or digits.
-- Finds out if the current token is alphabetic.
function Scanner:isAlpha(c)
  return (c >= 'a' and c <= 'z') or
         (c >= 'A' and c <= 'Z') or
          c == '_';
end

-- check to see if the current character is a number
function Scanner:isDigit(c)
  return c >= '0' and c <= '9'
end

-- check to see if the character is alphanumeric
function Scanner:isAlphaNumeric(c)
  return self:isAlpha(c) or self:isDigit(c)
end

-- checks to see if we're at the end of our scanning.
function Scanner:isAtEnd()
  return self.current >= #self.source
end

-- advances the scanner forward
function Scanner:advance()
  self.current = self.current + 1
  return self:get_current()
end

-- adds a token to our list of tokens.
function Scanner:addToken(type, literal)
  
  -- resolve overshooting
  local end_step = self.current
  -- if type == IDENTIFIER then
  --   end_step = self.current - 1
  -- end
  
  local text = string.sub(self.source, self.start, end_step)
  self.tokens[(#self.tokens + 1)] = Token:new(type, text, "", self.line)
end

function Scanner:scanToken()
  self.start = self.current
  local c = self:advance()
  local tokenFunction = self.scanTokenFunctions[c]
  if tokenFunction ~= nil then tokenFunction(self) end
end

Scanner.scanTokenFunctions = {

  -- Single Character tokens
  ["("] = function (s) s:addToken(LEFT_PAREN) end,
  [")"] = function (s) s:addToken(RIGHT_PAREN) end,
  ["{"] = function (s) s:addToken(LEFT_BRACE) end,
  ["}"] = function (s) s:addToken(RIGHT_BRACE) end,
  ["["] = function (s) s:addToken(LEFT_BRACKET) end,
  ["]"] = function (s) s:addToken(RIGHT_BRACKET) end,
  [","] = function (s) s:addToken(COMMA) end,
  ["="] = function (s) s:addToken(EQUAL) end,
  ["."] = function (s) s:addToken(DOT) end,
  ["-"] = function (s) s:addToken(MINUS) end,
  ["+"] = function (s) s:addToken(PLUS) end,
  [";"] = function (s) s:addToken(SEMICOLON) end,
  ["*"] = function (s) s:addToken(STAR) end,
  ["!"] = function (s)
    s:addToken(s:match('=') and BANG_EQUAL or BANG)
  end,
  ["="] = function (s)
    s:addToken(s:match('=') and EQUAL_EQUAL or EQUAL)
  end,
  ["<"] = function (s)
    s:addToken(s:match('=') and LESS_EQUAL or LESS)
  end,
  [">"] = function (s)
    s:addToken(s:match('=') and GREATER_EQUAL or GREATER)
  end,
  ["/"] = function (s)
    if (s:match('/')) then
      -- A comment goes until the end of the line.
      while ( s:peek() ~= '\n' and (not s:isAtEnd()) ) do
        s:advance()
      end
    else
      s:addToken(SLASH);
    end
  end,
  [" "]  = function (s) s:whitespace(" ") end,
  ["\r"] = function (s) s:whitespace("\r") end,
  ["\t"] = function (s) s:whitespace("\t") end,
  ["\n"] = function (s) s:whitespace("\n") end,
  ['"'] = function (s)
    s:string()
  end,
  
  -- for Alphabetic characters and digit characters we use the metatable lookups
  -- below
  
}

-- OK, so ScanTokenFunctions is like a switch statement of
-- possible token values with the functions to handle them.
-- we set a local variable of stf to represent the Scanner.
-- scanTokenFunctions table. Then we give it a supertable
-- index. Elsewhere, we set the super table of
-- scanTokenFunctions to be Scanner itself. This let's us
-- do the lookup for possible keys/indexes/options of the
-- scanTokenFunctions table, then call the corresponding
-- handler in the supertable, in this case, Scanner.
local stf, stfmt = Scanner.scanTokenFunctions, {}
stf.supertable = {}
setmetatable(stf, stfmt)

-- add an __index meta entry into the stfmt meta table for
-- Scanner.scanTokenFunctions. Use this to apply default cases.
stfmt.__index = function (table, key)
  if table.supertable:isDigit(key) then
    table.supertable:number()
  elseif table.supertable:isAlpha(key) then
    table.supertable:identifier()
  else
    error("Unexpected Character "..key..", at line "..table.supertable.line, 2)
  end
end

-- Here we make a table of our keywords and their corresponding
-- numeric values found in the token.lua file. This makes a bytecode
-- interpreter easier to work with. Luna is going to just compile
-- Luna code, so it's a bit overkill, but fun.
Scanner.keywords = {
["and"]      = AND,
["break"]    = BREAK,
["case"]     = CASE,
["continue"] = CONTINUE,
["class"]    = CLASS,
["def"]      = DEF,
["do"]       = DO,
["else"]     = ELSE,
["end"]      = END,
["enum"]     = ENUM,
["false"]    = FALSE,
["for"]      = FOR,
["fun"]      = FUN,
["goto"]     = GOTO,
["if"]       = IF,
["in"]       = IN,
["is"]       = IS,
["let"]      = LET,
["module"]   = MODULE,
["nil"]      = NIL,
["not"]      = NOT,
["or"]       = OR,
["repeat"]   = REPEAT,
["return"]   = RETURN,
["self"]     = SELF,
["super"]    = SUPER,
["switch"]   = SWITCH,
["then"]     = THEN,
["true"]     = TRUE,
["until"]    = UNTIL,
["unless"]   = UNLESS,
["when"]     = WHEN,
["while"]    = WHILE,
}
