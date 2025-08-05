-- test_scanner.lua
--
-- Let's start with some Scanner tests for a scanner we haven't even made yet.
require 'dots'
require 'scanner'

-- A Sample test file
local scanner_test = Dots.Test:new("scanner", 'test/test_scanner.lua')

scanner_test:add("[test_scanner] Scanner:new", function(r)
  
  local tk = Token:new("brunette", "brown", "brownhair", 5)
  
  r:truthy((tk.type == "brunette"), "What! She's not a brunette?")

  local ok, response = pcall( function()
    v.funk(assertion_object)
  end)
  
  r:assert(not ok, "function was not executed properly")
  r:refute(ok, "function was not executed properly")
  

end)

