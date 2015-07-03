set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" ----- Core components -----------------------------------------------
Bundle 'gmarik/Vundle.vim'

" ----- Making Vim look good ------------------------------------------
Bundle 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'
Bundle 'bling/vim-airline'
Bundle 'jedverity/feral-vim'
Bundle 'justincampbell/vim-railscasts'
Bundle 'jmcantrell/vim-virtualenv'

" ----- Vim as a programmer's text editor -----------------------------
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'scrooloose/syntastic'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-easytags'
Bundle 'majutsushi/tagbar'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/a.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'zef/vim-cycle'
Bundle 'junegunn/vim-easy-align'
Bundle 'terryma/vim-expand-region'
Bundle 'hari-rangarajan/CCTree'
"Bundle 'vim-scripts/OmniCppComplete'
Bundle 'Valloric/YouCompleteMe'

" ----- man pages, tmux -----------------------------------------------
Bundle 'jez/vim-superman'
Bundle 'christoomey/vim-tmux-navigator'

" ----- Syntax plugins ------------------------------------------------
Bundle 'jez/vim-c0'
Bundle 'jez/vim-ispc'
Bundle 'kchmck/vim-coffee-script'

" ---- Extras/Advanced plugins ----------------------------------------
" Highlight and strip trailing whitespace
Bundle 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Bundle 'tpope/vim-surround'
" Align CSV files at commas, align Markdown tables, and more
Bundle 'godlygeek/tabular'
" Automaticall insert the closing HTML tag
Bundle 'vim-scripts/HTML-AutoCloseTag'
" Make tmux look like vim-airline (read README for extra instructions)
Bundle 'edkolev/tmuxline.vim'
" All the other syntax plugins I use
Bundle 'ekalinin/Dockerfile.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'tpope/vim-liquid'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'sjl/gundo.vim'
Bundle 'vhdirk/vim-cmake'
Bundle 'vim-scripts/SQLComplete.vim'
Bundle 'vim-scripts/Tag-Signature-Balloons'

call vundle#end()

filetype plugin indent on
syntax on

" ----------------------- General settings -------------------------------
set showcmd
set cmdheight=1

set number
set ruler

set incsearch
set hlsearch

set backspace=indent,eol,start
set nostartofline

set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

set shiftwidth=4 softtabstop=4
set switchbuf=usetab

set nocp
set nowrap
set expandtab

set splitright
set cursorline

set nobackup
set noswapfile

set mouse=a

runtime ftplugin/man.vim

" ----- Wildmenu completion -----
set wildmenu
set wildmode=list:longest
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
set wildignore+=.hg,.git,.svn			    " Version Controls"
set wildignore+=*.aux,*.out,*.toc		    "Latex Indermediate files"
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg	    "Binary Imgs"
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest    "Compiled Object files"
set wildignore+=*.spl				    "Compiled speolling world list"
set wildignore+=*.sw?				    "Vim swap files"
set wildignore+=*.DS_Store			    "OSX SHIT"
set wildignore+=*.luac				    "Lua byte code"
set wildignore+=migrations			    "Django migrations"
set wildignore+=*.pyc				    "Python Object codes"
set wildignore+=*.orig				    "Merge resolution files"

" ----- Search patterns -----
let g:cpp_pattern	=   "*.{cpp,c,h,hpp}"
let g:java_pattern	=   "*.{java}"
let g:makefile_pattern	=   "Makefile*"
let g:text_pattern	=   "*.{txt,text}"
let g:python_pattern	=   "*.{py}"
let g:cpp_java_pattern	=   "*.{cpp,c,h.hpp,java}"
let g:scp_pattern	=   "*.{scp}"

" ----- Globaj project settings -----
let g:project_root = "."
let g:search_root = g:project_root
let g:search_pattern = "*.*"

" ----- GUI specal setting -----
if has ('gui_running')
    set guioptions-=T
    set guioptions+=a
    colorscheme railscasts
else
    set t_Co=256
    colorscheme badwolf
endif

" setting ctags
set tags+=~/.vim/tags/last_project_tags
set tags+=~/.vim/tags/dtv_project
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/opencv
set tags+=~/.vim/tags/qt5
set tags+=~/.vim/tags/usr_local_include

" Resize split when the window is resized
au VimResized * :wincmd =

