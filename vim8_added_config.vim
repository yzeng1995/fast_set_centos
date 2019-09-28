
" set by yzeng1995
set hlsearch		" set highlignt while searching
set backspace=2		" use backspace key to delete any time
set autoindent		" auto indent
set number		" show line number
set showmode		" show mode [insert mode or commond mode]
set bg=dark
set laststatus=2
set tabstop=4
set shiftwidth=4
set noexpandtab
set mouse-=a
" add new syntax
au BufRead,BufNewFile *ans set filetype=apdl
map <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l
