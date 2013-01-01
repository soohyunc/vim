"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on " detect the type of a file
filetype plugin on " load filetype plugins
set showcmd " display incomplete commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark
"set number
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set textwidth=80
set tabstop=4 " numbers of spaces of tab chracter
set shiftwidth=4    " numbers of spaces to (auto)indent
"set noexpandtab " real tabs please!
set expandtab
set formatoptions=tcq " See Help (complex)
"set cindent " use c-style indent
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nohlsearch " do not highlight searched for phrases
set hlsearch " do highlight searched for phrases
highlight Search guibg=LightGrey ctermbg=LightGrey
set incsearch " do highlight as you type you search phrase
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("autocmd")
    autocmd BufEnter *.tex,*.txt,*.bbl set formatoptions=aw2tq
    autocmd BufEnter *.c,*.h,*.hh,*.cc,*.cpp,*.java,*.html set cindent
    autocmd FileType cpp,c,java,sh,pl,php,html set autoindent
    autocmd FileType cpp,c,java,sh,pl,php,html set smartindent
endif

" spell check
map ;s :w<CR>:!ispell -x -t %<CR>:e<CR>
au BufRead *.tex,*.txt  set  spell
au BufRead *.tex,*.txt  setlocal spell spelllang=en_us
au BufRead *.tex,*.txt highlight clear SpellBad
au BufRead *.tex,*.txt highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
au BufRead *.tex,*.txt highlight clear SpellCap
au BufRead *.tex,*.txt highlight SpellCap term=underline cterm=underline
au BufRead *.tex,*.txt highlight clear SpellRare
au BufRead *.tex,*.txt highlight SpellRare term=underline cterm=underline
au BufRead *.tex,*.txt highlight clear SpellLocal
au BufRead *.tex,*.txt highlight SpellLocal term=underline cterm=underline


" key mapping for LaTeX
"map! ,b \begin{}<Esc>i
"map! ,e \end{}<Esc>i
"map! ,i \begin{itemize}<Return>\end{itemize}<ESC>O\item
"map! ,f \begin{figure}<Return>\end{figure}<ESC>O


"
" Per http://vim.sourceforge.net/tips/tip.php?tip_id=330
" this will stop the annoying html indentation.
" xmledit does some things for us, and combined with autoindent that's probably
" enough.
"autocmd BufEnter *.erb,*.haml,*.htm,*.html,*.kid,*.php,*.rhtml,*.xml,*.xsd setlocal indentexpr=autoindent shiftwidth=2
autocmd BufEnter *.erb,*.haml,*.htm,*.html,*.kid,*.php,*.rhtml,*.xml,*.xsd setlocal tabstop=2 shiftwidth=2

" BufExplorer
map .b :BufExplorer<CR>
" File Browser
"map .f :20vs ./<CR>
" nmap <C-f>b :30vs $PWD<CR>

" File Explorer
map .f :Explore<CR><CR>
map .v :30Vexplore<CR><CR>
map .s :Sexplore<CR><CR>

" NERDTree
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p
nmap <silent> <C-n> :NERDTreeToggle<CR>
let NERDTreeWinSize=40
let NERDTreeShowBookmarks=1

" errorMsg when <tab> is used inappropriate places
match errorMsg /[^\t]\zs\t\+/
match errorMsg /\s\+$/
" this will erase all trailing whitespaces automatically
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Mark when line is too long (after 80th character)
"match errorMsg /\%>80v.\+/

" Set cursor line
set cursorline
"highlight CursorLine guibg=LightBlue ctermbg=LightGrey

" Copy/Paste/Cut
vmap <C-c> y
imap <C-a> <ESC>p
vmap <C-x> x


" GITDiff
map <C-g>g :GITDiff<CR>
map <C-h> :diffoff<CR><C-w><C-q>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:FindFile(file)
    let curdir = getcwd()
    let found = curdir
    while !filereadable(a:file) && found != "/"
        cd ..
        let found = getcwd()
    endwhile
    execute "cd " . curdir
    return found
endfunction

if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    let $CSCOPE_DIR=s:FindFile("cscope.out")
    let $CSCOPE_DB=$CSCOPE_DIR."/cscope.out"

    if filereadable($CSCOPE_DB)
        cscope add $CSCOPE_DB $CSCOPE_DIR
    endif
    command -nargs=0 Cscope !cscope -ub -R &

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif


" Vim syntax file
" Language: git config file
" Maintainer:   Tim Pope <vimNOSPAM@tpope.org>
" Filenames:    gitconfig, .gitconfig, *.git/config
" Last Change:  2009 Dec 24

if exists("b:current_syntax")
    finish
endif

setlocal iskeyword+=-
setlocal iskeyword-=_
syn case ignore
syn sync minlines=10

syn match   gitconfigComment    "[#;].*"
syn match   gitconfigSection    "\%(^\s*\)\@<=\[[a-z0-9.-]\+\]"
syn match   gitconfigSection    '\%(^\s*\)\@<=\[[a-z0-9.-]\+ \+\"\%([^\\"]\|\\.\)*"\]'
syn match   gitconfigVariable    "\%(^\s*\)\@<=\a\k*\%(\s*\%([=#;]\|$\)\)\@=" nextgroup=gitconfigAssignment skipwhite
syn region  gitconfigAssignment  matchgroup=gitconfigNone start=+=\s*+ skip=+\\+ end=+\s*$+ contained contains=gitconfigBoolean,gitconfigNumber,gitConfigString,gitConfigEscape,gitConfigError,gitconfigComment keepend
syn keyword gitconfigBoolean true false yes no contained
syn match   gitconfigNumber  "\d\+" contained
syn region  gitconfigString  matchgroup=gitconfigDelim start=+"+ skip=+\\+ end=+"+ matchgroup=gitconfigError end=+[^\\"]\%#\@!$+ contained contains=gitconfigEscape,gitconfigEscapeError
syn match   gitconfigError  +\\.+    contained
syn match   gitconfigEscape +\\[\\"ntb]+ contained
syn match   gitconfigEscape +\\$+    contained

hi def link gitconfigComment        Comment
hi def link gitconfigSection        Keyword
hi def link gitconfigVariable       Identifier
hi def link gitconfigBoolean        Boolean
hi def link gitconfigNumber     Number
hi def link gitconfigString     String
hi def link gitconfigDelim      Delimiter
hi def link gitconfigEscape     Delimiter
hi def link gitconfigError      Error

let b:current_syntax = "gitconfig"

