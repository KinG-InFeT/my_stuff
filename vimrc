" BlackLight's damn cool .vimrc Modded By KinG-InFeT - www.kinginfet.net

syntax on

set autoindent
set smartindent
set smarttab
set cindent
set spelllang=en_gb
set mouse=a
set nocompatible

" If the terminal is the standard tty, don't even try to set 256 colors
" on the terminal
if $TERM != "linux"
	set t_Co=256
endif

set ic
set smartcase
set hlsearch
set incsearch

" Set the statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%l,%v][%p%%]\ [LEN=%L]
set laststatus=2
set mousemodel=extend

set fileencodings=utf-8
set encoding=utf-8
set termencoding=utf-8
set guifont=Terminus\ 8

set iskeyword+=:
set cot+=menuone

set number
set showmode ruler
set ruler
set showmatch
set shiftwidth=5
set ts=5
set backspace=2
set backup
set backupdir=~/.tmp
set mouse=a
set diffopt+=iwhite

set noerrorbells
set novisualbell
set t_vb=

" Increment also letters
set nrformats+=alpha

" completion
set wildmode=longest:full
set wildmenu

" configure tags - add additional tags here or comment out not-used ones
set tags+=$HOME/.vim/tags/wn
set tags+=$HOME/.vim/tags/c_common
set tags+=$HOME/.vim/tags/cpp
set tags+=$HOME/.vim/tags/gl
set tags+=$HOME/.vim/tags/qt
set tags+=$HOME/.vim/tags/sndfile
set tags+=$HOME/.vim/tags/xmlpp
set tags+=$HOME/.vim/tags/usock
set tags+=$HOME/.vim/tags/neural
set tags+=$HOME/.vim/tags/pltags
set tags+=$HOME/.vim/tags/grassmann
" set tags+=$HOME/.vim/tags/java
set tags+=$HOME/.vim/tags/boost
set tags+=./tags
set tags+=../tags

filetype plugin on

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
let g:closetag_html_style=1 
let g:tex_flavor='latex'

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set complete=.,w,b,u,t,i
set completeopt=menuone,menu,longest,preview
set omnifunc=syntaxcomplete#Complete
"set omnifunc=javacomplete#Complete

au FileType python set omnifunc=pythoncomplete#Complete
" au FileType java set complete+=k/$HOME/.vim/tags/java
au FileType java set omnifunc=javacomplete#Complete 
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType php set omnifunc=phpcomplete#CompletePHP
au FileType cs set omnifunc=syntaxcomplete#Complete
au FileType cs set foldmethod=marker
au FileType cs set foldmarker={,}
au FileType cs set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
au FileType html,xml,xsl source ~/.vim/plugin/closetag.vim
au FileType html,xml,xsl set textwidth=120
au FileType tex,conf,none set textwidth=80

let php_sql_query=1                                                                                        
let php_htmlInStrings=1
let spell_auto_type="tex,doc,mail"
let mousemodel="popup_setpos"

" let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

set background=dark
let treeExplVertical=1
let treeExplWinSize=50

hi clear
if exists("syntax_on")
  syntax reset
endif

" Folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by
" Ostrygen au FileType cs set omnifunc=syntaxcomplete#Complete
set foldmethod=indent
set foldlevelstart=10

" General colors
hi Normal        ctermfg=lightgray
hi Directory     term=bold  ctermfg=red
hi errormsg      term=standout  ctermfg=white ctermbg=red
hi nontext       term=bold  ctermfg=darkgray
hi SpecialKey    term=bold  ctermfg=darkgray
hi LineNr        term=standout  ctermfg=darkgrey
hi IncSearch     term=reverse  cterm=reverse
hi Search        term=bold ctermfg=black ctermbg=red
hi Visual        term=bold ctermfg=247 ctermbg=234
hi VisualNOS     term=bold,underline  cterm=bold,underline
hi MoreMsg       term=bold ctermfg=darkgreen 
hi ModeMsg       term=bold cterm=bold gui=bold
hi Question      term=standout ctermfg=darkgreen
hi WarningMsg    term=standout ctermfg=red
hi WildMenu      term=standout ctermfg=black ctermbg=yellow
hi Folded        term=standout ctermfg=18 ctermbg=white 
hi FoldColumn    term=standout ctermfg=18 ctermbg=white
hi DiffAdd       term=bold ctermbg=blue
hi DiffChange    term=bold ctermbg=darkmagenta
hi DiffDelete    term=bold cterm=bold ctermfg=lightblue ctermbg=cyan
hi DiffText      term=reverse cterm=bold ctermbg=red
hi VertSplit     term=reverse cterm=reverse
hi Title         term=bold ctermfg=darkmagenta
hi Folded        term=bold ctermfg=darkblue ctermbg=black

