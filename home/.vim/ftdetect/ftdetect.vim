scriptencoding utf-8

autocmd BufRead,BufNewFile *Test.php setlocal ft=php.phpunit
autocmd BufRead            sanrinsha*,qiita* setlocal filetype=markdown
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile *.tsv setlocal filetype=tsv
autocmd BufRead,BufNewFile *.csv setlocal filetype=csv

" MySQLのEditorの設定
" http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
autocmd BufRead            /var/tmp/sql* setlocal filetype=sql

autocmd BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache

" *.htmlのファイルの1行目に<?phpがあるときにfiletypeをphpにする
autocmd BufRead,BufNewFile *.html
\   if getline(1) =~ '<?php'
\|      setlocal filetype=php
\|  endif
