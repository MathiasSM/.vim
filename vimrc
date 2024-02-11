" vim:foldmethod=marker:foldlevel=1

" Private External Scripts (to run BEFORE everything)
for f in split(glob('~/.vim/private/*.before.vim'), '\n')
  execute 'source' f
endfor



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" General {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
  set nocompatible          " Because we want Vim instead of Vi
  set hidden                " Allows to keep several non-saved buffers
endif

set autoread              " When file changes outside of vim
set modelines=1           " Some times I use them
set history=5000          " REMEMBER

set encoding=utf8
set ffs=unix,dos,mac      " Use Unix as the standard file type

filetype plugin indent on " Load indent and plugin files for filetype

" Clipboard
if $OS == 'macos'
  set clipboard=unnamed     " Use system clipboard to yank
else
  set clipboard=unnamedplus " Use system clipboard to yank
endif

" Small optimizations
if !has('nvim')
  if hostname() =~ '.*\d\.amazon\.com'
    set nottyfast           " Avoid batch send characters to screen on remote
  endif
  set lazyredraw            " Don't redraw on macros!
endif

" Do not allow project-specific configuration files
set noexrc


" }}}
" UI {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has('nvim')
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
endif

" Current line already highlighted by terminal (at least iTerm)
set nocursorline

" Title (terminal, window, tab)
set title
if !has('nvim')
  set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
endif
set guitablabel=%N\ %f " Be able to change the tab name

" Some extra height of the command bar, for convenience
set cmdheight=2

" Split direction for windows:
set splitbelow
set splitright

" Show line numbers
set number
set relativenumber

" Folding
set foldenable
set foldmethod=indent
set foldlevelstart=5
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR> " Use Space to toggle
vnoremap <Space> zf " Use space to create fold marker

" Scrolling
if !has('nvim')
  set smoothscroll    " Scroll works with screen lines (wrapped lines ok)
endif
set scrolloff=0     " How many lines to always keep visible above/below cursor
set sidescrolloff=0 " Same as above, for side scrolling
set scrolljump=5    " How many lines to scroll when going out of screen
set sidescroll=5    " Same as above, for side scrolling

