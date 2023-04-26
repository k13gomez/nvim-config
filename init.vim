" Automatically install Vim-Pathogen if it is not yet installed
if empty(glob('~/.config/nvim/autoload/pathogen.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/pathogen.vim --create-dirs
                \ https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
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
set cc=80                   " set an 80 column border for good coding style
call pathogen#infect()      " must be loaded before enabling file type
syntax on                   " syntax highlighting
filetype plugin indent on   " allow auto-indenting depending on file type
filetype plugin on          " enable plugin files depending on file type
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set redrawtime=5000         " set maximum redrawtime for syntax highlight

" color settings
let macvim_skip_colorscheme=1
set termguicolors
set background=dark
colorscheme PaperColor
set guifont=Monaco:h14
highlight Pmenu ctermbg=Black guibg=Black

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
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'hashivim/vim-terraform'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dotenv'
Plug 'NLKNguyen/papercolor-theme'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'guns/vim-clojure-static'

call plug#end()

" BEGIN: status bar
" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

" Status line
" default: set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}
set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=\ %{FugitiveStatusline()}                " git status
set statusline+=%=                                       " Right Side
set statusline+=%2*\ Col:\ %02v\                         " Column number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ Line:\ %02l/%L\ (%3p%%)\            " Line number / total lines, percentage of document
set statusline+=\ [%b][0x%B]\                            " ASCII and byte code under cursor
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
" END: status bar

" BEGIN: Clojure syntax and formatting

let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with.*', '^def', '^let', '^fdef', '?', '^future', '^try', '^catch', '^finally', '^bound.*fn', '^cond', '^case', '^async', 'go', 'go-loop', 'match', 'do', 'comment']
let g:clojure_fuzzy_indent_blacklist = [] "['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'
let g:clojure_align_subforms = 1
let g:clojure_align_multiline_strings = 1
let g:clojure_maxlines = 1000

" END: Clojure syntax and formatting

" BEGIN: Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['green',       'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['green',       'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 14
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesActivate
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" END: Rainbow Parentheses

" BEGIN: Helpers
" Utility functions
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! DoPrettyJSON()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " format JSON using jq
  silent %!jq .
  " restore the filetype
  exe "set ft=" . l:origft
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
nnoremap <leader>tt <cmd>NERDTreeTabsToggle<cr>
nnoremap <leader>tf <cmd>NERDTreeFocusToggle<cr>
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

" mouse support
set mouse=a
map <ScrollWheelDown> j
map <ScrollWheelUp> k

" custom keybindings
au Filetype clojure nnoremap <leader>rst <cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>

" conjure setup
lua require('conjure')
