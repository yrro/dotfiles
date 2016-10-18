unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

runtime! autoload/pathogen.vim
if exists("*pathogen#infect")
	call pathogen#infect()
endif

runtime ftplugin/man.vim

" silent
set visualbell
"set t_vb=

" display filename and path in window title
set title

" taken from debian.vim
"set nocompatible
"set backspace=indent,eol,start

set directory=/var/tmp//

" enable mouse in all modes
"set mouse=a
" make mouse behave like mac/windows/gnome
set mousemodel=popup_setpos

set splitbelow
set splitright

" hilight search results
set hlsearch
" incremental search
"set incsearch

" show patching parentheses
"set showmatch

" always display status line
set laststatus=2

" highlight current line
set cursorline

" emulate default status line; add git branch info
set statusline=%<%f\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

"set ruler

" show partial command in status line
"set showcmd

" display possible choices when tab completing
"set wildmenu
set wildmode=longest,list:longest,list:full

"set shiftwidth=4
"set softtabstop=4

"set autoindent

set nowrap
set linebreak

set modeline

"filetype plugin indent on
"syntax on

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

"set listchars=eol:␤,tab:␉\ ,trail:␠,extends:>,precedes:<,nbsp:␠
"set list

"autocmd BufWritePost,FileWritePost /home/sam/src/occ/data/occ.py silent !ln -sf <afile>:p ~/.openoffice.org2/user/Scripts/python/occ.py

highlight TrailWhitespace ctermbg=red guibg=#ffdecd
match TrailWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
"autocmd Syntax * syn match TrailWhitespace /\s\+$\| \+\ze\t/

" http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=552108
let g:is_posix = 1

let g:localvimrc_persistent=1

let g:syntastic_puppet_puppetlint_exec = '~/.gem/ruby/1.9.1/bin/puppet-lint'

nnoremap <silent> <Leader>T :CommandTTag<CR>

" from gvimrc_example.vim
let c_comment_strings=1

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" " so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

autocmd FileType text setlocal tw=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

nnoremap <leader>G :GundoToggle<CR>

"colorscheme anotherdark
colorscheme xoria256

set breakindent

let g:GPGExecutable = "gpg2 --trust-model always"

let g:EditorConfig_exec_path = '/usr/bin/editorconfig'

if has('packages')
	packadd! matchit
endif
