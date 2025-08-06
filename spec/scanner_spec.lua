-- test_scanner.lua
--
-- Let's start with some Scanner tests for a scanner we haven't even made yet.
-- require 'dots'
require 'scanner'

describe("Scanner", function()
  local source, scanner = "This is my boomstick", {}
  scanner = Scanner:new(source)
  
  it("can be initialized, and has it's source", function()
    assert.are.equals(scanner.source, source)
  end)
  
  it("can scan tokens", function()
    local tokens = {}
    assert.has_no.errors(function()
      tokens = scanner:scan()
    end)
    
    assert.is_true(#tokens > 0)
    assert.are.equals(#tokens, 5)
  end)
end)
--
-- -- A Sample test file
-- local scanner_test = Dots.Test:new("scanner", 'test/test_scanner.lua')
--
-- scanner_test:add("[test_scanner] Scanner:new", function(r)
  --
  -- -- local tk = Token:new("brunette", "brown", "brownhair", 5)
  -- -- r:assert((tk.type == "brunette"), "What! She's not a brunette?")
  -- --
  -- -- -- test execution of
  -- -- local ok, response = pcall( function()
  -- --   v.funk(assertion_object)
  -- -- end)
  -- -- r:assert(not ok, "function was not executed properly")
  -- -- r:refute(ok, "function was not executed properly")
  --   local source, scanner = "This is my boomstick", {}
  --   scanner = Scanner:new(source)
  --
  --   r:assert((scanner.source == source), "source is not the same. Scanner failed to be mae.")
--
-- end)
--
--
--
-- scanner_test:add("[test_scanner] Scanner:scanTokens", function(r)
  --
  -- local source, scanner, token_count = "This is my boomstick", {}, 0
  -- scanner = Scanner:new(source)
  -- scanner:scanTokens()
  -- print("whatever")
  -- print("whatever")
  -- print("whatever")
  -- print("whatever")
  -- token_count = #scanner.tokens
  -- print(string.format("tokens: %d", token_count))
  --
  -- r:assert((token_count == 10), string.format("Not enough tokens. Found %d", token_count))
  --
--
  -- -- local source = "this is some source()"
  -- --
  -- -- r:assert()
  --
-- end)

