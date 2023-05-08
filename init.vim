" Automatically install Vim-Pathogen if it is not yet installed
if empty(glob('~/.config/nvim/autoload/pathogen.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/pathogen.vim --create-dirs
                \ https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    source $MYVIMRC
endif

" Automatically install Vim-Plug if it is not yet installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" set some reasonable defaults
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase              " case insensitive
set mouse=v                 " middle-click paste with
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set list                    " show whitespaces
set ruler                   " show the ruler
set wildmode=longest,list   " get bash-like tab completions
set cc=120                   " set an 120 column border, 80 would be better for good coding style but screw it
call pathogen#infect()      " must be loaded before enabling file type
syntax on                   " syntax highlighting
filetype plugin indent on   " allow auto-indenting depending on file type
filetype plugin on          " enable plugin files depending on file type
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set redrawtime=5000         " set maximum redrawtime for syntax highlight

" Swap files and backup directory configuration
"" set noswapfile                        " disable creating swap file
set directory=~/.cache/vim-swapfiles//   " Directory for swap files.
set backupdir=~/.cache/vim-backupfiles// " Directory to store backup files.

" Call vim-plug to manage plugins
call plug#begin('~/.config/nvim/bundle')

Plug 'Olical/conjure' " https://github.com/Olical/conjure
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " https://github.com/nvim-treesitter/nvim-treesitter
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'PaterJason/cmp-conjure'

Plug 'mhinz/vim-startify'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'hashivim/vim-terraform'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-dotenv'
Plug 'NLKNguyen/papercolor-theme'
Plug 'HiPhish/nvim-ts-rainbow2'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'eraserhd/parinfer-rust'
Plug 'k13gomez/cmp-clojure-deps'

call plug#end()

" color settings
set termguicolors
set background=dark
colorscheme PaperColor
set guifont=Monaco:h14
highlight Pmenu ctermbg=Black guibg=Black

" BEGIN: Helpers
" Utility functions
function! FindLibraryVersions()
    let lib = expand('<cword>')
    let cmd = "(do (require '[clojure.edn] '[clojure.tools.deps] '[clojure.tools.deps.extensions] '[clojure.tools.deps.util.maven]) (let [mvn-repos (->> (slurp \"deps.edn\") clojure.edn/read-string :mvn/repos (merge clojure.tools.deps.util.maven/standard-repos)) types (distinct (into [:mvn :git] (clojure.tools.deps.extensions/procurer-types))) lib '" . lib . " procurer {:mvn/repos mvn-repos}] (->> (some #(clojure.tools.deps.extensions/find-versions lib nil % procurer) types) (reverse) (take 10) (vec))))"
    execute "ConjureEval " . cmd
endfunction

" BEGIN: Helpers
" Utility functions
function! RunClojureTest()
    let testvar = expand('<cword>')
    let cmd = "(do (require '[clojure.test]) (clojure.test/test-var #'" . testvar . "))"
    execute "ConjureEval " . cmd
endfunction

function! EvalClojureFn()
    let fnvar = expand('<cword>')
    let cmd = "(" . fnvar . ")"
    execute "ConjureEval " . cmd
endfunction

function! DoPrettyXML()
  silent %!xmllint --format -
endfunction
command! PrettyXML call DoPrettyXML()

function! DoPrettyJSON()
  silent %!jq .
endfunction
command! PrettyJSON call DoPrettyJSON()

function! Guid()
python3 << EOF
import uuid, vim
vim.command("normal i" + str(uuid.uuid4()))
EOF
endfunction

function! EmptyGuid()
python3 << EOF
import vim
vim.command("normal i00000000-0000-0000-0000-000000000000")
EOF
endfunction

function! DateTimeNow()
python3 << EOF
import time, vim
now = time.time()
mlsec = repr(now).split('.')[1][:3]
vim.command("normal i" + time.strftime("%Y-%m-%dT%H:%M:%S.{}%z".format(mlsec), time.localtime(now)))
EOF
endfunction
" END: Helpers

" set keybindings
set completeopt=menu,menuone,noselect
set backspace=indent,eol,start
let mapleader=","
let maplocalleader=","
nnoremap <leader>sv <cmd>source $MYVIMRC<cr>
nnoremap <leader>uid <cmd>call Guid()<cr>
nnoremap <leader>eid <cmd>call EmptyGuid()<cr>
nnoremap <leader>now <cmd>call DateTimeNow()<cr>
nnoremap <leader>xml <cmd>call DoPrettyXML()<cr>
nnoremap <leader>json <cmd>call DoPrettyJSON()<cr>
nnoremap <leader>tt <cmd>Neotree toggle position=right<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ll <cmd>set number<cr>
nnoremap <leader>nl <cmd>set nonumber<cr>
nnoremap <leader>pp <cmd>set paste<cr>
nnoremap <leader>np <cmd>set nopaste<cr>
nnoremap <leader>>> <cmd>vertical resize +5<cr>
nnoremap <leader><< <cmd>vertical resize -5<cr>
nnoremap <leader>>>> <cmd>vertical resize +10<cr>
nnoremap <leader><<< <cmd>vertical resize -10<cr>
nnoremap <leader>>>>> <cmd>vertical resize +20<cr>
nnoremap <leader><<<< <cmd>vertical resize -20<cr>
nnoremap <leader>,>> <cmd>horizontal resize +5<cr>
nnoremap <leader>,<< <cmd>horizontal resize -5<cr>
nnoremap <leader>,>>> <cmd>horizontal resize +10<cr>
nnoremap <leader>,<<< <cmd>horizontal resize -10<cr>
nnoremap <leader>,>>>> <cmd>horizontal resize +20<cr>
nnoremap <leader>,<<<< <cmd>horizontal resize -20<cr>
nnoremap <leader>repl <cmd>ConjureCljConnectPortFile<cr>
nnoremap <leader>par <cmd>ParinferOn<cr>
nnoremap <leader>nopar <cmd>ParinferOff<cr>
nnoremap <leader>gg <cmd>GitGutterEnable<cr>

" mouse support
set mouse=a
map <ScrollWheelDown> j
map <ScrollWheelUp> k

" custom keybindings
nnoremap <leader>lib <cmd>call FindLibraryVersions()<cr>
nnoremap <leader>test <cmd>call RunClojureTest()<cr>
nnoremap <leader>efn <cmd>call EvalClojureFn()<cr>
nnoremap <leader>,test <cmd>ConjureEval (clojure.test/run-tests)<cr>
nnoremap <leader>rns <cmd>ConjureEval (require (ns-name *ns*) :reload)<cr>
nnoremap <leader>rst <cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>

" lua setup
lua require('conjure-setup')
lua require('treesitter-setup')
lua require('neo-tree-setup')
lua require('lualine-setup')
