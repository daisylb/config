
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" Color Schemes
Plug 'jaredgorski/fogbell.vim'

" File Navigation
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

call plug#end()


" Color Schemes
colorscheme fogbell_light

" Keymaps
let mapleader = " "
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Tags<CR>

nnoremap t j
nnoremap n k
nnoremap s l
