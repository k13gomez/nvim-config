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
Plug 'Olical/nfnl'
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
Plug 'onsails/lspkind.nvim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'junegunn/vim-easy-align' " https://github.com/junegunn/vim-easy-align
Plug 'endaaman/vim-case-master'

" copilot
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', {'do':'make tiktoken'}

" lets go
Plug 'fatih/vim-go'

" rust up
Plug 'rust-lang/rust.vim'

" lua support
Plug 'ckipp01/stylua-nvim', {'do': 'cargo install stylua'}

" mix some elixir
Plug 'elixir-tools/elixir-tools.nvim', { 'tag': 'stable' }

" terraform setup, not ideal
Plug 'deoplete-plugins/deoplete-lsp'
Plug 'Shougo/deoplete.nvim'
Plug 'hashivim/vim-terraform'
Plug 'juliosueiras/vim-terraform-completion'

" can't live without these too
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-dotenv'
Plug 'NLKNguyen/papercolor-theme'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'sheerun/vim-polyglot'
Plug 'gpanders/nvim-parinfer'
" Plug 'eraserhd/parinfer-rust', {'do':
"        \  'cargo build --release'}
Plug 'k13gomez/cmp-clojure-deps'
Plug 'tpope/vim-commentary'
Plug 'freitass/todo.txt-vim'

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
function! ClojureTapExpression()
    let testvar = expand('<cword>')
    let cmd = "(tap> " . testvar . ")"
    execute "ConjureEval " . cmd
endfunction

function! ClojureAddLibPortal()
    execute "ConjureEval (do (require 'clojure.repl.deps) (clojure.repl.deps/add-lib 'djblue/portal))"
endfunction

function! ClojureAddTapExpression()
    execute "ConjureEval (do (require 'portal.api) (portal.api/open) (add-tap #'portal.api/submit) (add-tap #'println))"
endfunction

function! ClojureRemTapExpression()
    execute "ConjureEval (do (require 'portal.api) (portal.api/open) (remove-tap #'portal.api/submit) (remove-tap #'println))"
endfunction

function! RunClojureTest()
    let testvar = expand('<cword>')
    let cmd = "(do (require '[clojure.test]) (clojure.test/test-var #'" . testvar . "))"
    execute "ConjureEval " . cmd
endfunction

function! RunClojureTests()
    let testvar = expand('<cword>')
    let cmd = "(do (require '[clojure.test]) (clojure.test/run-tests))"
    execute "ConjureEval " . cmd
endfunction

function! EvalClojureFn()
    let fnvar = expand('<cword>')
    let cmd = "(" . fnvar . ")"
    execute "ConjureEval " . cmd
endfunction

function! EnableClojureWarnOnReflection()
    execute "ConjureEval (set! *warn-on-reflection* true)"
endfunction

function! GetClojurePID()
    execute "ConjureEval (.. (java.lang.ProcessHandle/current) (pid))"
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

function! Hash()
python3 << EOF
import uuid, hashlib, vim
vim.command("normal i" + hashlib.md5(uuid.uuid4().bytes).hexdigest())
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
nnoremap <leader>tab <cmd>tabnew<cr>
nnoremap <leader>md5 <cmd>call Hash()<cr>
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
nnoremap <leader>rt <cmd>retab<cr>
" case master bindings
nnoremap <silent>case <cmd>CaseMasterRotateCase<cr>
vnoremap <silent>case <cmd>CaseMasterRotateCaseVisual<cr>
nnoremap <silent>css <cmd>CaseMasterConvertToSnake<cr>
nnoremap <silent>csk <cmd>CaseMasterConvertToKebab<cr>
nnoremap <silent>csc <cmd>CaseMasterConvertToCamel<cr>
nnoremap <silent>csp <cmd>CaseMasterConvertToPascal<cr>
nnoremap <silent>csm <cmd>CaseMasterConvertToMacro<cr>
vnoremap <silent>css <cmd>CaseMasterConvertToSnake<cr>
vnoremap <silent>csk <cmd>CaseMasterConvertToKebab<cr>
vnoremap <silent>csc <cmd>CaseMasterConvertToCamel<cr>
vnoremap <silent>csp <cmd>CaseMasterConvertToPascal<cr>
vnoremap <silent>csm <cmd>CaseMasterConvertToMacro<cr>
" Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

