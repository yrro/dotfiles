"behave mswin
"source $VIMRUNTIME/mswin.vim

" display filename and path in window title
set title

" enable mouse in all modes
set mouse=a
" make mouse behave like mac/windows/gnome
set mousemodel=popup_setpos

" hilight search results
set hlsearch
" incremental search
set incsearch

" show patching parentheses
set showmatch

" always display status line
set laststatus=2

" show partial command in status line
set showcmd

" display possible choices when tab completing
set wildmenu

set shiftwidth=4
set softtabstop=4

set autoindent

set nowrap
set linebreak

set modeline

syntax on

" hide toolbars, tearoff menu items and don't fork
set guioptions-=T
set guioptions-=t
set guioptions+=f
set guifont=Monospace\ 8

set display+=lastline

autocmd FileType mail setlocal spell spelllang=en_gb  
autocmd FileType debchangelog setlocal expandtab

" don't use tabs in python files
autocmd FileType python setlocal expandtab
autocmd FileType python source ~/.vim/python.vim

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
if $DISPLAY != ''
	gui
endif

"set listchars=eol:␤,tab:␉\ ,trail:␠,extends:>,precedes:<,nbsp:␠
"set list
