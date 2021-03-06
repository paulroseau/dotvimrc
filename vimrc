" Loads all plugins with pathogen and make documentation available
call pathogen#infect()
call pathogen#helptags() " this is done manually by running :helptags ~/.vim/<plugin-name>/doc

" GENERAL SETTINGS

" Automatic coloring
if version >= 600
    syntax enable " This command executes :source $VIMRUNTIME/syntax/syntax.vim. With this command you can use the :highlight command to set your preferred colors.
else	
    syntax on " With this command Vim will overrule your settings.
endif

" Gives the <EOL> of the current buffer, which is used for reading/writing the buffer from/to a file (unix <NL>)
set fileformat=unix
" Hides buffer automatically when switching to another buffer
set hidden 

" Shows line numbers
set number

" Colors suitable for dark background
set background=dark

" Sets filetype detection on (this uses file extension)
if has("autocmd")
    " the if has("autocmd") is there to ensure portability since the following option doesn't work if vim hasn't been compiled with the autocmd flag. You can check if it is the case with the command :version
    filetype plugin indent on
end

" Avoids 'Hit return to continue' message
set shortmess=atT

" Prevents long line to go off screen (use gq to force wrapping)
set wrap

" Sets limit of lines width (0 if no limit)
set textwidth=80

" Prevents vim to cut a word in the middle of a word 
set linebreak " doesn't work if the list option is on! set nolist

" Searching parameters
set incsearch
set hlsearch
set ignorecase
set smartcase " ignores case if no pattern with uppercase found, takes it into account otherwise
set nowrapscan " doesn't get back to first match when the last match is found

" Shows matching parenthesis
set showmatch

" Indentation
set autoindent
set smartindent

" Sources the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Sets foldcolumn to see foldlevels
set foldcolumn=3

" Tabs and spaces
set expandtab " converts tab in a number of spaces
set tabstop=2 " sets tab character to correspond to x columns. When there is an offset of x columns it is automatically converted to a tab character. If the expandtab option is set then the tab character will in turn be converted to x spaces.
set softtabstop=2 " sets the number of columns offset when PRESSING the tab key or the backspace key. It doesn't necessarily inserts or remove a tab character, just the proper number of columns.
set shiftwidth=2 " sets the number of columns offset when in normal mode using the shift keys '>' and '<'

" Number of screen lines to use for the command-line. Helps avoiding hit-enter prompts.
set cmdheight=2

" Sets the default foldmethod to indent
if (v:version >= 600)
  set foldmethod=indent
  set foldlevel=0
endif
 
" Sets omni completion
" set omnifunc=syntaxcomplete#Complete " completes keywords defined in filetype
" set completeopt=menu " uses a popup menu to show the possible completions

" From vimcast#45 populates the arglist with the quickfixlist buffers
" (useful for project wide renaming)
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
" PLUGINS SETTINGS

" Fugitive
" From vimcast #34
autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Latex
" This Latex plugin defines mapping for <C-J> for IMAP_JumpForward which is very
" annoying.  The script includes a check hasmapto before defining those mapping
" so we will define some mapping here (made them complicated on purpose)
map <C-space>\, <Plug>IMAP_JumpForward 
imap <C-space>\, <Plug>IMAP_JumpForward

" Other approach : go to the place where those mappings are defined in script (use
" :map to get a list of the mappings, vimgrep /<mapping>/ bundle/Latex/**) 
" and add map <unique> ... this lets vim
" perfrom an additional check that this mapping has not already been defined
" before and throws an error otherwise.
" Anyway I believe the first approach is cleaner.
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<C-B>"
let g:UltiSnipsJumpBackwardTrigger="<C-Z>"
let g:UltiSnipsEditSplit="vertical"

" CtrlP
let g:ctrlp_user_command=
    \ 'find %s -type f | grep -i "\.\(java\|scala\|c\|cpp\|hs\|js\|css\|html\)$"'
" explanation: by default CrtlP uses vim builtin tool to list all files in a directory
" (globpath) but you can change that, for example : cat cscope, etc. Here I want
" to exclude some files (xml and stuff, by this should definitely specific to
" each project, need to find a cleaner way

" Syntastic
let g:syntastic_check_on_open = 1

" GENERAL MAPPINGS
" Reminder : noremap avoids recursive resolution of mapping, always use noremap!

let mapleader = ","

" little hack to make the Alt key work on vim for some keys
set <A-L>=l 
set <A-K>=k
set <A-J>=j
set <A-H>=h
" explanation : when pressing Alt+L for example, the terminal reads this signal
" as Esc+l, so setting <A-L> to ^[l lets us refer in the rest of the script to
" ^[l using <A-L>

" The time in milliseconds that is waited for a key code or mapped key sequence to complete
set timeoutlen=700 " milliseconds

" <Esc> is too far away for my little pinkie!
noremap <leader><leader> <Esc>
inoremap <leader><leader> <Esc>
cnoremap <leader><leader> <Esc>

