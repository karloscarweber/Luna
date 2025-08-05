-- test_scanner.lua
--
-- Let's start with some Scanner tests for a scanner we haven't even made yet.
requite 'dots'
require 'src/scanner'

-- A Sample test file
local scanner_test = Dots.Test:new("scanner", 'test/test_scanner.lua')

scanner_test:add("[test_scanner] Scanner:new", function(r)
  
  local tk = Token("brunette", "brown", "brownhair", 5)
  r:truthy((tk.type == "brunnette"), "What! She's not a brunette?")
end)

