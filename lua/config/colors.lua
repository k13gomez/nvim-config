vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.g.material_style = "deep ocean"
require("material").setup({
  -- material only styles the plugins listed here.
  plugins = {
    "gitsigns",
    "neo-tree",
    "nvim-cmp",
    "nvim-web-devicons",
    "rainbow-delimiters",
    "telescope",
    "which-key",
  },
})
vim.cmd.colorscheme("material")
vim.opt.guifont = "Monaco:h14"
