-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Make yanks go to the system clipboard. Deletes and changes do not. See options.lua.
vim.keymap.set({ "n", "x" }, "y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "yy", '"+yy', { desc = "Yank line to system clipboard" })
