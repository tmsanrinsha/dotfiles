scriptencoding utf-8
if exists('b:did_my_after_ftplugin_apache')
    finish
endif
let b:did_my_after_ftplugin_apache = 1

" $VIMRUNTIME/ftplugin/xml.vim から必要そうな部分を抽出
if exists('loaded_matchit')
    let b:match_ignorecase=0
    let b:match_words =
     \  '<:>,' .
     \  '<\@<=?\k\+:?>,'.
     \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,'.
     \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'
endif

let &l:errorformat = '%A%.%#Syntax error on line %l of %f:,%Z%m'
