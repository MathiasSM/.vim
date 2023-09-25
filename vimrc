" vim:foldmethod=marker:foldlevel=1

" External {{{
for f in split(glob('~/.vimrc.d/*.vim'), '\n')
  exe 'source' f
endfor



" }}}
" General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible          " Because we want Vim instead of Vi
set modelines=1           " Some times I use them
set history=5000          " REMEMBER
filetype plugin indent on " Load indent and plugin files for filetype
set autoread              " When file changes outside of vim
if $OS == 'macos'
  set clipboard=unnamed   " Use system clipboard to yank
else
  set clipboard=unnamedplus " Use system clipboard to yank
endif
if hostname() =~ '.*\d\.amazon\.com'
  set nottyfast           " Avoid batch send characters to screen on remote
endif
set lazyredraw            " Don't redraw on macros!
set confirm               " Enable dialogs instead of annoying errors
set hidden                " Allows to keep several non-saved buffers
set noexrc " Do not allow project-specific configuration file



" }}}
" VIM user interface {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Different cursors for different modes. Tmux-compatible
" See also :help mouseshape
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

" Scrolling
" set smoothscroll    " Scroll works with screen lines (wrapped lines ok)
set scrolloff=0     " How many lines to always keep visible above/below cursor
set sidescrolloff=0 " Same as above, for side scrolling
set scrolljump=5    " How many lines to scroll when going out of screen
set sidescroll=5    " Same as above, for side scrolling

" Turn on the 'wild' menu
set wildmenu

