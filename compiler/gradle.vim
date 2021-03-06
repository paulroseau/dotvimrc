" Vim Compiler File
" Compiler: gradle

if exists("current_compiler")
    finish
endif
let current_compiler = "gradle"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif


" this 'awesome' redirection is to swap stdin and stderr for the make output
set shellpipe=3>&1\ 1>&2\ 2>&3\ 3>&-\|\ tee

CompilerSet makeprg=gradle\ clean\ build\ \-x\ test\ 
CompilerSet errorformat=%f:%l:\ %m
