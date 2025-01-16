require "nvchad.options"

-- add yours here!
local opt = vim.opt

-- Enable spell checking with more configuration
opt.spell = true
opt.spelllang = { "en_us" }
opt.spellsuggest = { "best", 9 } -- Show 9 suggestions
opt.spelloptions = "camel" -- Detect camelCase
opt.spellcapcheck = "" -- Don't check for capital letters at start of sentence
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add" -- Custom spell file

-- Add these lines for window titles
opt.title = true                -- Enable window title
opt.titlestring = "%t"          -- Show just the file name
opt.winbar = "%=%m %f"         -- Show filename in window bar
opt.laststatus = 3             -- Global statusline

-- Create spell directory if it doesn't exist
local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Add these lines to your existing options
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