" Lets you navigate inside a wrapped line using normal command instead of just
" mapping direclty allows you to prepend a count to the whole command
noremap <Up> :normal gk<CR>
noremap <Down> :normal gj<CR>

" Shortcut to edit .vimrc
nnoremap <leader>v :tabedit $MYVIMRC<CR>

" Switches between buffers
noremap <C-L> :bn<CR>
noremap <C-H> :bp<CR>

" Unlists the current buffer and switch to the next/previous one (reminder if
" you want to really delete the buffer, you need to use :bwipeout)
command! BDN :bn | :bd#
command! BDP :bp | :bd#
noremap <A-L> :BDN<CR>
noremap <A-H> :BDP<CR>

" Displays the list of multiple match for a tag by default. (Initially <C-]> is
" mapped to :tag <current_word> which jumps to the first match, whereas g<C-]>
" is mapped to :tjump <current_word> which displays the list if multiple matches
" exist.
noremap <C-]> g<C-]>

" Switches from one match for a tag to another
noremap <C-Up> :tprevious<CR>
noremap <C-Down> :tnext<CR>


" Switches from one match in the quickfixlist to another
noremap <silent> <S-L> :cprevious<CR>
noremap <silent> <S-H> :cnext<CR>

" Bubbles single lines
nnoremap <C-K> ddkP
nnoremap <C-J> ddp

" Bubbles multiple lines (`[ is the default mark for the last selection start
" point, `] for last selection end point)
vnoremap <C-K> xkP`[V`] 
vnoremap <C-J> xp`[V`]

" Removes search highlighting
nnoremap <leader>h :nohlsearch<CR>

" Shortcut for folding
nnoremap <Space> za

" Stays here for teaching purposes - use NERDComment instead
" " Commenting / Uncommenting
" noremap <leader>c :call Comment()<CR>
" noremap <leader>cc :call Uncomment()<CR>
" 
" " Comments range (handles multiple file types)
" function! Comment() range
"   " Typically (at least this is the case for Scala and Java) the commentstring is set to //%s, so we remove the last 2
"   " characters
"   let roughCommentString = &commentstring
"   let commentStringLen = strlen(roughCommentString)
"   let commentString = strpart(roughCommentString, 0, commentStringLen - 2)
"   execute ":" . a:firstline . "," . a:lastline . 's,^,' . commentString . ' ,'
" endfunction
" 
" " Uncomments range (handles multiple file types)
" function! Uncomment() range
"   " Typically (at least this is the case for Scala and Java) the commentstring is set to //%s, so we remove the last 2
"   " characters
"   let roughCommentString = &commentstring
"   let commentStringLen = strlen(roughCommentString)
"   let commentString = strpart(roughCommentString, 0, commentStringLen - 2)
"     execute ":" . a:firstline . "," . a:lastline . 's,^' . commentString . ',,'
" endfunction

" Greps the current word in the arglist (detailed explanation on this command at
" http://learnvimscriptthehardway.stevelosh.com/chapters/32.html
nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cword>")) . " ##"<CR>:copen<CR>:redraw!<CR>

" Redraws the screen
nnoremap <leader>d :redraw!<CR>

" PLUGINS MAPPINGS

" --- NERDTree ---

" Shortcuts to show NerdTreeToggle
noremap <leader>t :NERDTreeToggle<CR>

" Targets the current opened buffer in NERDTree
noremap <leader>f :NERDTreeFind <CR>

" --- Gundo ---

" Shortcuts to show GundoToggle
noremap <leader>u :GundoToggle<CR>

" --- Tagbar ---

" Shortcuts to show TagbarToggle
nnoremap <silent> <leader>b :TagbarToggle<CR>

 " ARJUN'S STUFF ---------------------------------------------- BEGIN

 " ------------------------------------------------------- Programming
 " for correct ctags and cscope handling (alternative is required
 " in case there is already a file/directory names tags or ctags
 " additional names could be added if both names exits
 let $WDIR=getcwd() "get the working directory
 if has("unix")
 set tags=$WDIR/tags
 endif
 "setup scope info only is available
 if has("cscope")
 let cscope=filereadable("$WDIR/cscope.out")
 if exists("cscope")
 set csprg=/usr/local/bin/cscope "direct path
 set csto=1 "seach scope before ctags
 set cst
 set nocsverb
 cs add $WDIR/cscope.out
 set csverb
 endif
 endif

  " ARJUN'S STUFF ---------------------------------------------- END

" From Vimcasts.org 

" #1 Show invisibles

map <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬
" ▸ = u25b8, ¬ = u00ac (insert unicode symbol with crtl-V in insert mode) 
" ctrl-V ctrl-I inserts tab character


" #3 Whitespace preferences and filetype

" autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
" The first part of this command means to execute automatically the end of the command if the filetype of the file is make. Setlocal is like the set command but affects only the current buffer.i
" You need vim to be compiled with the autocmd option on. To check that run :version and check there is a '+' sign in front of autocmd.
" You can inquire about the filetype of a buffer with :set filetype?, and you can set it with set filetype myFileType.

" #4 Tidying whitespaces

" To convert spaces in tab and conversely use :retab!
