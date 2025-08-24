-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", {
  desc = " Preview Markdown", -- Use your desired icon here
})

vim.keymap.set("n", "<leader>m", "", {
  desc = " Markdown", -- Group name with icon
})
