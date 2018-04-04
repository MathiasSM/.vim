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
" Different cursors for different modes. Tmux-compatible
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
set foldlevelstart=5

" Show extra lines vertically and horizontally
set scrolloff=5
set sidescroll=10

" Turn on the 'wild' menu
set wildmenu

" Ignore ignorable files
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Some extra height of the command bar, for convenience
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
syntax on

" Enable true colors
set termguicolors
" Workaround for tmux
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

set background=dark
colorscheme one
"let g:airline_theme='dracula'

set encoding=utf8

" Use italized comments *-*
highlight Comment        cterm=italic
highlight vimLineComment cterm=italic

" Use Unix as the standard file type
set ffs=unix,dos,mac


" }}}
" Text, tab and indent related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions+=j  " Delete comments on line merges
set expandtab         " Use spaces instead of tabs
set smarttab
set shiftwidth=2      " I like short tabs
set tabstop=2
set nowrap            " Soft wrap is cooler, but nowrap by default
set linebreak         " Be smart about where to wrap
set display+=lastline " Display part of those wrapped. Avoid jumps
set autoindent        " Same indent on newline
set smartindent       " Insert or remove indentation automatically

" Prettier characters on utf8
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif
" }}}
" Mappings {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable highlight
map <silent> <leader><cr> :noh<cr>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSearch('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSearch('', '')<CR>?<C-R>=@/<CR><CR>
function! VisualSearch(direction, extra_filter) range
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

" Use space to fold/unfold
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

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

" Move lines around
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

" Add empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" Quickly edit a macro
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

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

" Know the current syntax group
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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

" Sane n/N behavior
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Saner <c-l> (clean screen)
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" Split direction for windows:
set splitbelow
set splitright

" Temporary files go under .vim/files
if !isdirectory($HOME.'/.vim/files') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files')
endif
" Backup files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
" Swap files
set directory   =$HOME/.vim/files/swap/
set updatecount =100
" Undo files
set undofile
set undodir     =$HOME/.vim/files/undo/
" Viminfo files
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

" Return to last edit position when opening files
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Mark code and header file automatically
autocmd BufLeave *.{c,cpp} mark C
autocmd BufLeave *.{h,hpp} mark H

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
let g:airline_detect_spelllang=0 " Don't show the lang
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }

" Airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.crypt = '⼛'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'P'
let g:airline_symbols.notexists = ' ∄'
let g:airline_symbols.whitespace = ''

" Whitespace problems in airline
let g:airline#extensions#whitespace#trailing_format = 'tr:%s'
let g:airline#extensions#whitespace#mixed_indent_format = 'mix:%s:'
let g:airline#extensions#whitespace#long_format = 'l:%s'
let g:airline#extensions#whitespace#mixed_indent_file_format = 'mix:%s'

let g:airline#extensions#branch#format = 2 " Truncate branch names to be a/b/c/branch
let g:airline#extensions#tabline#formatter = 'jsformatter' " Better path format
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " Skip if set to utf-8[unix]

let g:airline_theme='tomorrow'

" ALE (Linters and Fixers) disabled by default
let g:airline#extensions#ale#enabled=0
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

" Ack.vim (Use the_silver_searcher)
let g:ackprg = 'ag --vimgrep'

