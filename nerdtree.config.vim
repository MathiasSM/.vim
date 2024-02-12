" This file includes configurations for NERDTree.
" It assumes NERDTree and vim-devicons are installed

" General configuration
let NERDTreeAutoDeleteBuffer = 1 " Delete file buffer of file deleted via NERDTree
let NERDTreeChDirMode = 2        " Change the CWD with the tree root
let NERDTreeMouseMode = 2        " Single click on directory to open
let NERDTreeRespectWildIgnore = 1

let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeCascadeOpenSingleChildDir = 0
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeNaturalSort = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortOrder = ['\/$'] " Directories first

" Open NERDtree if opening a folder
augroup NERDTreeBehavior
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter *
        \ if !exists("s:std_in") && argc() == 0 |
        \   exe 'NERDTree' getcwd() |
        \   wincmd p |
        \   enew |
        \ endif
  autocmd VimEnter *
        \ if !exists("s:std_in") && argc() == 1 && isdirectory(argv()[0]) |
        \   exe 'NERDTree' argv()[0] |
        \   wincmd p |
        \   enew |
        \ endif
augroup END

" TODO: Check if these are working
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

" File icons and colors
let g:colors = {
  \ 'brown':       ["#905532", "Brown"],
  \ 'aqua':        ["#3AFFDB", "Cyan"],
  \ 'blue':        ["#689FB6", "Blue"],
  \ 'darkBlue':    ["#44788E", "DarkBlue"],
  \ 'purple':      ["#834F79", "DarkMagenta"],
  \ 'lightPurple': ["#834F79", "Magenta"],
  \ 'juliaPurple': ["#9558B2", "Magenta"],
  \ 'red':         ["#AE403F", "DarkRed"],
  \ 'beige':       ["#F5C06F", "Brown"],
  \ 'yellow':      ["#F09F17", "Yellow"],
  \ 'orange':      ["#D4843E", "Brown"],
  \ 'darkOrange':  ["#F16529", "Brown"],
  \ 'pink':        ["#CB6F6F", "Red"],
  \ 'salmon':      ["#EE6E73", "Red"],
  \ 'green':       ["#8FAA54", "DarkGreen"],
  \ 'lightGreen':  ["#31B53E", "Green"],
  \ 'white':       ["#FFFFFF", "White"]
  \ }

let g:icon_colors = {
  \ 'λ' :  g:colors['yellow'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['pink'],
  \ '' :  g:colors['yellow'],
  \ '' :  g:colors['purple'],
  \ '' :  g:colors['purple'],
  \ '' :  g:colors['yellow'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['beige'],
  \ '' :  g:colors['beige'],
  \ '' :  g:colors['aqua'],
  \ '' :  g:colors['darkOrange'],
  \ '' :  g:colors['orange'],
  \ '' :  g:colors['pink'],
  \ '' :  g:colors['yellow'],
  \ '' :  g:colors['darkBlue'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['darkOrange'],
  \ '' :  g:colors['brown'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['purple'],
  \ '' :  g:colors['purple'],
  \ '' :  g:colors['yellow'],
  \ '' :  g:colors['juliaPurple'],
  \ '' :  g:colors['beige'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['purple'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['red'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['darkOrange'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['darkBlue'],
  \ '' :  g:colors['red'],
  \ '' :  g:colors['orange'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['green'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['red'],
  \ '' :  g:colors['lightPurple'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['darkOrange'],
  \ '' :  g:colors['red'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['lightPurple'],
  \ '' :  g:colors['darkOrange'],
  \ '' :  g:colors['salmon'],
  \ '' :  g:colors['darkBlue'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['orange'],
  \ '' :  g:colors['blue'],
  \ '' :  g:colors['aqua'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['white'],
  \ '' :  g:colors['blue'],
  \ '󰚩' :  g:colors['white'],
  \ '󰓆' :  g:colors['white'],
  \ '' :  g:colors['orange'],
  \ '󰊄' :  g:colors['white'],
  \ '󱂅' :  g:colors['white'],
  \ '󱁉' :  g:colors['orange'],
  \ '' :  g:colors['darkOrange']
  \ }

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {
  \ 'log':   '󱂅',
  \ 'puml':  '󱁉',
  \ 'txt':   '󰊄',
  \ 'spl':   '󰓆',
  \ 'sug':   '󰓆',
  \ 'r':     '',
  \ 'rproj': '',
  \ 'j2':    '',
  \ 'cfg':   '',
  \ 'tex':   '' }

let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {
  \ 'Config':          '',
  \ 'packageInfo':     '',
  \ '.git':            '',
  \ '.gitmodules':     '',
  \ '.gitignore':      '',
  \ '.prettierignore': '',
  \ '.eslintignore':   '',
  \ '.taskrc':         '',
  \ '.zpreztorc':      '',
  \ '.psqlrc':         '',
  \ '.muttrc':         '',
  \ 'robots.txt':      '󰚩' }

augroup NerdtreeDevicons
  let s:icon_n=0
  for icon in keys(g:icon_colors)
    exec 'autocmd filetype nerdtree syntax match icon_'.s:icon_n.' /'.icon.'/ containedin=NERDTreeFlags'
    exec 'autocmd filetype nerdtree highlight icon_'.s:icon_n.' ctermbg=none ctermfg='.g:icon_colors[icon][1].' guifg='.g:icon_colors[icon][0]
    let s:icon_n += 1
  endfor
augroup END
