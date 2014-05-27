if filereadable(expand("~/.vim/autoload/pathogen.vim"))
	call pathogen#infect()
endif

" display filename and path in window title
set title

" taken from debian.vim
set nocompatible
set backspace=indent,eol,start

set directory=/var/tmp//

" enable mouse in all modes
set mouse=a
" make mouse behave like mac/windows/gnome
set mousemodel=popup_setpos

set splitbelow
set splitright

" hilight search results
set hlsearch
" incremental search
set incsearch

" show patching parentheses
set showmatch

" always display status line
set laststatus=2

" highlight current line
set cursorline

" emulate default status line; add git branch info
" requires addon from http://github.com/taq/vim-git-branch-info
let g:git_branch_status_head_current=1
let g:git_branch_status_text=''
let g:git_branch_status_nogit=''
if exists ("GitBranchInfoString")
    set statusline=%<%f\ %{GitBranchInfoString()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
en
set ruler

" show partial command in status line
set showcmd

" display possible choices when tab completing
set wildmenu
set wildmode=longest,list:longest,list:full

"set shiftwidth=4
"set softtabstop=4

"set autoindent

set nowrap
set linebreak

set modeline

filetype plugin indent on
syntax on

" hide toolbars, tearoff menu items and don't fork
set guioptions-=T
set guioptions-=t
set guioptions+=f

if has ("win32")
    set guifont=DejaVu_Sans_Mono:h9
elseif has ("mac")
    set guifont=Menlo\ Regular:h12
else
    set guifont=Monospace\ 9
endif

set guicursor+=a:blinkon0

set display+=lastline

set spelllang=en_gb

autocmd FileType mail setlocal spell
autocmd FileType debchangelog setlocal expandtab

" don't use tabs in python files
autocmd FileType python setlocal expandtab

if filereadable ("~/.vim/python.vim")
    autocmd FileType python source ~/.vim/python.vim
endif

autocmd filetypedetect BufNewFile,BufRead COMMIT_EDITMSG set ft=gitcommit

" actionscript, not atlas
autocmd! filetypedetect BufNewFile,BufRead *.as
autocmd  filetypedetect BufNewFile,BufRead *.as set ft=actionscript

set pastetoggle=<F10>

" Make navigation behave more sensible when 'wrap' is set.
" Taken from <http://www.vim.org/tips/tip.php?tip_id=38>
"map <up>   gk
"map <down> gj
"map <home> g<home>
"map <end>  g<end>
"imap <up>   <C-o>gk
"imap <down> <C-o>gj
"imap <home> <C-o>g<home>
"imap <end>  <C-o>g<end>

filetype indent on

" disable syntax highlighting in diff mode
if &diff
	"set columns=151
	"map :q :qa
	syn off
endif

" automatically load the GUI when run under X11
if has('gui') && $DISPLAY != ''
	gui
endif

"set listchars=eol:␤,tab:␉\ ,trail:␠,extends:>,precedes:<,nbsp:␠
"set list

"autocmd BufWritePost,FileWritePost /home/sam/src/occ/data/occ.py silent !ln -sf <afile>:p ~/.openoffice.org2/user/Scripts/python/occ.py

if &term =~ "screen"
	set ttymouse=xterm2
endif

highlight TrailWhitespace ctermbg=red guibg=#ffdecd
match TrailWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
"autocmd Syntax * syn match TrailWhitespace /\s\+$\| \+\ze\t/
