" vim:foldmethod=marker:foldlevel=0

" General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Not Vi
set nocompatible

" Use modelines
set modelines=1

" Sets how many lines of history VIM has to remember
set history=1500

" Enable filetype plugins
filetype plugin indent on

" Set to auto read when a file is changed from the outside
set autoread

" :W sudo saves the file (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Open NERDTree
map <leader>n :NERDTreeToggle<CR>

" Clipboard-able
set clipboard=unnamed


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

" Lower the updatetime (mostly for git stuff)
set updatetime=1000

set ttyfast

" Enable confirm dialogs
set confirm

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

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

set whichwrap+=<,>,h,l

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
if has("gui_macvim")
  autocmd GUIEnter * set vb t_vb=
endif

" Open NERDtree if opening a folder
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif


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
    \ "Clean"     : "O",
    \ "Unknown"   : "?"
    \ }

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
" Status line {{{
""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_theme='tomorrow'

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

" Select paragraphs when indented
vnoremap < <gv
vnoremap > >gv

" }}}
" Visual mode related {{{
""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" }}}
" Moving around, tabs, windows and buffers {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse
set mouse=a

" Show tabline
set showtabline=1

" Split direction for windows:
set splitbelow
set splitright

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move by visual line
noremap  <buffer> <silent> <up> gk
noremap  <buffer> <silent> <down> gj
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj

" Mappings to access buffers
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete file buffer of file deleted via NERDTree
let NERDTreeAutoDeleteBuffer = 1

let NERDTreeMouseMode = 2 " Single click on directory to open
let NERDTreeChDirMode = 2 " Change the CWD with the tree root
let NERDTreeHijackNetrw = 1



" }}}
" Linting and Spell checking {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

set spelllang=en,es,fr


let g:airline#extensions#ale#enabled=1

let g:ale_fixers={
\   'javascript': ['eslint'],
\}

" }}}
" Misc {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Multicursor mode (vim-multiple-cursors)
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" }}}
" Helper functions {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  endif
  return ''
endfunction

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

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Toggle between number and relativenumber
function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun


" Language specifics
augroup configgroup
  autocmd!
  autocmd VimEnter * highlight clear SignColumn
  autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md :call CleanExtraSpaces()

	" Java
  autocmd FileType java setlocal noexpandtab
  autocmd FileType java setlocal list
  autocmd FileType java setlocal listchars=tab:+\ ,eol:-
  autocmd FileType java setlocal formatprg=par\ -w80\ -T4

  " Makefile
  autocmd BufEnter Makefile setlocal noexpandtab
augroup END

