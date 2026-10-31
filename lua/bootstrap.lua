-- Build hooks must exist before the first vim.pack.add() so they also run on install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("PackHooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "parinfer-rust" and (kind == "install" or kind == "update") then
      vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
    end
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

local function gh(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  gh("Olical/conjure"),
  gh("Olical/nfnl"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-telescope/telescope.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-cmdline"),
  gh("hrsh7th/nvim-cmp"),
  gh("PaterJason/cmp-conjure"),
  gh("onsails/lspkind.nvim"),
  gh("mustache/vim-mustache-handlebars"),
  gh("junegunn/vim-easy-align"),
  gh("endaaman/vim-case-master"),

  gh("github/copilot.vim"),
  gh("stevearc/conform.nvim"),

  gh("mhinz/vim-startify"),
  gh("tpope/vim-fugitive"),
  gh("lewis6991/gitsigns.nvim"),
  gh("marko-cerovac/material.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("HiPhish/rainbow-delimiters.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-neo-tree/neo-tree.nvim"),
  gh("guns/vim-sexp"),
  gh("eraserhd/parinfer-rust"),
  gh("k13gomez/cmp-clojure-deps"),
  gh("folke/which-key.nvim"),
})
