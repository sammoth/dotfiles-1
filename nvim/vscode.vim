set nocompatible
set hidden
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

set cmdheight=2
set shortmess=aI
set textwidth=0 wrapmargin=0

set encoding=utf-8
setglobal fileencoding=utf-8

set cursorline
set laststatus=2
set smartcase
set ignorecase
set showmatch
set gdefault
"set hlsearch
set backspace=indent,eol,start
set wildmenu wildmode=full
set foldmethod=manual
set mouse=a

set omnifunc=syntaxcomplete#Complete

nmap <F8> :TagbarToggle<CR>

nmap <silent> <A-e> :wincmd k<CR>
nmap <silent> <A-n> :wincmd j<CR>
nmap <silent> <A-y> :wincmd h<CR>
nmap <silent> <A-o> :wincmd l<CR>

set ttimeout
set ttimeoutlen=100
set timeout
set timeoutlen=100

set undofile                " Save undo's after file closes
set undodir=~/.cache/nvim/undo/
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

set backupdir=~/.cache/nvim/backup/

source ~/.config/nvim/workman.vim