" Wildmenu (e.g. vim command autocomplete)
set wildmenu            " On by default in nvim
set wildchar=<Tab>      " The default
set wildmode=full       " I don't see the other modes as useful
set wildoptions=pum     " Vertical menu instead of above-line
set wildoptions+=fuzzy  " Enable fuzzy search for non-file/buffer names
set wildignorecase
set wildignore=*/.DS_Store,*/._*                            " macOS
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*                   " Versioning systems
set wildignore+=*/node_modules/*                            " Big vendor dirs
set wildignore+=*.png,*.jpg,*.jpeg,*.webp,*.pdf             " Non-text; no point in using vim here
set wildignore+=*.ttf,*.otf,*.woff,*.woff2,*.eot            " Fonts
set wildignore+=*.class,*.0,*.pyc,*.hi,*.o                  " Compiled code
set wildignore+=*.stack-work,*/__pycache__/*                " Compiled code directories
" I keep *.{swp,bak,tmp} because I already have them in different folder

" No annoying sound on errors
set confirm               " Enable dialogs instead
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

" Show matching brackets when text indicator is over them
set showmatch

" Visual block mode not constrained by line size
set virtualedit=block

" Fix backspace
set backspace=eol,start,indent

" Re-read external changes
set autoread
augroup MoreVimBehavior_ReRead
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !

" Return to last edit position when opening files
augroup MoreVimBehavior_SaveFilePosition
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END


" }}}
" Colors and Fonts {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:colors_config_path = '~/.vim/colors.config.vim'
if empty(glob(s:colors_config_path))
  echoerr "Colors config not found"
else
  execute 'source' . expand(s:colors_config_path)
endif

" Enable syntax highlighting
syntax on

" Use italized comments *-*
set t_ZH=[3m
set t_ZR=[23m
" highlight Comment        cterm=italic
" highlight vimComment     cterm=italic
" highlight vimLineComment cterm=italic

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

" Wrap
set textwidth=0         " No hard wrap
set nowrap              " No soft wrap by default
set linebreak           " Be smart about where to wrap lines
set display+=lastline   " Display part of those wrapped. Avoid jumps
set whichwrap+=<,>,h,l  " Cursor wrapping

" Indentation
set smarttab
set expandtab         " Use spaces instead of tabs
set shiftwidth=2      " I like short tabs
set tabstop=2
set breakindent
set autoindent        " Same indent on newline
set smartindent       " Insert or remove indentation automatically
vnoremap < <gv " Keep paragraph selected
vnoremap > >gv " Keep paragraph selected

" Format options
set formatoptions-=t  " No auto-wrap code
set formatoptions-=c  " No auto-wrap comments
set formatoptions+=n  " Number list items
set formatoptions+=r  " Add comment leader on enter
set formatoptions+=o  " Add comment leader on o/O
set formatoptions+=/  " Add comment leader on o/O BUT NOT after partially commented lines
set formatoptions+=j  " Remove comments on line merges

" Toggle paste mode (See also :help pastetoggle)
map <leader>pp :setlocal paste!<cr>

" Prettier characters on utf8
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif



" }}}
" Search {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase smartcase hlsearch incsearch

" Sane n/N behavior (Navigate to next/prev search result){{{}}}
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Ack.vim (Use the_silver_searcher)
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Global replace matches to last search
nmap <expr> M ':%s/' . @/ . '//g<LEFT><LEFT>'

" De-highlights search results
map <silent> <leader><cr> :noh<cr>

" Saner <c-l> (clean screen)
nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

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


" }}}
" Other macros {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" :W sudo saves the file (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

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


" }}}
" Movement {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move by visual line
noremap <silent> k gk
noremap <silent> j gj

" Move visually between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Move only via hjkl
noremap <up>    <nop>
noremap <down>  <nop>
noremap <left>  <nop>
noremap <right> <nop>

" Move lines around
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

" \b \f \g : Move (buffers) back/forward/last-used
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>p :e#<CR>

" Quickly navigate linting errors
nnoremap ]a :ALENextWrap<cr>
nnoremap [a :ALEPreviousWrap<cr>




"}}}
" Mouse {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable mouse, without middle-click = paste
set mouse=a
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <5-MiddleMouse> <Nop>


"}}}
" Temporary files {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Temporary files go under .vim/files
if !isdirectory($HOME.'/.vim/files') && exists('*mkdir')
  call mkdir($HOME.'/.vim/files')
endif

" Backup files
set backup
if !has('nvim')
  set backupdir   =$HOME/.vim/files/backup//
endif
set backupext   =-vimbackup
set backupskip  =

" Swap files
set swapfile
set directory   =$HOME/.vim/files/swap//
set updatecount =50 " Rotates swaps after this number of characters

" Undo files
set undolevels=5000
set undofile
if !has('nvim')
  set undodir=$HOME/.vim/files/undo//
endif

" Viminfo file
if !has('nvim')
  set viminfo='100,r/tmp,r/media,r/mnt,r/Volumes,n$HOME/.vim/files/info/viminfo
endif

" Verbose file (:help verbose)
set verbosefile =$HOME/.vim/files/verbose.log



"}}}
" Airline {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
augroup AirlineInit
  autocmd VimEnter * call AirlineInit()
augroup END

" Bufferline
let g:bufferline_echo = 0        " It's already on airline
let g:bufferline_rotate = 1      " Fixed current buffer position
let g:bufferline_fixed_index = 0 " Always first

" Other settings
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " Skip if set to utf-8[unix]


" }}}
" Languages/Filetypes {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Spell checking
set spelllang=en,es,fr,programming " From vim-dirtytalk
set spelloptions=camel
map <leader>ss :setlocal spell!<cr>

augroup MoreFiletypes
  autocmd!
  " C, C++: Mark code and header file automatically
  autocmd BufLeave *.{c,cpp} mark C
  autocmd BufLeave *.{h,hpp} mark H
  " Makefile
  autocmd Filetype Makefile         setlocal noexpandtab
  " Haskell Alex/Happy: syntax
  autocmd BufEnter *.x,*.y          setlocal filetype=haskell
  autocmd BufEnter *.xmobarrc       setlocal filetype=haskell
  " Markdown
  autocmd Filetype *.md,*.markdown  setlocal filetype=pandoc " TODO: Should be handled by vim-pandoc
  " ZSH: syntax
  autocmd BufEnter *.zsh-theme      setlocal filetype=zsh
  autocmd BufEnter *.zshrc          setlocal filetype=zsh
augroup END

" Know the current syntax group
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Pandoc
let g:pandoc#syntax#conceal#use=1

" Postgres / SQL
let g:sql_type_default = 'pgsql'

" VimTex
let g:tex_flavor = 'latex'

augroup MoreLanguageBehavior
  autocmd!
  " C, C++: Mark code and header file automatically
  autocmd BufLeave *.{c,cpp} mark C
  autocmd BufLeave *.{h,hpp} mark H
  " Makefile
  autocmd Filetype Makefile         setlocal noexpandtab
  " Emoji completion for markdown and git
  autocmd FileType pandoc,markdown,git,gitcommit,gitconfig,gitrebase,gitsendemail set omnifunc=emoji#complete
  " Reload vimrc on every save (this does not include other config files)
  autocmd BufWritePost ~/.vim/vimrc source <afile>
augroup END


" }}}
" ALE Linters and Fixers {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle linters
map <leader>aa :ALEToggle<cr>

let g:airline#extensions#ale#enabled=1
let g:ale_sign_column_always = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 1

let g:ale_fix_on_save = 1

let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\} " Do not lint or fix minified files.
let g:ale_fixers={
\   'java':       ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'json':       ['eslint'],
\   'jsonc':      ['eslint'],
\   'haskell':    ['remove_trailing_lines', 'trim_whitespace', 'hlint', 'ormolu'],
\   'typescript': ['eslint'],
\   'sql':        ['sqlfluff'],
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_linters = {
\   'java':       ['checkstyle'],
\   'javascript': ['eslint'],
\   'html':       ['htmlhint'],
\   'haskell':    ['hlint', 'hls'],
\   'typescript': ['eslint', 'tsserver'],
\   'json': ['eslint'],
\   'jsonc': ['eslint'],
\}
" TODO:
" awk: gawk
" bash: shellcheck
" bibtex: bibclean
" c: gcc
" cpp: gcc
" cloudformation: cfn-python-lint
" css: stylelint
" dhall
" dockerfile
" fortran
" gitlint
" graphql: gqlint
" java: eclipselsp?
" latex
" lua
" make
" markdown: pandoc
" sql: pgformatter, ...?
" toml
" texinfo
" terraform
" systemd
" vim
" xml
let g:ale_linter_aliases = {
\   'pandoc': 'markdown',
\}
let g:ale_sign_error = '❌'   " Tip: Can use emoji
let g:ale_sign_warning = '⚠️ ' " Tip: Can use emoji
let g:ale_statusline_format = ['X %d', '? %d', '']
" %linter% is the name of the linter that provided the message
" %s is the error or warning message
let g:ale_echo_msg_format = '%linter%% [code]%: %s'
" ALE lang-specifics
let g:ale_javascript_prettier_use_local_config = 1

" Devicons
if $OS == 'macos'
  let g:WebDevIconsOS = 'Darwin'
else
  let g:WebDevIconsOS = 'Linux'
endif


" }}}
" Other plugins {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NERDTree
map <leader>n :NERDTreeToggle<CR>
let s:nerdtree_config_path = '~/.vim/nerdtree.config.vim'
if empty(glob(s:nerdtree_config_path))
  echoerr "NERDTree config not found"
else
  execute 'source' . expand(s:nerdtree_config_path)
endif

" Tmux Navigator
"" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2


" }}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" Private External Scripts (to run AFTER everything)
for f in split(glob('~/.vim/private/*.after.vim'), '\n')
  execute 'source' f
endfor

" Build plugin help files
" Plugins need to be added to runtimepath before helptags can be generated
packloadall
" Load all of the helptags now, after plugins have been loaded.
silent! helptags ALL

set secure " Show mappings, disallow further autocmd, shell and writes in rc
