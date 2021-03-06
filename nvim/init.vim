"
" File: .vimrc
" Path: $HOME
" Tags: neovim editor
" Description: nvim configuration file
" Last Modified: 28/04/2020 00:17
" Author: Colpshift
"
" https://neovim.io/
"

"------------------------------------------------------------------------------
" start settings
"------------------------------------------------------------------------------
set nocompatible
syntax on
filetype plugin indent on
set fileformat=unix
set encoding=utf-8      " Use an encoding that supports unicode.
set nostartofline       " Do not jump to first character with page commands.
set confirm             " Display confirmation dialog when closing unsaved file
"
" run :w!! command (type fast), to save ready only files.
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

"------------------------------------------------------------------------------
" Performance
"------------------------------------------------------------------------------
set complete-=i         " Limit the files searched for auto-completes.
set lazyredraw          " Don’t update screen during macro and script execution.
set hid                 " Avoid Vim-Airline to get information on start
set ttyfast             " Improve smoothness of redrawing

"------------------------------------------------------------------------------
" plugins package manager - vim-plug
"------------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')
"---------------------------
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'rakr/vim-one'
Plug 'romainl/Apprentice'
Plug 'ayu-theme/ayu-vim'
" vim color themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" status/tabline for vim that's light as air
Plug 'ryanoasis/vim-devicons'
" icons
"---------------------------
Plug 'RRethy/vim-illuminate'
" automatically highlighting other uses of the word under the cursor
Plug 'kshenoy/vim-signature'
" place, toggle and display marks.
Plug 'luochen1990/rainbow'
" show diff level of parentheses in diff color
Plug 'ap/vim-css-color'
" Preview colours in source code.
Plug 'akiomik/git-gutter-vim'
" update gutter
"---------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Things you can do with fzf and Vim.
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
" Ranger running in a floating window
"---------------------------
Plug 'machakann/vim-sandwich'
" search/select/edit sandwiched textobjects.
Plug 'andymass/vim-matchup'
" extends vim's % key to language-specific words
Plug 'preservim/nerdcommenter'
" nerdy commenting powers
"---------------------------
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" asynchronous completion framework
Plug 'Shougo/context_filetype.vim'
" adds the context filetype feature.
Plug 'Shougo/neoinclude.vim'
" completes the candidates from the included files and included path.
Plug 'Konfekt/FastFold'
" update folds
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets' 
" snippets
Plug 'deoplete-plugins/deoplete-zsh'
" zsh completion
Plug 'Shougo/neopairs.vim'
" parenteses pairs
"---------------------------
Plug 'dense-analysis/ale' 
" Asynchronous Lint Engine
"---------------------------
call plug#end()

"------------------------------------------------------------------------------
" plugins configuration
"------------------------------------------------------------------------------
"
" airline
"
let g:airline_theme='ayu'
let g:airline_highlighting_cache = 1
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ' '
let g:airline_right_alt_sep = '|'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
"
" signature
"
" mx           Toggle mark 'x' and display it in the leftmost column
" dmx          Remove mark 'x' where x is a-zA-Z
" m-           Delete all marks from the current line
" m<Space>     Delete all marks from the current buffer
" ]`           Jump to next mark
" [`           Jump to prev mark
"
" iluminate
"
let g:Illuminate_delay = 200
"
" Sandwich
"
" include - saiw( makes foo to (foo).
" replace - srb" or sr(" makes (foo) to "foo".
" delete  - sdb or sd( makes (foo) zrto foo.
" ib and is - selects {surrounded text}.
" ab and as - selects {surrounded text} including {surrounding}s.
"
" Rainbow
"
let g:rainbow_active = 1
"
" Rnvimr
"
let g:rnvimr_enable_ex = 1
let g:rnvimr_enable_picker = 0
let g:rnvimr_draw_border = 0
let g:rnvimr_enable_bw = 0
" Customize the initial layout
let g:rnvimr_layout = { 'relative': 'editor',
      \ 'width': float2nr(round(0.6 * &columns)),
      \ 'height': float2nr(round(0.6 * &lines)),
      \ 'col': float2nr(round(0.2 * &columns)),
      \ 'row': float2nr(round(0.2 * &lines)),
      \ 'style': 'minimal' }
"
" Mapping
nnoremap <silent> <C-o> :RnvimrToggle<CR>
tnoremap <silent> <C-o> <C-\><C-n>:RnvimrToggle<CR>
let g:rnvimr_action = {
      \ '<C-t>': 'NvimEdit tabedit',
      \ '<C-x>': 'NvimEdit split',
      \ '<C-v>': 'NvimEdit vsplit',
      \ 'gw': 'JumpNvimCwd',
      \ 'yw': 'EmitRangerCwd'
      \ }
"
" Nerdcommenter
"
" Insert comment leader+cc
" Invert comment leader+ci
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1
"
" fzf
"
map <silent> <leader>l :FZF<CR>
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
"
" Deoplete
"
let g:deoplete#enable_at_startup = 1
"
" Deplete-fastfold
"
let g:fastfold_savehook = 1
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1
"
" ultisnips
"
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" Ale
"
call deoplete#custom#option('sources', {
      \ '_': ['ale'],
      \})
