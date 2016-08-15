scriptencoding utf-8

augroup MyVimrc
    " PHP
    autocmd BufRead,BufNewFile *Test.php setlocal filetype=php.phpunit
    autocmd BufRead,BufNewFile composer.json setlocal filetype=composer.json

    autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
    " autocmd BufRead,BufNewFile *.Rmd setlocal filetype=markdown.rmd
    autocmd BufRead,BufNewFile *.csv setlocal filetype=csv
    autocmd BufRead,BufNewFile *.tsv setlocal filetype=tsv

    autocmd BufRead            sanrinsha*,qiita.com_drafts_* setlocal filetype=markdown

    " MySQLのEditorの設定
    " http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
    autocmd BufRead            /var/tmp/sql* setlocal filetype=sql

    autocmd BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache

    " *.htmlのファイルの1行目に<?phpがあるときにfiletypeをphpにする
    autocmd BufRead,BufNewFile *.html
    \   if getline(1) =~ '<?php'
    \|      setlocal filetype=php
    \|  endif
augroup END
