" vim:foldmethod=marker:foldlevel=0

" General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible          " Because we want VIM
set modelines=1           " Some times I use them
set history=1500          " REMEMBER
filetype plugin indent on " Load indent and plugin files for filetype
set autoread              " When file changes outside of vim
set clipboard=unnamed     " Use system clipboard to yank
set ttyfast               " Batch send characters to screen (way faster)
set lazyredraw            " Don't redraw on macros!
set confirm               " Enable dialogs instead of annoying errors

" }}}
" VIM user interface {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Different cursors for different modes
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

" Show line numbers
set number
set relativenumber

" Highlight current line
set cursorline

" Folding
set foldenable
set foldmethod=indent
set foldlevel=9999

" Show extra lines vertically and horizontally
set scrolloff=5
set sidescroll=10

" Turn on the 'wild' menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Height of the command bar
set cmdheight=2

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
if has("gui_macvim")
  augroup gui
    autocmd!
    autocmd GUIEnter * set vb t_vb=
  augroup END
endif


" }}}
" Colors and Fonts {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
set termguicolors
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

set background=dark
try
  colorscheme onedark
  let g:airline_theme='dracula'
catch
  highlight Normal ctermbg=black
  colorscheme dracula
endtry

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


" }}}
" Text, tab and indent related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete comments on line merges
set formatoptions+=j

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Soft line breaks
set linebreak
set wrap

set autoindent
set smartindent

" }}}
" Mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable highlight
map <silent> <leader><cr> :noh<cr>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Move visually between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Mappings to access buffers
" \b \f \g : go back/forward/last-used
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Toggle paste mode
map <leader>pp :setlocal paste!<cr>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" :W sudo saves the file (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Open NERDTree
map <leader>n :NERDTreeToggle<CR>


" }}}
" Behavior {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse
set mouse=a

" Select paragraphs when indented
" Technically a mapping, though
vnoremap < <gv
vnoremap > >gv

" Move by visual line
" Technically a mapping, too
noremap <buffer> <silent> <up> gk
noremap <buffer> <silent> <down> gj
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" Split direction for windows:
set splitbelow
set splitright

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Spell checking
set spelllang=en,es,fr

" Fix backspace and enable cursor wrapping
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
     else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Open NERDtree if opening a folder
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" }}}
" Language specifics {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup languages
  autocmd!
  "autocmd VimEnter * highlight clear SignColumn
  " Makefile
  autocmd BufEnter Makefile setlocal noexpandtab
  " ZSH
  autocmd BufEnter *.zsh-theme setlocal filetype=zsh
augroup END


" }}}
" Plugin settings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
set laststatus=2 " Always show the status line
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_theme='tomorrow'

" ALE (Linters and Fixers)
let g:airline#extensions#ale#enabled=1
let g:ale_fixers={
\   'javascript': ['eslint'],
\}

" Bufferline
let g:bufferline_echo = 0 " It's already on airline

" Multicursor mode (vim-multiple-cursors)
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" NERDTree
let NERDTreeAutoDeleteBuffer = 1 " Delete file buffer of file deleted via NERDTree
let NERDTreeMouseMode = 2 " Single click on directory to open
let NERDTreeChDirMode = 2 " Change the CWD with the tree root
let g:NERDTreeShowHidden=1
let g:NERDTreeSortOrder = ['\/$'] " Directories first
let g:NERDTreeNaturalSort = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "x",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : ">",
    \ "Unmerged"  : "=",
    \ "Deleted"   : "-",
    \ "Dirty"     : "x",
    \ "Clean"     : "0",
    \ "Unknown"   : "?"
    \ }

" Startify
let g:startify_files_number = 5
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_enable_unsafe = 1
let g:startify_custom_header = 'map(startify#fortune#boxed(), "\"   \".v:val")'
let g:startify_relative_path = 1
autocmd User Startified setlocal cursorline
highlight StartifyBracket ctermfg=026
highlight StartifyFooter  ctermfg=240
highlight StartifyHeader  ctermfg=110
highlight StartifyNumber  ctermfg=215
highlight StartifyPath    ctermfg=245
highlight StartifySection ctermfg=167
highlight StartifySlash   ctermfg=240
highlight StartifySpecial ctermfg=252

