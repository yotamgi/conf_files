set nocompatible              " be iMproved, required
filetype on                   " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Bundle 'steffanc/cscopemaps.vim'
Bundle 'moll/vim-bbye'

Plugin 'bling/vim-bufferline'
Plugin 'scrooloose/Syntastic'
Plugin 'valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


nmap <F3> :cs find g <C-R>=expand("<cword>")<CR><CR>	
map     :cs find s <C-R>=expand("<cword>")<CR><CR>	
"map OD 
"map OC <C-I>
"map [D :bp<CR>
"map [C :bn<CR>
"map <C-w> :Bd<CR>

set hls
set incsearch
set bg=dark
set textwidth=80
set ruler " show the cursor position all the time
autocmd FileType c setlocal sw=8 ts=8 sts=8
autocmd FileType c set cindent
autocmd FileType py setlocal sw=4 ts=4 sts=4
autocmd FileType py set expandtab
autocmd FileType py set smartindent
autocmd FileType gitcommit set spell
autocmd FileType gitcommit set textwidth=75

highligh OverLength ctermbg=red ctermfg=white
match OverLength /\%81v.\+/

"set wrap linebreak textwidth=0 
let c_space_errors=1
highlight WhitespaceEOL ctermbg=red guibg=red

" Cscope externals
let externals_fname = './.cscope_externals'
if filereadable(externals_fname)
		for external in readfile(externals_fname)
			exec "silent cscope add " . external . "/cscope.out  " . external
		endfor
endif

" Syntastic configurations (Checkpatch)
let g:syntastic_c_checker_checkpatch_exec = '/srv/data/yotamg/linux_mlxsw/scripts/checkpatch.pl'
let g:syntastic_c_checkers = ['checkpatch']
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }
command Checkpatch :SyntasticCheck
