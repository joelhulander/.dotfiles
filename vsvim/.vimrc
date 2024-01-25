set ignorecase
set smartcase
set relativenumber 
set hlsearch
set incsearch
set cursorline
set clipboard=unnamed

let mapleader = " "

nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>sa ggVG<CR>
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz

nnoremap k n
nnoremap K N
nnoremap n j
nnoremap N J
nnoremap e k
nnoremap E K
nnoremap j e
nnoremap J E 

xnoremap k n
xnoremap K N
xnoremap n j
xnoremap N J
xnoremap e k
xnoremap E K
xnoremap j e
xnoremap J e

nmap <C-O> :vsc View.NavigateBackward<CR>
nmap <C-I> :vsc View.NavigateForward<CR>
nmap <leader>ff :vsc Edit.GoToAll<CR>
nmap <leader>fp :vsc Window.QuickLaunch<CR>
nmap <leader>ca :vsc View.QuickActions<CR>