au BufNewFile,BufRead *.c,*.cc,*.cpp,*.h call SetupCandCPPenviron()
function! SetupCandCPPenviron()
    set path+=/usr/include/c++/**
    noremap <buffer> <silent> K :exe "Man" 3 expand('<cword>') <CR>
endfunction

autocmd VimEnter * NERDTree .
autocmd VimEnter * helptags ~/.vim/doc
autocmd VimEnter * TagbarOpen
autocmd VimEnter * exe 2 . "wincmd w"

" ----------------------------- Some Function --------------------------------

" ----- Text replace functions -----
function! MySearchText()
    let text = input("Text to find: ")
    :call MySearchSelectedText(text)
endfunction

function! MySearchSelectedText(text)
    :execute "vimgrep /" . a:text . "/jg ".g:search_root."/**/".g:search_pattern
endfunction


function! MyReplaceText()
    let replacee = input("Old text: ")
    let replacor = input("New text: ")
    :execute "%s/" . replacee . "/" . replacor. "/gI"
endfunction

function! MyReplaceSelectedText(oldText)
    let replacor = input("New text: ")
    :execute "%s/" . a:oldText . "/" . replacor. "/gI"
endfunction

function! BufferIsEmpty()
    if line('$') == 1 && getline(1) == ''
        return 1
    else
        return 0
    endif
endfunction

" ----- Tag function -----
function! UpdateTags()
    execute ":!ctags -R --sort=yes --fields=+iaSnkt --extra=+q+f --exclude=build --exclude=ClearCase --exclude=third_party_ecs --exclude=TBIRD --exclude=.svn --exclude=stage.1 --exclude=stage.2 --exclude=stage.5 --exclude=stage.7 --exclude=foundation_docs --exclude=foundation_src --exclude=*.sl --exclude=*.pm -f ~/.vim/tags/last_project_tags `pwd`"
    echohl StatusLine | echo "C\\C++ tags updated" | echohl None
endfunction

function! UpdateAllTags()
    execute ":!ctags -R --sort=yes --fields=+iaSnkt --extra=+q+f --exclude=build --exclude=ClearCase --exclude=third_party_ecs --exclude=TBIRD --exclude=.svn --exclude=stage.1 --exclude=stage.2 --exclude=stage.5 --exclude=stage.7 --exclude=foundation_docs --exclude=foundation_src --exclude=*.sl --exclude=*.pm -f ~/.vim/tags/last_project_tags `pwd`"
    execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSnkt --extra=+q+f -f ~/.vim/tags/usr_local_include /usr/local/include"
    execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSnkt --extra=+q+f -f ~/.vim/tags/cpp ~/.vim/tags/cpp_src"
    execute ":!ctags -R --sort=yes --languages=C++ --c++-kinds=+p --fields=+iaSkt --extra=+q+f -f ~/.vim/tags/opencv /usr/local/include/opencv2"
    echohl StatusLine | echo "C\\C++ tags updated" | echohl None
endfunction

function! IsFileAlreadyExists(filename)
    if filereadable(a:filename)
        return 1
    else
        return 0
    endif
endfunction

"Invoke this function if we are opening main.cpp or main.c file"
function! CheckIfMain()
    if !IsFileAlreadyExists(expand("%:t")) && expand("%:t:r") == "main" && expand("%:e") == "cpp"
        execute 'normal! 1G 1000dd'
        execute ':Template maincpp'
        execute ':w'
    elseif !IsFileAlreadyExists(expand("%:t")) && expand("%:t:r") == "main" && expand("%:e") == "c"
        execute 'normal! 1G 1000dd'
        execute ':Template mainc'
        execute ':w'
    endif
endfunction

"Invoke this function when you would like to create new C++ class files (.cpp and .h file)
function! CreateCppClassFiles(className)
    "create cpp file
    if !IsFileAlreadyExists(a:className.'.cpp')
        execute ':n '.a:className.'.cpp'
        execute 'normal! 1G 1000dd'
        execute ':Template cppclass'
        execute ':w'
    else
        execute ':n '.a:className.'.cpp'
    endif
    "create h file
    if !IsFileAlreadyExists(a:className.'.h')
        execute ':n '.a:className.'.h'
        execute 'normal! 1G 1000dd'
        execute ':Template cppclassh'
        execute ':w'
    else
        execute ':n '.a:className.'.h'
    endif
endfunction

