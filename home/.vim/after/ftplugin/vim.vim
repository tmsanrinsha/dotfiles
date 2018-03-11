scriptencoding utf-8

setlocal textwidth<
setlocal formatoptions<

" カーソル下のキーワードを:helpで開く (:help K)
setlocal keywordprg=:help

setlocal comments=:\"

" g:, s:などをtagで引けるように:を追加
" :helpで引けるように-を追加
setlocal iskeyword+=:,-

" pythonのTracebackも対象にする
setlocal errorformat+=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%m
