-- test_scanner.lua
--
-- Let's start with some Scanner tests for a scanner we haven't even made yet.
-- require 'dots'
require 'scanner'

describe("Scanner", function()
  local source, scanner = "This is my boomstick", {}
  scanner = Scanner:new(source)
  
  it("can be initialized, and has it's source", function()
    assert.are.equals(scanner.source, (source.."\0"))
  end)
  
  
  it("Adds null terminating byte when source doesn't have one.", function()
    local src = "This is my boomstick"
    local scan = Scanner:new(src)
    assert.are_not.equals(scan.source, src)
  end)
  
  it("can scan tokens", function()
    local source, scanner, tokens = "This is my boomstick", {}, {}
    scanner = Scanner:new(source)
    
    assert.has_no.errors(function()
      tokens = scanner:scan()
    end)
    
    assert.is_true(#tokens > 0)
    -- scanner:spitTokens()
    assert.are.equals(5, #tokens)
  end)
  
  
  it("scans the proper operator and symbol tokens", function()
    local scanner, tokens = Scanner:new("()[]{}+-="), {}
    tokens = scanner:scan()
    
    assert.are.equals(LEFT_PAREN, tokens[1].type)
    assert.are.equals(RIGHT_PAREN, tokens[2].type)
    assert.are.equals(LEFT_BRACKET, tokens[3].type)
    assert.are.equals(RIGHT_BRACKET, tokens[4].type)
    assert.are.equals(LEFT_BRACE, tokens[5].type)
    assert.are.equals(RIGHT_BRACE, tokens[6].type)
    assert.are.equals(PLUS, tokens[7].type)
    assert.are.equals(MINUS, tokens[8].type)
    assert.are.equals(EQUAL, tokens[9].type)
    assert.are.equals(EOF, tokens[10].type)
  end)
  
  it("scans double character operators properly", function()
    local scanner, tokens = Scanner:new("<= >= != == "), {}
    tokens = scanner:scan()
    
    assert.are.equals(LESS_EQUAL, tokens[1].type)
    assert.are.equals(GREATER_EQUAL, tokens[2].type)
    assert.are.equals(BANG_EQUAL, tokens[3].type)
    assert.are.equals(EQUAL_EQUAL, tokens[4].type)
    assert.are.equals(EOF, tokens[5].type)
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
  
  it("scans strings correctly", function()
    local scanner, tokens = Scanner:new("\"keyboard wizard\""), {}
    tokens = scanner:scan()
    
    assert.are.equals("\"keyboard wizard\"\0", tokens[1].lexeme)
    assert.are.equals(STRING, tokens[1].type)
  end)
  
end)

