-- test/test.lua

-- patch the package loading paths to get our libs.
package.path = "./src/?.lua;".."./?/init.lua;".."./?/init.lua;".."./lib/?.lua;".."./lib/?/init.lua;"..package.path
require 'dots'

-- Setup Testing Context
local context = Dots:new()
local tasky = Dots.Task:new("Basic Test", Dots.tests_in('test'))
context:add(tasky)
context:execute()

-- parse each one in order, logging syntax errors.

-- Add green dots for successful tests.

-- print the logged errors at the end.
