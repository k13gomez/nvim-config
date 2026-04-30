vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
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
vim.opt.ttyfast = true
vim.opt.redrawtime = 5000
vim.opt.directory = vim.fn.expand("~/.cache/vim-swapfiles//")
vim.opt.backupdir = vim.fn.expand("~/.cache/vim-backupfiles//")
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.backspace = "indent,eol,start"
vim.opt.mouse = "a"

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
vim.cmd("filetype plugin on")

vim.g.mapleader = ","
vim.g.maplocalleader = " "
