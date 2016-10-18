unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" makes Man command available even if ft!=man
runtime ftplugin/man.vim

" silent
set visualbell
"set t_vb=

" display filename and path in window title
set title

if filereadable($VIMRUNTIME . "/debian.vim")
	set directory=/var/tmp//
endif

" make mouse behave like mac/windows/gnome
set mousemodel=popup_setpos

set splitbelow
set splitright

" hilight search results
set hlsearch

" always display status line
set laststatus=2

" highlight current line
set cursorline

" emulate default status line; add git branch info
set statusline=%<%f\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" display possible choices when tab completing
"set wildmenu
set wildmode=longest,list:longest,list:full

set nowrap
set linebreak

set modeline

" hide toolbars, tearoff menu items and don't fork
set guioptions-=T
set guioptions-=t
set guioptions+=f

if has ("win32")
    set guifont=Consolas
elseif has ("mac")
    set guifont=Menlo\ Regular:h12
else
    set guifont=Monospace\ 9
endif

set guicursor+=a:blinkon0

set display+=lastline

set spelllang=en_gb

"autocmd FileType mail setlocal spell
"autocmd FileType debchangelog setlocal expandtab

" don't use tabs in python files
"autocmd FileType python setlocal expandtab

" actionscript, not atlas
autocmd! filetypedetect BufNewFile,BufRead *.as
autocmd  filetypedetect BufNewFile,BufRead *.as set ft=actionscript

set pastetoggle=<F10>

" disable syntax highlighting in diff mode
if &diff
	"set columns=151
	"map :q :qa
	syn off
endif

"set listchars=eol:␤,tab:␉\ ,trail:␠,extends:>,precedes:<,nbsp:␠
"set list

highlight TrailWhitespace ctermbg=red guibg=#ffdecd
match TrailWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/
"autocmd Syntax * syn match TrailWhitespace /\s\+$\| \+\ze\t/

" http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=552108
let g:is_posix = 1

let g:localvimrc_persistent=1

let g:syntastic_puppet_puppetlint_exec = '~/.gem/ruby/1.9.1/bin/puppet-lint'

nnoremap <silent> <Leader>T :CommandTTag<CR>

"autocmd FileType text setlocal tw=78

nnoremap <leader>G :GundoToggle<CR>

"colorscheme anotherdark
colorscheme xoria256

set breakindent

let g:GPGExecutable = "gpg2 --trust-model always"

let g:EditorConfig_exec_path = '/usr/bin/editorconfig'

if has('packages')
	packadd! matchit
endif