" Syntax colors
hi Comment     term=bold ctermfg=darkgrey
hi PreProc     term=underline ctermfg=darkgreen
hi Constant    term=underline ctermfg=darkred
hi Type        term=underline ctermfg=darkred
hi Statement   term=standout ctermfg=221
hi Identifier  term=underline ctermfg=28
hi Ignore      term=bold ctermfg=darkgray
hi Special     term=underline ctermfg=cyan
hi Error       term=reverse ctermbg=darkred ctermfg=lightgrey
hi Todo        term=reverse ctermfg=black ctermbg=darkred
hi Underlined  term=underline cterm=underline ctermfg=darkred
hi Number      term=underline ctermfg=darkred

" Syntax links
hi link string 	Constant
hi link character 	Constant
hi link number 	Constant
hi link boolean 	Constant
hi link float 		Number
hi link function 	Identifier
hi link number 	Constant
hi link conditional Statement
hi link repeat 	Statement
hi link label 		Statement
hi link keyword 	Statement
hi link exception 	Statement
hi link operator 	Statement
hi link include 	PreProc
hi link define 	PreProc
hi link macro 		PreProc
hi link precondit 	PreProc
hi link storageclass 	Type
hi link structure 	Type
hi link typedef 	Type
hi link tag 		Special
hi link specialchar Special
hi link delimiter 	Normal
hi link specialcomment 	Special
hi link debug 		Special

hi StatusLine ctermfg=233 ctermbg=grey
hi StatusLineNC ctermfg=233 ctermbg=darkgrey

hi Pmenu ctermfg=221 ctermbg=233
hi PmenuSbar ctermfg=221 ctermbg=black
hi PmenuSel ctermfg=221 ctermbg=235
hi PmenuThumb ctermfg=darkred ctermbg=darkgrey

au InsertEnter * hi StatusLine ctermfg=233 ctermbg=221
au InsertLeave * hi StatusLine ctermfg=233 ctermbg=grey

map <F3> :exe ":!dict ".expand("<cword>")<CR>
map <F4> :TlistOpen<CR>

" Refresh the file
map <F5> :e!<CR>

" Move to the previous/next error found while compiling
map <F7> :cprevious<CR>
map <F8> :cnext<CR>

" Compile and run the file
map <F9> \rc
map <F10> \rr

" Open the tag under the cursor in the preview window
map <F11> :exe ":ptag ".expand("<cword>")<CR>

" VIM commander
map <F12> :call VimCommanderToggle()<CR> 

" Automatic make
map B :make<CR>

" Generate ctags
map C :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Select a bookmark to be removed
map D :delmarks 

" Use J and K to move page up/down
map J <C-f>
map K <C-b>

" Show the current bookmarks
map M :marks<CR>

" Start a shell
map S :shell<CR>

" Start the file explorer
map T :NERDTree<CR>

" Write to the file
map W :w<CR>

" Exit on <C-c> or q
map Q :q!<CR>
map q :quit<CR>
map <C-c> :quit<CR>

"Automatically comment a line
map <C-l> <C-_>b
map <C-p> <C-_><C-_>

" Search
map s :s<CR>

" Open a file in a new tab
map t :tabnew<CR>:e 

" Redo mapping
map \u :undolist<CR>
map . :redo<CR>

" Resize splits
nmap <Right> <C-W>>
nmap <Left> <C-W><
nmap <Up> <C-W>-
nmap <Down> <C-W>+

" Moving through tabs
map gt :tabnext<CR>
map gT :tabprevious<CR>

" Increment number (overrides screen's C-a)
" map <C-a> <C-a>a

" Set number of columns
map <C-t> :set textwidth=

