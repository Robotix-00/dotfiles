vim.g.mapleader = " "

-- general keymaps
vim.keymap.set("n", "<leader>nh", ":nohl<CR>") -- clear search results
vim.keymap.set("n", "x", '"_x') -- dont copy deleted character into register

vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split vertically
vim.keymap.set("n", "<leader>sh", "<C-w>h") -- split horizonally
vim.keymap.set("n", "<leader>se", "<C-w>=") -- split resize
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close current split

vim.keymap.set("n", "<leader>to", ":tabnew<CR>") -- new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>") -- prev tab

-- plugins - Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

-- plugins - NERDTree