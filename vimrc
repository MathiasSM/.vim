" vim:foldmethod=marker:foldlevel=0

" External
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
  exe 'source' f
endfor

"
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible          " Because we want VIM
set modelines=1           " Some times I use them
set history=5000          " REMEMBER
filetype plugin indent on " Load indent and plugin files for filetype
set autoread              " When file changes outside of vim
set clipboard=unnamedplus " Use system clipboard to yank
set ttyfast               " Batch send characters to screen (way faster)
set lazyredraw            " Don't redraw on macros!
set confirm               " Enable dialogs instead of annoying errors
set hidden                " Allows to keep several non-saved buffers

" VIM user interface
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

" Highlight current line
set cursorline

" Set terminal title
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" Show line numbers
set number
set relativenumber

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
set wildignore=*/.DS_Store                                  " macOS
set wildignore+=*~,*.swp,*.bak                              " Backups
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*                   " Versioning systems
set wildignore+=*/node_modules/*                            " Big vendor dirs
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf " Not-code
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot            " Fonts
set wildignore+=*.class,*.0,*.pyc,*.hi,*.o                  " Compiled code
set wildignore+=*.stack-work                                " Build directories

" Be able to change the tab name
set guitablabel=%N\ %f

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


" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax on

" Enable true colors
set termguicolors
" Workaround for tmux
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

let g:airline_theme='dracula'
colorscheme one
let g:one_allow_italics = 1
set background=dark

" Set a lighter color for inactive windows
highlight ColorColumn ctermbg=0 guibg=#414c61

let g:terminal_ansi_colors = [
      \ '#1E2127', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#ABB2BF',
      \ '#5C6370', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#FFFFFF' ]

set encoding=utf8

" Use italized comments *-*
highlight Comment        cterm=italic
highlight vimLineComment cterm=italic

" Use Unix as the standard file type
set ffs=unix,dos,mac

if has("gui_running")
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Hack\ 14
  elseif has("gui_photon")
    set guifont=Hack:s14
  elseif has("gui_kde")
    set guifont=Hack/14/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  else " Windows
    set guifont=Hack:h14:cDEFAULT
  endif
endif


" Text, tab and indent related
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


" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Let's see how it goes
inoremap jk <Esc>

" Disable highlight
map <silent> <leader><cr> :noh<cr>

" Global replace matches to last search
nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'

" Quickly edit a macro
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" :W sudo saves the file (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Open NERDTree
map <leader>n :NERDTreeToggle<CR>

" Saner <c-l> (clean screen)
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Global search
nmap S :%s//g<LEFT><LEFT>

" Use space to fold/unfold
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

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

" Movement
" Move by visual line
noremap <silent> k gk
noremap <silent> j gj

" Move visually between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Move only via hjkl
map <up>    <nop>
map <down>  <nop>
map <left>  <nop>
map <right> <nop>

" Navigate
" Move lines around
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

" Quickly navigate linting errors
nnoremap ]a :ALENextWrap<cr>
nnoremap [a :ALEPreviousWrap<cr>

" Mappings to navigate buffers
" \b \f \g : go back/forward/last-used
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>g :e#<CR>
"
" Toggle behavior modes
" Toggle paste mode
map <leader>pp :setlocal paste!<cr>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Toggle linters
map <leader>aa :ALEToggle<cr>
"
" YouCompleteMe Magic
nnoremap <leader>g  :YcmCompleter GoTo<CR>
nnoremap <leader>G  :YcmCompleter GoToImprecise<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gT :YcmCompleter GetTypeImprecise<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>
nnoremap <leader>gD :YcmCompleter GetDocImprecise<CR>
nnoremap <leader>fi :YcmCompleter FixIt<CR>
"
" Know the current syntax group
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
"

" Behavior
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse
set mouse=a

" Select paragraphs when indented
" Technically a mapping, though
vnoremap < <gv
vnoremap > >gv

" Sane n/N behavior
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Searching
set ignorecase smartcase hlsearch incsearch

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
set directory   =$HOME/.vim/files/swap//
set updatecount =50 " Rotates swaps on this number of keystrokes
" Undo files
set undolevels=5000
set undofile
set undodir     =$HOME/.vim/files/undo/
" Viminfo files
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

augroup Behavior
  autocmd!
  " Re-read external changes
  autocmd FocusGained,BufEnter * :silent! !
  " Return to last edit position when opening files
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  " Reload vimrc on every save
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

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
"

" Open NERDtree if opening a folder
augroup Behavior
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END

set exrc " Allow project-specific configuration file

" Language specifics
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup languages
  autocmd!
  " C, C++: Mark code and header file automatically
  autocmd BufLeave *.{c,cpp} mark C
  autocmd BufLeave *.{h,hpp} mark H
  " Haskell Alex/Happy: syntax
  autocmd BufEnter *.x,*.y setlocal filetype=haskell
  autocmd BufEnter *.xmobarrc setlocal filetype=haskell
  " Javascript Flow: syntax
  autocmd BufEnter *.js.flow setlocal filetype=javascript
  " Ledger files
  autocmd BufEnter *.ldg,*.ledger setlocal filetype=ledger | comp ledger
  " Makefile
  autocmd Filetype Makefile setlocal noexpandtab
  " Pandoc: syntax for markdown
  autocmd BufEnter *.md setlocal filetype=pandoc
  " ZSH: syntax
  autocmd BufEnter *.zsh-theme setlocal filetype=zsh
augroup END


" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ack.vim (Use the_silver_searcher)
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Airline
set laststatus=2 " Always show the status line
let g:airline_exclude_preview = 0     " Don't manage previews' statuslines
let g:airline_inactive_collapse=1     " Collapse left widgets in inactive windows
let g:airline_skip_empty_sections = 1 " Skip empty widgets
let g:airline_detect_spelllang=0      " Don't show the lang
let g:airline_theme='tomorrow'
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
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.readonly = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.notexists = ' ∄'
let g:airline_symbols.spell = 'Ꞩ'


" Whitespace problems in airline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#trailing_format = 'tr:%s'
let g:airline#extensions#whitespace#mixed_indent_format = 'mix:%s:'
let g:airline#extensions#whitespace#long_format = 'l:%s'
let g:airline#extensions#whitespace#mixed_indent_file_format = 'mix:%s'

" Other (included) extensions
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#sha1_len = 5
let g:airline#extensions#branch#format = 2 " Truncate branch names to be a/b/c/branch
function! AirlineInit()
  call airline#parts#define_raw('linenr', '%l')
  call airline#parts#define_accent('linenr', 'bold')
  let g:airline_section_z = airline#section#create(['%3p%% ',
              \ g:airline_symbols.linenr .' ', 'linenr', ':%c'])
endfunction
autocmd VimEnter * call AirlineInit()

" Other settings
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " Skip if set to utf-8[unix]
"

" ALE (Linters and Fixers)
let g:airline#extensions#ale#enabled=1
let g:ale_sign_column_always = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

let g:ale_fix_on_save = 1

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}
let g:ale_fixers={
\   'javascript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
\   'haskell': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
\  'javascript': ['eslint', 'flow'],
\  'haskell': ['hlint', 'hdevtools'],
\}
let g:ale_linter_aliases = {
\   'zsh': 'sh',
\   'csh': 'sh',
\   'pandoc': 'markdown',
\}
let g:ale_sign_error = '❌' " could use emoji
let g:ale_sign_warning = '☢' " could use emoji
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter%% [code]%: %s'
" ALE lang-specifics
let g:ale_javascript_prettier_use_local_config = 1
let g:hdevtools_options = ''

" Bufferline
let g:bufferline_echo = 0        " It's already on airline
let g:bufferline_rotate = 1      " Fixed current buffer position
let g:bufferline_fixed_index = 0 " Always first

" Emoji
augroup languages
  " For markdown and git
  autocmd FileType pandoc,markdown,git,gitcommit,gitconfig,gitrebase,gitsendemail set omnifunc=emoji#complete
augroup END

" NERDTree
let NERDTreeAutoDeleteBuffer = 1 " Delete file buffer of file deleted via NERDTree
let NERDTreeChDirMode = 2        " Change the CWD with the tree root
let NERDTreeMouseMode = 2        " Single click on directory to open
let NERDTreeRespectWildIgnore = 0
let NERDTreeIgnore = ['\.hi$', '\.o$']
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 0
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortOrder = ['\/$'] " Directories first
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" Pandoc
let g:pandoc#syntax#conceal#use=0

" Postgres / SQL
let g:sql_type_default = 'pgsql'

" Startify
let g:startify_files_number = 5
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_enable_unsafe = 1
let g:startify_custom_header = 'map(startify#fortune#boxed(), "\"   \".v:val")'
let g:startify_relative_path = 1
augroup Startify
  autocmd User Startified setlocal cursorline
augroup END
highlight StartifyBracket ctermfg=026
highlight StartifyFooter  ctermfg=240
highlight StartifyHeader  ctermfg=110
highlight StartifyNumber  ctermfg=215
highlight StartifyPath    ctermfg=245
highlight StartifySection ctermfg=167
highlight StartifySlash   ctermfg=240
highlight StartifySpecial ctermfg=252

" YouCompleteMe
let g:ycm_python_binary_path="/usr/local/opt/python/libexec/bin/python"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set secure " Keep safe from bad project-specific files

