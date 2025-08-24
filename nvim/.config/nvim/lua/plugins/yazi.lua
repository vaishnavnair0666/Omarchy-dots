-- This file is used to define the dependencies of this plugin when the user is
-- using lazy.nvim.
--
-- If you are curious about how exactly the plugins are used, you can use e.g.
-- the search functionality on Github.
--
--https://lazy.folke.io/packages#lazy

---@module "lazy"
---@module "yazi"

---@type LazySpec
return {
  -- Needed for file path resolution mainly
  --
  -- https://github.com/nvim-lua/plenary.nvim/
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "mikavilpas/yazi.nvim",
    ---@type YaziConfig | {}
    opts = {
      change_neovim_cwd_on_close = true,
      -- the type of border to use for the floating window. Can be many values,
      -- including 'none', 'rounded', 'single', 'double', 'shadow', etc. For
      -- more information, see :h nvim_open_win
      yazi_floating_window_border = "rounded",
    },
    cmd = {
      "Yazi",
      "Yazi cwd",
    },
    keys = {
      { "<leader>fY", "<cmd>Yazi<cr>", desc = "Yazi" },
      { "<leader>fy", "<cmd>Yazi cwd<cr>", desc = "Yazi cwd" },
    },
  },
}
