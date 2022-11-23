vim.opt.termguicolors = true
vim.opt.background = "dark"
-- vim.cmd("highlight Normal guibg=none")

local status, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not status then
	print("Colorscheme not found!")
	return
end
