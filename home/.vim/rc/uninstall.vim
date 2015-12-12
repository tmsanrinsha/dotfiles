let $HOME.'/.vim' = expand('~/.vim')
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

call neobundle#end()

filetype plugin indent on     " Required!
