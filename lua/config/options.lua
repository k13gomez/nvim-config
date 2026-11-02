vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.list = true
vim.opt.ruler = true
vim.opt.wildmode = "longest,list"
vim.opt.colorcolumn = "120"
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.redrawtime = 5000
vim.opt.directory = vim.fn.expand("~/.cache/vim-swapfiles//")
vim.opt.backupdir = vim.fn.expand("~/.cache/vim-backupfiles//")
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.backspace = "indent,eol,start"
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 4
vim.opt.winborder = "single"

vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- The resize chains (,>> ,>>> ,>>>>) and the visual cs* maps wait this long. which-key does not time out on pure prefixes.
vim.opt.timeoutlen = 200

-- Terminal buffers stand in for tmux, so children must not think they're inside it:
-- byobu-launch in .zshrc would nest a session, and the zsh tmux hooks would rename
-- the window hosting nvim.
vim.env.TMUX = nil
vim.env.TMUX_PANE = nil
vim.env.BYOBU_DISABLE = "1"
