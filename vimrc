" ********************************************************************
" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

" Helpful information: cursor position in bottom right, line numbers on left
set ruler

" Enable filetype detection and syntax hilighting
syntax on
filetype on
filetype indent on
filetype plugin on

" Indent as intelligently as vim knows how
set smartindent

" Show multicharacter commands as they are being typed
set showcmd
" *******************************************************************
" Add your own changes below...

colorscheme euler

set tabstop=2
set shiftwidth=2
set expandtab

"will wrap lines longer than 80 char to new visual line
set wrap

"limit text lines to 80 characters. Will create new line when this is
"exceeded.
"set textwidth=80

filetype indent on
set cindent

set wrap
set linebreak
set nolist  " list breaks word wrapping :\
set shortmess+=I  " no startup screen
set colorcolumn=81
set wildmode=list:longest

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/ "\%#\@<!$/

if has("autocmd")
  au BufNewFile,BufRead *.tex,*.cls set filetype=tex
  au BufNewFile,BufRead *.sig set filetype=sml
endif

call pathogen#infect()

set nu

nnoremap * *<C-o>
set hlsearch

set spell
setlocal spell spelllang=en_us

if !exists(":W")
    command W execute "w"
endif

set splitbelow
set splitright

let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"
au BufEnter *.hs compiler ghc

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