"create new command for creating cpp class
command! -nargs=1 NewCppClass call CreateCppClassFiles("<args>")

" ----------------------- Plugin-Specific Settings ---------------------------

" ----- NERDTree setting -----
noremap  <leader>n		:NERDTreeToggle<CR>
inoremap <leader>n <ESC>	:NERDTreeToggle<CR>i
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$']

" ----- Omni complete setting -----
"let g:SuperTabDefaultCompletionType = "context"

"autocmd FileType python	    set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html	    set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType xml	    set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType css	    set omnifunc=csscomplete#CompleteCSS
"autocmd FileType cpp	    set omnifunc=omni#cpp#complete#Main
"autocmd FileType c	    set omnifunc=omni#cpp#complete#Main
"autocmd FileType scp	    set omnifunc=omni#cpp#complete#Main

"set omnifunc=syntaxcomplete#Complete
"let OmniCpp_NamespaceSearch     = 2
"let OmniCpp_GlobalScopeSearch   = 1
"let OmniCpp_DisplayMode         = 1
"let OmniCpp_ShowScopeInAbbr     = 0
"let OmniCpp_ShowPrototypeInAbbr = 0
"let OmniCpp_ShowAccess          = 1
"let OmniCpp_SelectFirstItem     = 2
"let OmniCpp_MayCompleteDot      = 1
"let OmniCpp_MayCompleteArrow    = 1
"let OmniCpp_MayCompleteScope    = 1

"set completeopt=menuone,menu,longest "preview

" ----- VIM-airline settings -----
let g:airline#extensions#tabline#enabled	= 1
let g:airline#extensions#tabline#left_sep	= ' '
let g:airline#extensions#tabline#left_alt_sep	= '|'

function! AirlineInit()
    let g:airline_section_a = airline#section#create(['mode'])
    let g:airline_section_c = airline#section#create(['%F'])
endfunction

autocmd VimEnter * call AirlineInit()

let g:airline_theme_patch_func = 'AirlineThemePatch'

function! AirlineThemePatch(palette)
    if g:airline_theme == 'railscasts'
        for colors in values(a:palette.inactive)
            let colors[3] = 245
        endfor
    endif
endfunction

" ----- Syntastic settings -----
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_error_symbol			                = '✘'
let g:syntastic_warning_symbol			                = "▲"
let g:syntastic_always_populate_loc_list	                = 0
let g:syntastic_auto_loc_list			                = 0
let g:syntastic_check_on_open			                = 0
let g:syntastic_check_on_wq			                = 0

" ----- vim-easytags settings -----
let g:easytags_events                                           = ['BufReadPost', 'BufWritePost']
let g:easytags_async                                            = 1
let g:easytags_dynamic_files                                    = 2
let g:easytags_resolve_links                                    = 1
let g:easytags_suppress_ctags_warning                           = 1

" ----- delimitMate settings -----
let delimitMate_expand_cr                                       = 1

augroup mydelimitMate
    au!
    au FileType markdown let b:delimitMate_nesting_quotes       = ["`"]
    au FileType tex let b:delimitMate_quotes                    = ""
    au FileType tex let b:delimitMate_matchpairs                = "(:),[:],{:},`:'"
    au FileType python let b:delimitMate_nesting_quotes         = ['"', "'"]
augroup END

" ----- CtrlP settings -----
let g:ctrlp_map                                                 = '<c-p>'
let g:ctrlp_cmd                                                 = 'CtrlP'
let g:ctrlp_working_path_mode                                   = 'ra'

" ----- Gundo setting -----
let g:gundo_width                                               = 60
let g:gundo_preview_height                                      = 40
let g:gundo_right                                               = 1

" ----- YouCompleteMe --------------
let g:ycm_filetype_blacklist = {
	\ 'tagbar' : 1,
	\ 'qf' : 1,
	\ 'notes' : 1,
	\ 'markdown' : 1,
	\ 'unite' : 1,
	\ 'text' : 1,
	\ 'vimwiki' : 1,
	\ 'pandoc' : 1,
	\ 'infolog' : 1,
	\ 'mail' : 1
	\}

let g:ycm_semantic_triggers =  {
	\   'c' : ['->', '.'],
	\   'objc' : ['->', '.'],
	\   'ocaml' : ['.', '#'],
	\   'cpp,objcpp' : ['->', '.', '::'],
	\   'perl' : ['->'],
	\   'php' : ['->', '::'],
	\   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
	\   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
	\   'ruby' : ['.', '::'],
	\   'lua' : ['.', ':'],
	\   'erlang' : [':'],
	\ }
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1

