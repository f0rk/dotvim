set et ts=4 sw=4 sts=4                  " expand tabs to spaces, tabs are four spaces
set autoindent                          " reformat pastes and such
set smartindent                         " smart indent (eg tab over in a function)
set nocompatible                        " Use Vim defaults (much better!)
set showmatch                           " show balanced brace constructs
set bs=indent,eol,start                 " allow backspacing over everything in insert mode
set viminfo='10,\"50,:20,%,n~/.viminfo  " read/write a .viminfo file, don't store more than 50 lines of registers
set ruler                               " show the cursor position all the time
set hlsearch                            " highlight last search term
set incsearch                           " highlight search while typing
set scrolloff=10                        " 10 lines of top/bottom scroll context

set laststatus=2                        " make the status line visible
set statusline=%F%m%r%h%w\ [%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    +-- current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax 
"              | | | | |  |   +-- current file format
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag
"              | | | +-- help flag
"              | | +-- readonly flag
"              | +-- modified flag 
"              +-- full file path

set matchtime=2                         " how many tenths of a second to blink matching brackets for

" color
syntax enable
colorscheme desert

" enable support for specific filetypes
filetype plugin indent on

" When editing a file, always jump to the last cursor position
au BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif

" insert newline below/above without entering insert mode
map <F8> o<Esc>
map <F9> O<Esc>

" template files
autocmd BufNewFile *.pl 0r /usr/share/vim/vimfiles/template.pl
command LB 0r /usr/share/vim/vimfiles/lb-update-template.txt

" In text files, limit the width of text to 72 characters
au BufRead *.txt set tw=72

" replace trailing whitespace and tabs in cfg files
au BufRead *.cfg retab
au BufRead,BufWrite *.cfg :%s/\s\+$//e

" don't write swapfile on most commonly used directories for NFS mounts or USB sticks
au BufNewFile,BufReadPre /media/*,/mnt/* set directory=/tmp,/var/tmp,~/tmp

" write harder
command W w !sudo tee % > /dev/null

" fold by default (use indent because syntax isn't working)
au Syntax c,cpp,vim,xml,html,xhtml,perl,javascript set foldmethod=indent

" cscope for c/c++ projects
if has("cscope") && filereadable("/usr/bin/cscope")
    set csprg=/usr/bin/cscope
 
    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
 
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
 
    " surpress msg while we search
    set nocscopeverbose
    " add any database in current directory
    if filereadable("cscope.out")
       cs add cscope.out
    " else add database pointed to by environment
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
endif

if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif

