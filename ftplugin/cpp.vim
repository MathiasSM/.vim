set number
set showmatch
syntax enable
map<F1> :!g++ -g -O2 -std=gnu++14 -static % -o %:t:r <CR>
map<F2> :!./%:t:r < input.txt<CR>
