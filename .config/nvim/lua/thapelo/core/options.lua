-- vim is a global provided by Neovim
---@diagnostic disable: undefined-global

-- Set netrw listing style using vim.cmd to run Vimscript command
vim.cmd("let g:netrw_liststyle = 3")

-- Shortcut for vim.opt
local opt = vim.opt

-- Enable relative line numbers
opt.relativenumber = true
opt.number = true

-- Tab and indentation settings
opt.tabstop = 2        -- Number of visual spaces per TAB
opt.shiftwidth = 2     -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true   -- Convert tabs to spaces
opt.autoindent = true  -- Copy indent from current line when starting a new line
opt.smartindent = true

opt.wrap = false


-- Search Settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitiveopt.smartindent = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
