" from https://realpython.com/vim-and-python-a-match-made-in-heaven/

set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'                        " let Vundle manage Vundle, required
Plugin 'scrooloose/nerdcommenter'                 " To add Comments in code (language dependent)
Plugin 'sjl/gundo.vim'                            " To manage the undo and redo levels
Plugin 'tpope/vim-fugitive'                       " Git interface


" .................... Python Related Plugins Start.................... "
Plugin 'nvie/vim-flake8'
Plugin 'vim-syntastic/syntastic'
Plugin 'fs111/pydoc.vim'                          " pydoc: look up python functions with <shift>-K
" .................... Python Related Plugins End .................... "


" .................... C++ Related Plugins Start.................... "
Plugin 'octol/vim-cpp-enhanced-highlight'         " Additional VIM Syntax for C++ (including C++11/14/17)
Plugin 'majutsushi/tagbar' 
Plugin 'vim-scripts/Conque-GDB'                   " GDB in VIM
" .................... C++ Related Plugins End.................... "


" .................... Auto-Completion Related Plugins Start .................... "
Plugin 'Valloric/YouCompleteMe'
Plugin 'ervandew/supertab'
" .................... Auto-Completion Related Plugins End .................... "


" Colors
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'


" Powerline is a status bat that displays things like the current virtualenv,
" git branch, files being edited, and much more
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'} 


" File System
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'


" To show differnt files in color in NERDTree and more:
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'ryanoasis/vim-devicons'


" All of our Plugins must be added before the following line
call vundle#end()            " required






"................. Start Python Stuff .................
"python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


au BufNewFile,BufRead *.py
    \ set tabstop=4       |   
    \ set softtabstop=4   |  
    \ set shiftwidth=4    |  
    \ set textwidth=79    |  
    \ set expandtab       | 
    \ set autoindent      |  
    \ set fileformat=unix |  
    \ set encoding=utf-8   


highlight BadWhitespace ctermbg=red guibg=red                         " Use the below highlight group when displaying bad whitespace is desired.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/          " Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/  " Make trailing whitespace be flagged as bad.


autocmd FileType python set foldmethod=indent     " Enable folding
set foldlevel=99
nnoremap <space> za                               " Enable folding with the spacebar
let python_highlight_all=1                        " To make code look pretty
autocmd FileType python set omnifunc=pythoncomplete#Complete "omnicomplete
" Mapping of F6 to save and run the python command inside the vim
autocmd FileType python nnoremap <buffer> <F6> <ESC>:w<CR>:!python3 %<cr>

" If you want to see the output along the code, comment the above line and
" uncomment the below line. It will open the output in right side of the
" screen in terminal
" autocmd FileType python nnoremap <buffer> <F6> <ESC>:w<CR>:botright vert ter python3 %<cr>
"................. End Python Stuff .................

autocmd filetype cpp nnoremap <buffer> <F6> <ESC>:w<CR>:exec '!g++ -g '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
nnoremap <F8> :botright vert ter<CR>

".................... Settings related to NERDTree start ...................."
let g:nerdtree_tabs_open_on_console_startup=0     " To run NERDTreeTabs on console vim startup, set 1
map <C-n> :NERDTreeTabsToggle<CR>                 " Mapping CTRL + N to On/Off NerdTree for all tabs
let g:NERDSpaceDelims = 1                         " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1                     " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'                   " Align line-wise comment delimiters flush left instead of following code indentation
map <C-_> <plug>NERDCommenterInvert               " Mapping of NERDCommenterInvert to CTRL+ /
let NERDTreeHighlightCursorline=1                 " Highlight the selected entry in the tree
".................... Settings related to NERDTree end ...................."


".................... Related to vim-cpp-enhanced-highlight plugin Start ...................." 
let g:cpp_class_scope_highlight = 1               " Highlighting of class scope is disabled by default. To enable set
let g:cpp_class_decl_highlight = 1                " Highlighting of class names in declarations is disabled by default. To enable set
let g:cpp_member_variable_highlight = 1           " Highlighting of member variables is disabled by default. To enable set
".................... Related to vim-cpp-enhanced-highlight plugin End ...................." 


" To toggle between the color schemes
if 1
  if has('gui_running')
    set background=dark
    colorscheme solarized
  else
    colorscheme zenburn
  endif
endif


"split navigations
nnoremap <C-J> <C-W><C-J>                         " Ctrl + J move to the split below 
nnoremap <C-K> <C-W><C-K>                         " Ctrl + K move to the split above
nnoremap <C-L> <C-W><C-L>                         " Ctrl + L move to the split to the right
nnoremap <C-H> <C-W><C-H>                         " Ctrl + H move to the split to the left

let g:clang_library_path='/home/ujjwal/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clang/lib/libclang.so.9'


" To make vim return to the same line when we reopen a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


let g:ycm_autoclose_preview_window_after_completion=1           " It line ensures that the auto-complete
                                                                " window goes away when we are done with it.
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>  " Mapping goto definition.
let NERDTreeIgnore=['\.pyc$', '\~$']              " Ignore files in NERDTree
nmap <F7> :TagbarToggle<CR>


".................... Settings related to Gundo Plugin start...................."
" Make gundo to use Python3 instead of python2
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

set undofile                                      " Make undo files 
set history=100                                   " Default value = 20 
set undolevels=100                                " No. of undo levels
nnoremap <F5> :GundoToggle<CR>                    " Mapping of the GundoToggle
set undodir=~/.vim/tmp/undo//                     " Undo directory for gundo plugin
let g:gundo_right = 1                             " Open the gundo graph to the right side of the screen istead of left
let g:gundo_help = 1                              " Disable the help text in Gundo window
".................... Settings related to Gundo Plugin End ...................." 


".................... Settings related to syntastic plugin start...................."
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}      " When syntax errors are detected a flag will be shown
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1      " To automatically update its output each time an error is resolved
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0                 " To make Syntastic highlights the errors automatically when a file is opened, 
let g:syntastic_check_on_wq = 0
".................... Settings related to syntastic plugin end...................."


syntax on
set autoindent
set textwidth=80
set ttyscroll=0
set hlsearch
" set laststatus=2                                  " Always show the statusline
set foldenable                                    " Enable folding
set foldnestmax=10                                " 10 nested fold max
set foldmethod=indent                             " fold based on indent level
set ma                                            " will make buffer modifiable
set nu rnu                                        " Turn on the hybrid line numbers on the side of the screen
set softtabstop=2                                 " Tab key results in # spaces
set shiftwidth=2                                  " controls the depth of the autoindentation
set tabstop=4                                     " Tab is # space
set expandtab                                     " converts tabs to spaces
set ignorecase                                    " Ignore case when searching.
set smartcase                                     " Automatically switch search to case-sensitive when search query contains an uppercase letter.
set wrap                                          " Enable line wrapping.
set linebreak                                     " Avoid wrapping a line in the middle of a word
set ruler                                         " To show the cursor position
set showmode                                      " Show the current mode.
set showcmd                                       " show partial command on last line of screen.
filetype plugin indent on                         " enables filetype detection
set showmatch                                     " show the matching part of the pair for [] {} and ()
set backspace=indent,eol,start                    " make backspaces more powerfull

autocmd Filetype cpp setlocal expandtab tabstop=2 shiftwidth=2
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4
nmap :W   :w
nmap :Q   :q
map   q   :q<CR>
" map   w   :w<CR>
