" Includes configuration and mappings for managing the colorscheme

let g:terminal_ansi_colors = [
      \ '#1E2127', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#ABB2BF',
      \ '#5C6370', '#E06C75', '#98C379', '#D19A66', '#61AFEF', '#C678DD', '#56B6C2', '#FFFFFF' ]

" Enable true colors
if (has("termguicolors"))
  set termguicolors
  " Workaround for tmux
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
endif

" Colorscheme / theme
set background=dark

let g:preferred_colorschemes_dark = [
      \ 'one',
      \ 'base16-default-dark',
      \ 'base16-ashes',
      \ 'base16-atelier-dune',
      \ 'base16-atelier-forest',
      \ 'base16-ayu-mirage',
      \ 'base16-google-dark',
      \ 'base16-selenized-black',
      \ 'base16-seti' ]
let g:preferred_colorschemes_dark_size = len(preferred_colorschemes_dark)
let g:current_colorscheme_i = 0 " Default colorscheme

" Idempotently set a given colorscheme from the list
function SetColorscheme(i, silence = 0)
  let $current_colorscheme = g:preferred_colorschemes_dark[a:i % g:preferred_colorschemes_dark_size]
  colorscheme $current_colorscheme
  if !a:silence
    echowindow "Current colorscheme: " . $current_colorscheme
  endif
endfunction

call SetColorscheme(current_colorscheme_i, 1)

" Rotate over the list of colorschemes
function RotateColorscheme(step = 1)
  let step = a:step
  if a:step < 0
    let step += g:preferred_colorschemes_dark_size
  endif
  let g:current_colorscheme_i = (g:current_colorscheme_i + step) % g:preferred_colorschemes_dark_size
  call SetColorscheme(g:current_colorscheme_i)
endfunction

nnoremap <Leader>cc :call RotateColorscheme()<CR>
nnoremap <Leader>CC :call SetColorscheme(current_colorscheme_i)<CR>
