-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Agentic workflow ergonomics (matches the video):
--   <space>s -> project-wide text search (grep)
--   <space>f -> find files by fuzzy name
-- These bind the bare leader keys directly. They intentionally shadow LazyVim's
-- default <leader>s.. (search) and <leader>f.. (file) which-key groups so the two
-- most common actions are a single keystroke away. Dispatches through LazyVim.pick
-- so it uses the configured picker (Telescope here) and respects the project root.
local map = vim.keymap.set

map("n", "<leader>f", function()
  LazyVim.pick("files")()
end, { desc = "Find Files (root)" })

map("n", "<leader>s", function()
  LazyVim.pick("live_grep")()
end, { desc = "Grep (root)" })