" Spellcheck stuff
nmap ,c :SpellCheck<CR>
nmap ,e \be
nmap ,i \si
nmap ,l :SpellChangeLanguage<CR>
nmap ,n \sn
nmap ,L :SpellSetLanguage 
nmap ,? :SpellProposeAlternatives<CR>
nmap ,p \sp

" Auto-reload .vimrc
nmap ,s :so $HOME/.vimrc<CR>
nmap ,v :vsplit $HOME/.vimrc<CR>

" Open the calendar
nmap \c :Calendar<CR>

" Join two or more lines
nmap ,j :join<CR>
vmap ,j :join<CR>

" LaTeX select template
nmap \lt :TTemplate article<CR>

" Bold and italic mode in LaTeX
vmap <C-b> :!sed -r 's/^(.*)$/\\textbf{\1}/'<CR>
vmap <C-i> :!sed -r 's/^(.*)$/\\textit{\1}/'<CR>
imap <C-b> \textbf
imap <C-i> \textit

" Open a splitted shell
nmap \S :ConqueTermVSplit bash<CR>
" nmap \S :ConqueTermSplit bash<CR>

" No search highlighting
map \z :nohlsearch<CR>

" Call calculator
map \+ !!bc -l<CR>

" Moving through buffers
" map \j :bn<CR>
" map \k :bp<CR>
map gf :bn<CR>
map gb :bp<CR>

" Open a man page for the selected word
map \m :exe ":Man ".expand("<cword>")<CR>

" Automatically split lines
nmap \ls :%!linesplit<CR>
vmap \ls :!linesplit<CR>

" Preview in a web browser
map \w :!surf file://%<CR>

" Completion
imap <C-l> <C-X><C-L>
imap <C-f> <C-X><C-F>

" Comma always followed by a space
" inoremap  ,  ,<Space>

" Autocomplete parenthesis, brackets and braces
" inoremap ( ()<Left>
" inoremap [ []<Left>
" inoremap { {}<Left>
" inoremap " ""<Left>
" vnoremap ( s()<Esc>P<Right>%
" vnoremap [ s[]<Esc>P<Right>%
" vnoremap { s{}<Esc>P<Right>%
" vnoremap " ""<Left>

" Explain in visual mode what, in C, a certain code means
function! EchoVisual(type)
	let sel_save = &selection
	let &selection = "inclusive"
	silent exe "normal! `<" . a:type. "`>y"
	echo system("echo 'explain ".@@."' | cdecl")
endfunction
vnoremap \e :call EchoVisual(visualmode())<CR>

inoremap # X<BS>#
set cinkeys-=0#
set indentkeys-=0#

onoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR><Esc>gv

" Toggle folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

function! IndTxtObj(inner)
	let curline = line(".")
	let lastline = line("$")
	let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
	let i = i < 0 ? 0 : i
	
	if getline(".") !~ "^\\s*$"
		let p = line(".") - 1
		let nextblank = getline(p) =~ "^\\s*$"
			
		while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
			-
			let p = line(".") - 1
			let nextblank = getline(p) =~ "^\\s*$"
		endwhile
			
		normal! 0V
		call cursor(curline, 0)
		let p = line(".") + 1
		let nextblank = getline(p) =~ "^\\s*$"
		
		while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
			+
				let p = line(".") + 1
				let nextblank = getline(p) =~ "^\\s*$"
		endwhile
		normal! $
	endif
endfunction


function! SelectIndent ()
	let temp_var=indent(line("."))
	while indent(line(".")-1) >= temp_var
		exe "normal k"
	endwhile
	
	exe "normal V"
	
	while indent(line(".")+1) >= temp_var
		exe "normal j"
	endwhile
endfun
map <C-g> :exe "normal V"<CR>


function! Errorbells_off(...)
	if a:0 == 0
		let myeb = ""
	else
		let myeb = a:1
	endif
	
	if myeb ==? "flash"
		" audibly beep on error messages
		set errorbells
		
		" Screen flash on error (See also 't_vb')
		set novisualbell
		set t_vb=
	elseif myeb ==? "beep"
		" audibly beep on error messages
		set noerrorbells
		
		" Screen flash on error (See also 't_vb')
		set visualbell
		set t_vb&
	elseif myeb ==? ""
		" audibly beep on error messages
		set noerrorbells
		
		" Screen flash on error (See also 't_vb')
		set visualbell
		set t_vb=
	endif
endfunction

set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