" ------------------------------ Bindings ------------------------------------

" \W - Remove white space from file
nnoremap <leader>W	        :%s/\s\+$//<cr>:let @/=''<CR>

" \ft - Fold tag, HTML editing
nnoremap <leader>ft	        vatzf

" \q Re-hardwrap paragrah
nnoremap <leader>q	        gqip

" \v Select just pasted text
nnoremap <leader>v	        V`]

" \ev Shortcut to edit .vimrc
nnoremap <leader>ev	        <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Make window mosaic
nmap <leader>mon	        :split<cr>:vsplit<cr><C-Down>:vsplit<cr><C-Up><leader>l
imap <leader>mon <ESC>	        :split<cr>:vsplit<cr><C-Down>:vsplit<cr><C-Up><leader>li

" Replace command
nmap <F6>		        :execute "call MyReplaceText()"<cr>
imap <F6> <ESC>l	        :execute "call MyReplaceText()"<cr>
nmap <F7>		        :execute "call MyReplaceSelectedText(\"".expand('<cword>')."\")" <cr>
imap <F7> <ESC>l	        :execute "call MyReplaceSelectedText(\"".expand('<cword>')."\")" <cr>

"Find in many files and navigate between search results
map <F3>		        :call MySearchText() <Bar> botright cw<cr>
map <F3><F3>		        :execute "call MySearchSelectedText (\"".expand("<cword>") . "\")" <Bar> botright cw<cr>
nmap <A-Right>		        :cnext<cr>
nmap <A-Left>		        :cprevious<cr>

" Make check spelling on or off
nmap <leader>cson	        :set spell<CR>
nmap <leader>csoff	        :set nospell<CR>

" Indentation (got to opening bracket and indent section)
nmap <leader>ip		        [{=%

"Highlight section between brackets (do to opening bracket and highlight)
nmap <leader>hp		        [{%v%<Home>

" Double learder for selection whole line
nmap <Leader><Leader>	        V

" Normal make
nmap <F9>		        :set makeprg=make\ -C\ .<cr> :make --no-print-directory <cr> :TagbarClose<cr> :cw <cr> :TagbarOpen <cr>
imap <F9> <ESC>		        set makeprg=make\ -C\ ./build<cr> :make --no-print-directory <cr> :TagbarClose<cr> :cw <cr> :TagbarOpen <cr>i

" TAB and Shift-TAB in normal mode cycle buffer
nmap <Tab>		        :bn<CR>
nmap <S-Tab>		        :bp<CR>

" K Manpage for word under cursor
noremap <buffer> <silent> K	:exe "Man" expand('<cword>') <CR>

" F4 Syntastic check
noremap <silent> <F4>		:SyntasticCheck<CR>
noremap! <silent> <F4> <ESC>	:SyntasticCheck<CR>

" Update tags
nmap <C-F11>		        :call UpdateAllTags()<cr>
imap <C-F11> <ESC>l	        :call UpdateAllTags()<cr>
nmap <C-F12>		        :silent call UpdateTags()<cr>:w<cr>
imap <C-F12> <ESC>l	        :silent call UpdateTags()<cr>:w<cr>i

" Resize split window horizontally and vertically. Shortcuts to Shift-Alt-Up - Alt is mapped as M in vim
nmap <S-M-Up>		        :2winc+<cr>
imap <S-M-Up> <Esc>	        :2winc+<cr>i
nmap <S-M-Down>		        :2winc-<cr>
imap <S-M-Down> <Esc>	        :2winc-<cr>i

nmap <S-M-Left>		        :2winc><cr>
imap <S-M-Left> <Esc>	        :2winc><cr>i
nmap <S-M-Right>	        :2winc<<cr>
imap <S-M-Right> <Esc>	        :2winc<<cr>i

" Open/close tagbar with \b
nmap <silent> <leader>b         :TagbarToggle<CR>

" Open last buffer
nnoremap <F10>		        :b <C-Z>

" Switch buffers
nnoremap <F7>		    :buffers<CR>:buffer<Space>

" Trun off highlight untill next search
nnoremap <Space>            :noh<CR>

" Indent current code block
nnoremap <C-k>              :=i{<CR>
