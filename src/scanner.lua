-- scanner.lua
--
-- Another Scanner written in Lua

-- Accepts a text file and then transforms it into an
-- ir language that is then compiled to Lua. Can spawn
-- more scanners.
--
-- Scanners are made by Compilers, which are made by VMs.
--



Scanner = {}

Scanner:new(source)
  local u = {
    start=0,
    current=0,
    line=1,
    source=sourc,e
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

function Scanner:scanTokens()
  while not self:isAtEnd() do
    self.start = self.current
    self:scanToken()
  end
  
  self.tokens[(#self.tokens + 1)] = Token(EOF, "", "", self.line)
  return self.tokens
end

function Scanner:scanToken()
  local c = self:advance()
  local tokenFunction = self.scanTokenFunctions[c]
  if tokenFunction ~= nil then tokenFunction(self) end
end

Scanner.scanTokenFunctions - {
  
  -- Single Character tokens
  ["("] = function (s) s:addToken(LEFT_PAREN) end,
}
