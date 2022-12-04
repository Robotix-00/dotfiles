vim.opt.guicursor = ""

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.exrc = true

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8

--line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- what the dog doing?
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.iskeyword:append("-") -- make - count as a word

-- folding
vim.opt.foldmethod="marker"
