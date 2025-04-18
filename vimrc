"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set encoding=utf-8            " Ensure encoding is UTF-8
set nocompatible              " Disable Vi compatability
set mouse=a                   " Enable mouse in all modes
set hidden                    " Allow unwritten buffers

"-----------------------------------------------------------------------------
" VIM PLUGIN MANAGEMENT
"-----------------------------------------------------------------------------
filetype off
call plug#begin()    " Initialize vim-plug
Plug 'kien/ctrlp.vim'                " Quick file navigation
Plug 'tpope/vim-commentary'          " Quickly comment lines out and in
Plug 'tpope/vim-fugitive'            " Help formatting commit messages
Plug 'tpope/vim-dispatch'            " Allow background builds
Plug 'tpope/vim-unimpaired'          " Add normal mode aliases for commonly used ex commands
Plug 'tpope/vim-surround'            " Easily change surrounding characters
Plug 'tpope/vim-sensible'            " Sensible defaults
Plug 'tpope/vim-vinegar'             " Use `minus` to access netrw and navigate directories
Plug 'fatih/vim-go'                  " Helpful plugin for Golang dev
Plug 'AndrewRadev/splitjoin.vim'     " Enable vim-go to split structs into multi lines
Plug 'ervandew/supertab'             " Perform all completions with Tab
Plug 'scrooloose/nerdtree'           " Directory tree explorer
Plug 'vim-airline/vim-airline'       " Status line improvements
Plug 'cappyzawa/starlark.vim'
Plug 'vmware-tanzu/ytt.vim'
Plug 'vim-airline/vim-airline-themes'
call plug#end()                      " Complete vim-plug initialization

"-----------------------------------------------------------------------------
" VIM-GO CONFIG
"-----------------------------------------------------------------------------
let g:go_version_warning = 0
let g:go_fmt_command = "goimports"

" highlight go-vim
highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
set updatetime=100 " updates :GoInfo faster

" vim-go command shortcuts
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t :wa<CR>:!clear;go test -v ./%:h<CR>
autocmd FileType go nmap <leader>a <Plug>(go-alternate-edit)
autocmd FileType go nmap <leader>d :GoDeclsDir<CR>
autocmd FileType go nmap <leader>g <Plug>(go-generate)
autocmd FileType go nmap <leader>? :GoDoc<CR>
autocmd FileType go nmap <leader>n :GoRename<CR>
autocmd FileType go nmap <leader>l :GoMetaLinter<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

function! s:toggle_coverage()
    call go#coverage#BufferToggle(!g:go_jump_to_error)
    highlight ColorColumn ctermbg=235
    highlight NonText ctermfg=239
    highlight SpecialKey ctermfg=239
    highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
endfunction

autocmd FileType go nmap <leader>c :<C-u>call <SID>toggle_coverage()<CR>

" This will add new commands, called :A, :AV, :AS and :AT. Here :A works just
" like :GoAlternate, it replaces the current buffer with the alternate file.
" :AV will open a new vertical split with the alternate file. :AS will open
" the alternate file in a new split view and :AT in a new tab.
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

"-----------------------------------------------------------------------------
" RUBY CONFIG
"-----------------------------------------------------------------------------
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

"-----------------------------------------------------------------------------
" CTRL-P CONFIG
"-----------------------------------------------------------------------------
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|vagrant)|node_modules)$',
  \ 'file': '\v\.(swp|zip|exe|so|dll|a)$',
  \ }
" stop setting git repo as root path
let g:ctrlp_working_path_mode = ''

"-----------------------------------------------------------------------------
" NERDTREE CONFIG
"-----------------------------------------------------------------------------
map \     :NERDTreeToggle<CR> " open and close NerdTree
map \|    :NERDTreeFind<CR>   " find the current file in the tree.

let NERDTreeQuitOnOpen = 1       " automatically close NerdTree when you open a file
let NERDTreeAutoDeleteBuffer = 1 " automatically delete the buffer of the file you
                                 " just deleted with NerdTree
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" automatically close a tab if the only remaining window is NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"------------------------------------------------------------------------------
" APPEARANCE
"------------------------------------------------------------------------------
syntax on               " enable syntax highlighting
set number              " show line numbers
set ruler               " show lines in lower right
set nowrap              " don't wrap lines eva!

set cursorline          " highlight current line
set highlight=sbr       " invert and bold status line
let loaded_matchparen = 1

set t_Co=256            " set 256 color
set colorcolumn=80      " highlight col 80
highlight ColorColumn ctermbg=235
set listchars=tab:▸\ ,eol:¬,trail:· " show whitespace characters
set list                " enable display of invisible characters

" invisible character colors
highlight NonText ctermfg=239
highlight SpecialKey ctermfg=239


"------------------------------------------------------------------------------
" supertab config
"------------------------------------------------------------------------------
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

"------------------------------------------------------------------------------
" BEHAVIOR
"------------------------------------------------------------------------------
set backspace=indent,eol,start  " enable better backspacing
set noswapfile                  " disable swap files
set nowb                        " disable writing backup
set textwidth=78                " global text columns
set formatoptions+=l            " don't break long lines less they are new

set hlsearch                    " highlight search results
set smartcase                   " ignore case if lower, otherwise match case
set incsearch                   " jump to results as I search
set splitbelow                  " split panes on the bottom
set splitright                  " split panes to the right

set history=10000               " keep a longer history

set wildmenu                    " allow for menu suggestions

set autowrite                   " automatically write file on `:make`

autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save
autocmd BufLeave * silent! wall    " save on lost focus

" tab behavior
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" smaller indents for yaml
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype yml setlocal tabstop=2 shiftwidth=2 expandtab

"------------------------------------------------------------------------------
" LEADER MAPPINGS
"------------------------------------------------------------------------------
let mapleader = ","              " set leader

" switch between files
nnoremap <leader><leader> <c-^>

" quickly Open vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<cr>
" load vimrc into memory
nmap <silent> <leader>ee :source $MYVIMRC<cr>

" clear the search buffer when hitting space
nnoremap <space> :nohlsearch<cr>

" reselect when indenting
vnoremap < <gv
vnoremap > >gv

" clipboard fusion!
set clipboard^=unnamed clipboard^=unnamedplus

" turn folding on and open by default
set foldmethod=syntax
set foldlevel=99

" remove the need to hit c-w for navigating splits
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l
set laststatus=2

" remap regreplop keys
" nmap <c-k> <Plug>ReplaceMotion
" nmap <c-k> <Plug>ReplaceLine
" vmap <c-k> <Plug>ReplaceVisual
map <leader>j cw<C-r>0<ESC>

" resize windows more easily
" nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
" nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

if bufwinnr(1)
    noremap <silent> <C-J> :vertical resize +3<CR>
    noremap <silent> <C-K> :vertical resize -3<CR>
endif

" Make splitting Vim windows easier
map <leader>; <C-W>s
map <leader>` <C-W>v
