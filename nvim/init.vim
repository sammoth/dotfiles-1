" for gnvim to work around colour issue in the cmdline
" set the font late enough in the startup process
autocmd VimResized * set guifont=Fira\ Code\ Medium:h10 | au! VimResized
autocmd ColorScheme * set guifont=Fira\ Code\ Medium:h10

set nocompatible
set hidden
nnoremap <SPACE> <Nop>

""" vim-plug begin
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-dispatch'
Plug 'noahfrederick/vim-hemisu'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'rainglow/vim'
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'tikhomirov/vim-glsl'
Plug 'p7g/vim-bow-wob'
Plug 'Lokaltog/vim-monotone'
Plug 'vim-scripts/otaku'
Plug 'LuRsT/dvo.vim'
Plug 'scolsen/bernhard'
Plug 'arzg/vim-plan9'
Plug 'smallwat3r/vim-efficient'
Plug 'cormacrelf/vim-colors-github'
Plug 'smallwat3r/vim-simplicity'

call plug#end()
""" vim-plug end


filetype plugin indent on
set cmdheight=2
set shortmess=aI
set textwidth=0 wrapmargin=0

set encoding=utf-8
setglobal fileencoding=utf-8

set termguicolors
colorscheme bow-wob
syntax on
set background=dark

let g:airline_theme="minimalist"

set cursorline
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set wrap
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

"set relativenumber
"set number
"set numberwidth=5

"set listchars=eol:  

set ttimeout
set ttimeoutlen=100
set timeout
set timeoutlen=100

set undofile                " Save undo's after file closes
set undodir=~/.cache/nvim/undo/
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

set backupdir=~/.cache/nvim/backup/

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki

let g:racer_cmd = "~/.cargo/bin/racer"

source ~/.config/nvim/workman.vim

"hi Search guifg=white guibg=#BB0000
"hi IncSearch guifg=white guibg=#EE0000
"hi IncSearchMatch guifg=white guibg=#005F87
"hi Search cterm=NONE ctermfg=white ctermbg=red
"hi Pmenu ctermfg=2 ctermbg=3 guifg=#ffffff guibg=#AA66CC
"hi LineNr guifg=#445577
"hi NonText guifg=#445577
"hi CursorLineNr guifg=white
"hi NERDTreeDir guifg=#87d7ff
"hi NERDTreeUp guifg=#87d7ff
"hi Folded guifg=#c8c7d5 guibg=#585480
"hi WildMenu guifg=white guibg=#cc4455
"hi Visual guibg=#AFFFFF guifg=blue
"hi StatusLine guibg=white guifg=black
"hi clear SignColumn
"set colorcolumn=80
"hi ColorColumn guibg=#2C1D30
""hi CursorLine guibg=#333333
"hi MatchParen guibg=red guifg=white

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
