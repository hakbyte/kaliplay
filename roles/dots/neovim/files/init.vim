"
" Global Settings
"

set number
set relativenumber
set noswapfile
set autoread
set nobackup
set ignorecase
set smartcase
set shiftwidth=4
set tabstop=4
set expandtab
set fileformat=unix
set undodir=~/.config/nvim/undo
set undofile
set title
set nowrap
set titlestring=%t

" Let vim jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"
" Plugins
" Using vim-plug (https://github.com/junegunn/vim-plug)
"

call plug#begin(expand('~/.config/nvim/plugged'))
    Plug 'tpope/vim-commentary'
    Plug 'vim-airline/vim-airline'
    Plug 'sheerun/vim-polyglot'
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'cohama/lexima.vim'
call plug#end()

"
" Appearance
"

syntax enable

if (has("termguicolors"))
    set termguicolors
endif

" Disable background color for `onedark.vim` theme
let g:onedark_color_overrides = {
\   "background": {"gui": "NONE", "cterm": "NONE", "cterm16": "NONE" }
\}

colorscheme onedark
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Highlighting
hi Directory cterm=bold gui=bold
hi Comment cterm=italic gui=italic
hi String cterm=italic gui=italic
hi Statement cterm=bold gui=bold
hi Conditional cterm=bold gui=bold
hi Repeat cterm=bold gui=bold
hi Keyword cterm=bold gui=bold
hi Operator cterm=bold gui=bold
hi Todo cterm=bold gui=bold ctermfg=red guifg=red

"
" Key bindings
"

let mapleader = " "

" Save changes
map <silent> <leader>w :w<cr>

" Save changes to all open files and exit
map <silent> <leader>ww :wqa<cr>

" Quit without saving
map <silent> <leader>xx :qa!<cr>

" Clear highlighted results from hlsearch
map <silent> <leader>/ :noh<cr>

" Pressing <leader>s will toggle spell checking
map <leader>s :setlocal spell!<cr>

" Gives us the hability to quickly insert empty lines without leaving normal mode
map <silent> <C-Up> :call AddBlankUp()<cr>
map <silent> <C-Down> :call AddBlankDown()<cr>

" Toggle terminal
let termheight = 15
nnoremap <silent> <leader>z :call ToggleTerm(termheight)<cr>
tnoremap <silent> <leader>z <C-\><C-n>:call ToggleTerm(termheight)<cr>

" Double pressing space will bring fzf
nnoremap <silent> <Leader><Space> :Files<cr>

" Launch fzf just for the directory containing the currently edited file
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<cr>/<cr>

" Move a line of text using Alt+[jk]
nmap <silent> <M-j> mz:m+<cr>`z
nmap <silent> <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" User arrow keys to manipulate tabs
map <silent> <C-Left> <Esc>:tabprev<cr>
map <silent> <C-Right> <Esc>:tabnext<cr>
nnoremap <silent> <C-S-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<cr>
nnoremap <silent> <C-S-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<cr>

" Other useful mappings for managing tabs
map <silent> <leader>tn :tabnew<cr>
map <silent> <leader>tc :tabclose<cr>

" Better way to move among windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Copy to clipboard
vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>yy "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Toggle nerdtree on and off
map <silent> <C-n> :NERDTreeToggle<cr>

" Vim-fugitive
map <silent> <leader>g0  :Gdiff :0<cr>
map <silent> <leader>g1  :Gdiff !~1<cr>
map <silent> <leader>gc  :Gwrite<cr>:Git commit -v<cr>
map <silent> <leader>gp  :Git push<cr>
map <silent> <leader>gr  :Git reset<cr>
map <silent> <leader>gst :Git status<cr>
map <silent> <leader>gw  :Gwrite<cr>

"
" Misc
"

" Delete trailing whitespace on save
autocmd BufWritePre * :call TrimWhiteSpace()

" Git gutter config
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
set updatetime=100

"
" Functions & Macros
"

" Add empty line above current line
function! AddBlankUp()
    call append(line('.')-1, '')
endfun

" Add empty line below current line
function! AddBlankDown()
    let l:save = winsaveview()
    call append('.', '')
    call winrestview(l:save)
endfun

" Delete trailing whitespace
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" Open a terminal and place it at the bottom of the screen.
" See https://stackoverflow.com/questions/37232418/toggle-neovim-terminal-buffer-like-nerdtree-plugin
let g:term_buf = 0
let g:term_win = 0
function! ToggleTerm(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction
