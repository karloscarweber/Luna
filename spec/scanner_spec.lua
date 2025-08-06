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
    -- scanner:spitTokens()
    assert.are.equals(#tokens, 5)
  end)
  
  it("scans the proper tokens", function()
    local scanner, tokens = Scanner:new("()[]{}+-="), {}
    tokens = scanner:scan()
    
    assert.are.equals(tokens[1].type, LEFT_PAREN)
    assert.are.equals(tokens[2].type, RIGHT_PAREN)
    assert.are.equals(tokens[3].type, LEFT_BRACKET)
    assert.are.equals(tokens[4].type, RIGHT_BRACKET)
    assert.are.equals(tokens[5].type, LEFT_BRACE)
    assert.are.equals(tokens[6].type, RIGHT_BRACE)
    assert.are.equals(tokens[7].type, PLUS)
    assert.are.equals(tokens[8].type, MINUS)
    assert.are.equals(tokens[9].type, EQUAL)
  end)
  
  it("scans keywords correctly", function()
    local scanner, tokens = Scanner:new("and break case continue class def do else end enum false for fun goto if in is let module nil not or repeat return self super switch then true until unless when while"), {}
    tokens = scanner:scan()
    
    assert.are.equals("and", tokens[1].lexeme)
    assert.are.equals(Scanner.keywords["and"], tokens[1].type)
    
    assert.are.equals("break", tokens[2].lexeme)
    assert.are.equals("case", tokens[3].lexeme)
    assert.are.equals("continue", tokens[4].lexeme)
    assert.are.equals(Scanner.keywords["break"], tokens[2].type)
    assert.are.equals(Scanner.keywords["case"], tokens[3].type)
    assert.are.equals(Scanner.keywords["continue"], tokens[4].type)
    
    assert.are.equals("class", tokens[5].lexeme)
    assert.are.equals("def", tokens[6].lexeme)
    assert.are.equals("do", tokens[7].lexeme)
    assert.are.equals(Scanner.keywords["class"], tokens[5].type)
    assert.are.equals(Scanner.keywords["def"], tokens[6].type)
    assert.are.equals(Scanner.keywords["do"], tokens[7].type)
      
    assert.are.equals("else", tokens[8].lexeme)
    assert.are.equals("end", tokens[9].lexeme)
    assert.are.equals("enum", tokens[10].lexeme)
    assert.are.equals(Scanner.keywords["else"], tokens[8].type)
    assert.are.equals(Scanner.keywords["end"], tokens[9].type)
    assert.are.equals(Scanner.keywords["enum"], tokens[10].type)
    
    assert.are.equals("false", tokens[11].lexeme)
    assert.are.equals("for", tokens[12].lexeme)
    assert.are.equals("fun", tokens[13].lexeme)
    assert.are.equals(Scanner.keywords["false"], tokens[11].type)
    assert.are.equals(Scanner.keywords["for"], tokens[12].type)
    assert.are.equals(Scanner.keywords["fun"], tokens[13].type)
    
    assert.are.equals("goto", tokens[14].lexeme)
    assert.are.equals("if", tokens[15].lexeme)
    assert.are.equals("in", tokens[16].lexeme)
    assert.are.equals(Scanner.keywords["goto"], tokens[14].type)
    assert.are.equals(Scanner.keywords["if"], tokens[15].type)
    assert.are.equals(Scanner.keywords["in"], tokens[16].type)
    
    assert.are.equals("is", tokens[17].lexeme)
    assert.are.equals("let", tokens[18].lexeme)
    assert.are.equals("module", tokens[19].lexeme)
    assert.are.equals(Scanner.keywords["is"], tokens[17].type)
    assert.are.equals(Scanner.keywords["let"], tokens[18].type)
    assert.are.equals(Scanner.keywords["module"], tokens[19].type)
    
    assert.are.equals("nil", tokens[20].lexeme)
    assert.are.equals("not", tokens[21].lexeme)
    assert.are.equals("or", tokens[22].lexeme)
    assert.are.equals(Scanner.keywords["nil"], tokens[20].type)
    assert.are.equals(Scanner.keywords["not"], tokens[21].type)
    assert.are.equals(Scanner.keywords["or"], tokens[22].type)
    
    assert.are.equals("repeat", tokens[23].lexeme)
    assert.are.equals("return", tokens[24].lexeme)
    assert.are.equals("self", tokens[25].lexeme)
    assert.are.equals(Scanner.keywords["repeat"], tokens[23].type)
    assert.are.equals(Scanner.keywords["return"], tokens[24].type)
    assert.are.equals(Scanner.keywords["self"], tokens[25].type)
    
    assert.are.equals("super", tokens[26].lexeme)
    assert.are.equals("switch", tokens[27].lexeme)
    assert.are.equals("then", tokens[28].lexeme)
    assert.are.equals(Scanner.keywords["super"], tokens[26].type)
    assert.are.equals(Scanner.keywords["switch"], tokens[27].type)
    assert.are.equals(Scanner.keywords["then"], tokens[28].type)
    
    assert.are.equals("true", tokens[29].lexeme)
    assert.are.equals("until", tokens[30].lexeme)
    assert.are.equals("unless", tokens[31].lexeme)
    assert.are.equals(Scanner.keywords["true"], tokens[29].type)
    assert.are.equals(Scanner.keywords["until"], tokens[30].type)
    assert.are.equals(Scanner.keywords["unless"], tokens[31].type)
    
    assert.are.equals("when", tokens[32].lexeme)
    assert.are.equals("while", tokens[33].lexeme)
    assert.are.equals(Scanner.keywords["when"], tokens[32].type)
    assert.are.equals(Scanner.keywords["while"], tokens[33].type)
    
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

