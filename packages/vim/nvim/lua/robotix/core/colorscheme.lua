vim.opt.termguicolors = true
vim.opt.background = "dark"

local status, _ = pcall(vim.cmd, "colorscheme gruvbox")
if not status then
	print("Colorscheme not found!")
	return
end