" Ignore ignorable files TODO: Look into vim-wildignore plugin
set wildignore=*/.DS_Store,*/._*                            " macOS
set wildignore+=*~,*.swp,*.bak,*.tmp                        " Backups
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*                   " Versioning systems
set wildignore+=*/node_modules/*                            " Big vendor dirs
set wildignore+=*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf " Not-text
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot            " Fonts
set wildignore+=*.class,*.0,*.pyc,*.hi,*.o                  " Compiled code
set wildignore+=*.stack-work                                " Build directories
set wildignore+=*/__pycache__/*                             " Cache directories

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



" }}}
" Colors and Fonts {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax on

" Enable true colors
if (has("termguicolors"))
  set termguicolors
  " Workaround for tmux
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
endif

" Colorscheme / theme
set background=dark

const g:preferred_colorschemes_dark = [
      \ 'one',
      \ 'base16-default-dark',
      \ 'base16-ashes',
      \ 'base16-atelier-dune',
      \ 'base16-atelier-forest',
      \ 'base16-ayu-mirage',
      \ 'base16-google-dark',
      \ 'base16-selenized-black',
      \ 'base16-seti' ]
const g:preferred_colorschemes_dark_size = len(preferred_colorschemes_dark)
let current_colorscheme_i = 4 " Default colorscheme

" Idempotently set a given colorscheme from the list
function SetColorscheme(i, silence = 0)
  let $current_colorscheme = g:preferred_colorschemes_dark[a:i % g:preferred_colorschemes_dark_size]
  colorscheme $current_colorscheme
  if !a:silence
    echowindow "Current colorscheme: " . $current_colorscheme
  endif
endfunction

" Rotate over the list of colorschemes
function RotateColorscheme(step = 1)
  let step = a:step
  if a:step < 0
    let step += g:preferred_colorschemes_dark_size
  endif
  let g:current_colorscheme_i = (g:current_colorscheme_i + step) % g:preferred_colorschemes_dark_size
  call SetColorscheme(g:current_colorscheme_i)
endfunction

call SetColorscheme(current_colorscheme_i, 1)


let g:terminal_ansi_colors = [
      \ '#1E2127', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#ABB2BF',
      \ '#5C6370', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#FFFFFF' ]

set encoding=utf8

" Use italized comments *-*
set t_ZH=[3m
set t_ZR=[23m
highlight Comment        cterm=italic
highlight vimComment     cterm=italic
highlight vimLineComment cterm=italic

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Change font on GUI version
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



" }}}
" Text, tab and indent related {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set formatoptions+=j  " Delete comments on line merges
set expandtab         " Use spaces instead of tabs
set smarttab
set shiftwidth=2      " I like short tabs
set tabstop=2
set textwidth=0       " No hard wrap
set nowrap            " No soft wrap by default
set breakindent
set linebreak         " Be smart about where to wrap lines
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

" De-highlights search results
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

" Visual block mode not constrained by line size
set virtualedit=block

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

" Mappings to navigate buffers
" \b \f \g : go back/forward/last-used
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>p :e#<CR>

" Toggle behavior modes
" Toggle paste mode (See also :help pastetoggle)
map <leader>pp :setlocal paste!<cr>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Toggle linters
map <leader>aa :ALEToggle<cr>

" Know the current syntax group
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc



"}}}
" Behavior {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable mouse in (a)ll modes
set mouse=a

" Select paragraphs when indented
" Technically a mapping, though
vnoremap < <gv
vnoremap > >gv

" Sane n/N behavior (Navigate to next/prev search result)
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Quickly navigate linting errors
nnoremap ]a :ALENextWrap<cr>
nnoremap [a :ALEPreviousWrap<cr>

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
set backupdir   =$HOME/.vim/files/backup//
set backupext   =-vimbackup
set backupskip  =
" Swap files
set swapfile
set directory   =$HOME/.vim/files/swap//
set updatecount =50 " Rotates swaps after this number of characters
" Undo files
set undolevels=5000
set undofile
set undodir     =$HOME/.vim/files/undo//
" Viminfo files
set viminfo     ='100,r/tmp,r/media,r/mnt,r/Volumes,n$HOME/.vim/files/info/viminfo
" Verbose file (:help verbose)
set verbosefile =$HOME/.vim/files/verbose.log

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
set spelllang=en,es,fr,programming " From vim-dirtytalk
set spelloptions=camel

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
augroup Behavior
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END



" }}}
" Language specifics {{{
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



" }}}
" Plugin settings {{{
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
let g:airline_detect_spelllang=1      " Don't show the lang
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
let g:airline_symbols.crypt = ''
let g:airline_symbols.readonly = 'ﾛ'
let g:airline_symbols.paste = '🅟 '
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.spell = '𝒮'
let g:airline_symbols.branch = '⌥'

" Whitespace problems in airline
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#trailing_format = 'tr:%s'
let g:airline#extensions#whitespace#mixed_indent_format = 'mix:%s:'
let g:airline#extensions#whitespace#long_format = 'l:%s'
let g:airline#extensions#whitespace#mixed_indent_file_format = 'mix:%s'

" Other (included) extensions
let g:airline#extensions#csv#column_display = 'Name'

let g:airline#extensions#branch#enabled = 1
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
\   'java':       ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
\   'json':       ['jq'],
\   'haskell':    ['remove_trailing_lines', 'trim_whitespace', 'hlint', 'ormolu'],
\   'typescript': ['prettier'],
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
\   'java':       ['checkstyle'],
\   'javascript': ['eslint', 'flow'],
\   'haskell':    ['hlint', 'hls'],
\   'typescript': ['eslint', 'tsserver'],
\}
let g:ale_linter_aliases = {
\   'pandoc': 'markdown',
\}
let g:ale_sign_error = '❌'   " Can use emoji
let g:ale_sign_warning = '⚠️ ' " Can use emoji
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter%% [code]%: %s'
" ALE lang-specifics
let g:ale_javascript_prettier_use_local_config = 1

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
let NERDTreeRespectWildIgnore = 1
let NERDTreeIgnore = ['\.hi$', '\.o$']
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 0
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortOrder = ['\/$'] " Directories first
let g:NERDTreeGitIndicatorMapCustom = {
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
let g:pandoc#syntax#conceal#use=1

" Postgres / SQL
let g:sql_type_default = 'pgsql'

" Tmux Navigator
"" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" VimTex
let g:tex_flavor = 'latex'

" Build plugin help files
" Plugins need to be added to runtimepath before helptags can be generated
packloadall
" Load all of the helptags now, after plugins have been loaded.
silent! helptags ALL



" }}}

set secure " Show mappings, disallow further autocmd, shell and writes in rc
