set number
set showmatch
syntax enable
map<F1> :!ghc -o %:t:r % <CR>
map<F2> :!./%:t:r < input.txt<CR>
