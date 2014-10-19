if exists('b:did_my_after_ftplugin_apache')
    finish
endif
let b:did_my_after_ftplugin_apache = 1

" $VIMRUNTIME/ftplugin/xml.vim から必要そうな部分を抽出
if exists("loaded_matchit")
    let b:match_ignorecase=0
    let b:match_words =
     \  '<:>,' .
     \  '<\@<=?\k\+:?>,'.
     \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,'.
     \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'
endif

setlocal makeprg=apachectl\ configtest
let &l:errorformat = '%A%.%#Syntax error on line %l of %f:,%Z%m,%-G%.%#'
augroup my_after_ftplugin_apache
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> make
augroup END