"
let g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
"
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"------------------------------------------------------------------------------
" interface
"------------------------------------------------------------------------------
set termguicolors       " true colors
set hidden              " keep multiple buffers open.
set cmdheight=2         " Give more space for displaying messages
set updatetime=300
set signcolumn=yes
set signcolumn=auto:2
set formatoptions+=l    " make settings permanent.
set shortmess=atIc      " Don’t show the intro message when starting Vim
set nostartofline       " Don’t reset cursor start of line when moving around.
set number
set relativenumber
set cursorline
set ruler               " right side of the status line at the bottom
set mouse=a             " allow mouse clicks to change cursor position
set showmatch           " highlight matching [{()}]
set wildmenu            " Wildmenu enable
set colorcolumn=+1      " color de last column to wrap.
set textwidth=79        " set width for text
set winwidth=110        " set the minimal width of the current window.
set pumheight=10        " makes popup menu smaller
set scrolloff=1         " Number screen lines keep above and below cursor.
set sidescrolloff=5     " Number screen columns keep left and right cursor.
set showcmd             " show command in bottom bar
set showmode            " change the color in according of mode
set clipboard+=unnamedplus " copy and paste between vim and all.
set noerrorbells        " Disable beep on errors.
set visualbell          " Flash the screen instead of beeping on errors.
set nojoinspaces        " Prevents inserting spaces after punctuation on join.
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.
set laststatus=2        " Size of command area and airline
set background=dark
colorscheme ayu
let ayucolor="dark"
"
" move to next and previous buffer
nnoremap <F3> :bnext<CR>

"------------------------------------------------------------------------------
" searching
"------------------------------------------------------------------------------
set ignorecase        " case insensitive
set smartcase         " use case if any caps used
set incsearch         " show match as search proceeds
set hlsearch is       " highlight matches
set inccommand=split  " Show interactive preview of substitute changes
"
" undo hlsearch
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

"------------------------------------------------------------------------------
" indention
"-----------------------------------------------------------------------------
set wrap breakindent    " Soft wrapping + indentation
set autoindent          " indent match with the previous line
set smartindent         " indent after colon for if or for statements
set smarttab            " Uses shiftwidth instead of tabstop at start of lines
set expandtab           " Replaces a tab with spaces--more portable
set shiftwidth=2        " The amount to block indent when using
set softtabstop=2       " Causes backspace to delete 2 spaces converted tab
set shiftround          " Round the indentation to earest multiple shiftwidth.
set backspace=eol,start,indent  " Make sure backspace works in insert mode
"
" auto indent the whole file and keep your cursor in the last position
nmap <F7> mzgg=G`z

"------------------------------------------------------------------------------
" folding
"------------------------------------------------------------------------------
"set foldenable          " enable fold
set foldcolumn=2        " show column indent
set foldmethod=indent   " indentation method

"------------------------------------------------------------------------------
" swap, undo and backup
"------------------------------------------------------------------------------
set undofile
set undodir=$HOME/.local/share/nvim/undo
set noswapfile
set nobackup
set nowritebackup

"------------------------------------------------------------------------------
" code environments
"------------------------------------------------------------------------------
"
" Clear whitespaces
nnoremap <silent> <F9> <Esc>:%s/\s\+$//e<CR>
"
" insert timestamp
inoremap <F10> <C-R>=strftime("%d/%m/%Y %H:%M")<CR>
"
" ruby
let g:ruby_host_prog = '~/.gem/ruby/2.7.0/bin/neovim-ruby-host'
"
" python
let g:python3_host_prog = '/bin/python3'

"------------------------------------------------------------------------------
" Workarounds
"------------------------------------------------------------------------------
"
" Copying to X11 primary selection with the mouse
vnoremap <LeftRelease> "*ygv

