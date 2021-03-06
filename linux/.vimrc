"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sleuth' " better auto index
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
" Plug 'terryma/vim-smooth-scroll'
Plug 'lucasicf/vim-smooth-scroll'
Plug 'vim-scripts/AutoComplPop'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdcommenter'
" Beautify plugins
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Syntax plugins
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'vim-python/python-syntax', {'for': 'python'}
Plug 'tomlion/vim-solidity', {'for': 'solidity'}

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

" ignore case when searching unless exists one upper case
set ignorecase
set smartcase

" Realtime searching
set incsearch

" hight light searching
set hlsearch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show number
set number

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Set cmd show
set showcmd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set colorscheme
set background=dark
colorscheme desert

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Enable status bar color
set t_Co=256

" 80 characters limits
highlight OverLength ctermbg=red ctermfg=white
autocmd FileType cpp,c,cxx,h,hpp,python,sh match OverLength /\%81v.\+/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Set ctags file name, find recursely into parent directory
set tags=tags;

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" Intelligence indent
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Toggle paste mode
set pastetoggle=<leader>p

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Fast saving
nmap <leader>w :w<CR>

" Fast quit
nmap <leader>q :bufdo bd<CR>:q<CR>

" Fast open file tree
map <leader>t :NERDTreeToggle<CR>

" Fast Tab use
noremap <silent> K :bnext<CR>
noremap <silent> J :bprevious<CR>
noremap <silent> <leader>bn :enew<CR>
noremap <silent> <expr> <leader>bd
    \ len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) >= 2 ?
    \ ":bp\|bd #<CR>" : ":bd<CR>"

" Smooth page scroll
nnoremap <silent> = :call smooth_scroll#down(&scroll, 25, 2)<CR>
nnoremap <silent> - :call smooth_scroll#up(&scroll, 25, 2)<CR>
nnoremap <silent> <Space> :call smooth_scroll#down(&scroll, 25, 2)<CR>

" Move in insert mode
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-e> <End>
imap <C-a> <Home>
imap <M-f> <C-o>w
imap <M-b> <C-o>b

" Clear highlight color
nnoremap <Esc> :noh<Return><Esc>
nnoremap <Esc>^[ <Esc>^[

" Popup menu select
inoremap <silent> <expr> <Tab> pumvisible() ? "\<Down>" : "\<Tab>"
" inoremap <silent> <expr> <ESC> pumvisible() ? "\<C-E>" : "\<ESC>"

" Visual Mode Search
vnoremap // y/<C-R>"<CR>

" Ctags search
noremap <silent> <C-]> g<C-]>

" Copy when selecting without yanking
vnoremap p "_dP

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Function, Command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

" Auto open file tree if enter a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDcommenter
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDDefaultAlign='left'

" Vim Airline themes
let g:airline_theme='luna'
let g:airline_powerline_fonts=0
let g:airline#extensions#tabline#enabled=1

" Vim Cpp Highlight
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_experimental_simple_template_highlight=1
let g:cpp_concepts_highlight=1

" Vim Python Highlight
let python_highlight_all=1

