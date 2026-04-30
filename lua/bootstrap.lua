vim.cmd([[
  if empty(glob('~/.config/nvim/autoload/pathogen.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/pathogen.vim --create-dirs
                \ https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    source $MYVIMRC
  endif

  if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif

  call pathogen#infect()
]])

vim.cmd([[
  call plug#begin('~/.config/nvim/bundle')

  Plug 'Olical/conjure'
  Plug 'Olical/nfnl'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'PaterJason/cmp-conjure'
  Plug 'onsails/lspkind.nvim'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'junegunn/vim-easy-align'
  Plug 'endaaman/vim-case-master'

  Plug 'github/copilot.vim'
  Plug 'fatih/vim-go'
  Plug 'ckipp01/stylua-nvim', {'do': 'cargo install stylua'}

  Plug 'mhinz/vim-startify'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'HiPhish/rainbow-delimiters.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'nvim-neo-tree/neo-tree.nvim'
  Plug 'guns/vim-sexp'
  Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
  Plug 'k13gomez/cmp-clojure-deps'
  Plug 'folke/which-key.nvim'

  call plug#end()
]])
