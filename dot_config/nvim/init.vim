" ex: ts=4 sw=4 et filetype=vim
if &compatible
    set nocompatible
endif

let mapleader=','

if glob('~/.config/nvim/bundle') ==# ''
    call system('git clone https://github.com/Shougo/dein.vim  ~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim')
endif
set runtimepath+=~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim
call dein#begin('~/.config/nvim/bundle/')
call dein#add('Shougo/dein.vim')

" quick buffer switcher
call dein#add('jeetsukumaran/vim-buffergator')
nnoremap <leader>z :BuffergatorToggle<CR>

" buffer management
call dein#add('qpkorr/vim-bufkill')
nnoremap <leader>Q :BD<CR>

" lazy load nerdtree on first use
call dein#add('scrooloose/nerdtree', {'on_cmd': 'NERDTreeToggle'})
let NERDTreeIgnore = ['\.pyc$']
map <leader>G :NERDTreeFind<CR>

" lazy load Gundo on first use
call dein#add('sjl/gundo.vim', {'on_cmd': 'GundoToggle'})

" lazy load syntax completions on insert mode
call dein#add('sheerun/vim-polyglot')
call dein#add('Shougo/deoplete.nvim')
call dein#add('zchee/deoplete-go', {'build': 'make'})
call dein#add('fatih/vim-go')
call dein#add('zchee/deoplete-clang')
call dein#add('zchee/deoplete-jedi')
call deoplete#enable()
let g:deoplete#sources#jedi#show_docstring = 1

call dein#add('davidhalter/jedi-vim')
let g:jedi#completions_enabled = 0

" Add the virtualenv's site-packages to vim path
if has('python')
py << EOF
import os
import sys
import vim
for p in [os.getcwd(), os.environ.get('VIRTUAL_ENV')]:
    if not p: continue
    activate_this = os.path.join(p, 'bin/activate_this.py')
    if os.path.isfile(activate_this):
        sys.path.insert(0, p)
        execfile(activate_this, dict(__file__=activate_this))
EOF
if filereadable('bin/python')
    let g:deoplete#sources#jedi#python_path = 'bin/python'
elseif $VIRTUAL_ENV
    let g:deoplete#sources#jedi#python_path = $VIRTUAL_ENV . 'bin/python'
endif
endif

" can't lazy-load because airline needs it
call dein#add('majutsushi/tagbar')

" airline config
call dein#add('vim-airline/vim-airline')
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline_theme='one'

" VCS (cuz airline doesn't do this by itself like powerline did)
call dein#add('tpope/vim-fugitive')

" file search
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'
call dein#add('junegunn/fzf', { 'build': './install -all', 'merged': 0 })
call dein#add('junegunn/fzf.vim')
map <C-t> :BTags<CR>
map <C-p> :Files<CR>
map <C-f> :Ag<CR>

" notes
call dein#add('Alok/notational-fzf-vim')
let g:nv_search_paths = ['~/Dropbox/Notes']

" comment/uncomment via ,#
call dein#add('scrooloose/nerdcommenter')

" sane extensions of vim mappings
call dein#add('tpope/vim-surround')
call dein#add('tpope/vim-repeat')

" syntax
call dein#add('neomake/neomake')
autocmd! BufWritePost * Neomake
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python_flake8_args='--max-line-length=119'

" snippets
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')

let g:neocomplete#enable_at_startup = 1
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" navigation
call dein#add('wesQ3/vim-windowswap')

" colorscheme
call dein#add('rakr/vim-one')
colorscheme one
set termguicolors
let g:one_allow_italics = 1
hi Normal ctermbg=none guibg=none
set background=dark

let g:terraform_align=1
call dein#add('hashivim/vim-terraform')

call dein#end()

" install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif

filetype plugin indent on
syntax enable
set expandtab

set mouse=a

" remember cursor position next time we open the file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" shows results of a command as you type
if exists('&inccommand')
    set inccommand=split
endif

" show a little context while scrolling
set scrolloff=5

" everything tabby is 4 spaces
set tabstop=4
set shiftwidth=4

" show line numbers relative to current line
set relativenumber
set number

" use the clipboards of vim and system
set clipboard+=unnamed 

" F key mappings
map <F1> <Nop>
map <F1> :NERDTreeToggle<CR>
map <F2> :TagbarToggle<CR>
map <F3> :GundoToggle<CR>

" neocomplete like
set completeopt+=noinsert
" deoplete.nvim recommend
set completeopt+=noselect

" Toggle linenumbers
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
map <F11> :call NumberToggle()<CR>