" Go to tab by number
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <leader>` :exe "tabn ".g:lasttab<cr>
nnoremap <leader>1 1gt<cr>
nnoremap <leader>2 2gt<cr>
nnoremap <leader>3 3gt<cr>
nnoremap <leader>4 4gt<cr>
nnoremap <leader>5 5gt<cr>
nnoremap <leader>6 6gt<cr>
nnoremap <leader>7 7gt<cr>
nnoremap <leader>8 8gt<cr>
nnoremap <leader>9 9gt<cr>
nnoremap <leader>0 :tablast<cr>

" vsnip bindings
" Expand
inoremap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
snoremap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
inoremap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
snoremap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
inoremap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
snoremap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
inoremap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
snoremap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" mouse support
set mouse=a
map <ScrollWheelDown> j
map <ScrollWheelUp> k

" custom keybindings
nnoremap <leader>lib <cmd>call FindLibraryVersions()<cr>
nnoremap <leader>tap <cmd>call ClojureTapExpression()<cr>
nnoremap <leader>port <cmd>call ClojureAddLibPortal()<cr>
nnoremap <leader>ptap <cmd>call ClojureAddTapExpression()<cr>
nnoremap <leader>pget <cmd>ConjureEval (do (require 'portal.api) (portal.api/selected))<cr>
nnoremap <leader>rtap <cmd>call ClojureRemTapExpression()<cr>
nnoremap <leader>tone <cmd>call RunClojureTest()<cr>
nnoremap <leader>tall <cmd>call RunClojureTests()<cr>
nnoremap <leader>efn <cmd>call EvalClojureFn()<cr>
nnoremap <leader>pid <cmd> call GetClojurePID()<cr>
nnoremap <leader>wrf <cmd> call EnableClojureWarnOnReflection()<cr>
nnoremap <leader>lua <cmd> lua require("stylua-nvim").format_file()<cr>
nnoremap <leader>,test <cmd>ConjureEval (clojure.test/run-tests)<cr>
nnoremap <leader>rns <cmd>ConjureEval (require (ns-name *ns*) :reload)<cr>
nnoremap <leader>rst <cmd>ConjureEval (do (rules.core/reset-rules!) (rules.core/reset-loader!))<cr>
nnoremap <leader>hto <cmd>ConjureEval (do (require '[pjstadig.humane-test-output]) (pjstadig.humane-test-output/activate!))<cr>
nnoremap <leader>todo <cmd>tabedit ~/todo.txt<cr>

" BEGIN: tabline configuration
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':h:t') . '/' . fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction

set showtabline=2
set tabline=%!Tabline()
" END: tabline configuration

" BEGIN: status line configuration
" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=gray ctermbg=cyan

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

" END: status line configuration

" mustache
let g:mustache_abbreviations = 1

" disable perl
let g:loaded_perl_provider = 0

" clojure indent
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^try', '^thread', '^cond', '^async']
let g:clojure_fuzzy_indent_blacklist =
        \ ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_special_indent_words =
   \ 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn'
let g:clojure_align_subforms = 1
let g:clojure_maxlines = 2000

" terraform setup uses deoplete for better auto completion than what we get
" from terraform-ls
let g:deoplete#enable_at_startup = 0
autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
autocmd BufWritePre *.tf lua vim.lsp.buf.format()
autocmd FileType terraform call deoplete#custom#buffer_option('auto_complete', v:true)
" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1
" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 1

" lua setup
lua require('copilot-setup')
lua require('neo-tree-setup')
lua require('treesitter-setup')
lua require('cmp-setup')
lua require('lsp-setup')
