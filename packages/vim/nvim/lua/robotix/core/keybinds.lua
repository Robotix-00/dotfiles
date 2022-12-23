vim.g.mapleader = " "

-- general keymaps
vim.keymap.set("n", "<leader>nh", vim.cmd.nohl) -- clear search results
vim.keymap.set("n", "x", '"_x') -- dont copy deleted character into register

vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split horizonally
vim.keymap.set("n", "<leader>se", "<C-w>=") -- split resize
vim.keymap.set("n", "<leader>sx", vim.cmd.close) -- close current split

vim.keymap.set("n", "<leader>to", vim.cmd.tabnew) -- new tab
vim.keymap.set("n", "<leader>tx", vim.cmd.tabclose) -- close tab
vim.keymap.set("n", "<leader>tn", vim.cmd.tabn) -- next tab
vim.keymap.set("n", "<leader>tp", vim.cmd.tabp) -- prev tab

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-t>", vim.cmd.Ex)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
