let $VIMDIR = expand('~/.vim')
if has('vim_starting')
    set runtimepath+=$VIMDIR/bundle/neobundle.vim/
endif
call neobundle#begin(expand($VIMDIR.'/bundle/'))

call neobundle#end()

filetype plugin indent on     " Required!
