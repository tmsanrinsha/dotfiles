scriptencoding utf-8

augroup MyVimrc
    " chef
    autocmd BufRead,BufNewFile */recipes/*.rb setlocal filetype=ruby.chef
augroup END
