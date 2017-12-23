scriptencoding utf-8

augroup MyVimrc
  " JSON {{{1
  " ========================================================================
  autocmd BufRead,BufNewFile .tern-project setlocal filetype=json
  " PHP {{{1
  " ========================================================================
  " *.html,*.confのファイルの1行目に<?phpがあるときにfiletypeをphpにする
  autocmd BufRead,BufNewFile *.html,*.conf
  \   if getline(1) =~ '<?php'
  \|      setlocal filetype=php
  \|  endif
  autocmd BufRead,BufNewFile *Test.php setlocal filetype=php.phpunit
  autocmd BufRead,BufNewFile composer.json setlocal filetype=composer.json

  " Markdown {{{1
  " ========================================================================
  autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
  " It's All text用
  autocmd BufRead            */itsalltext/*.txt setlocal filetype=markdown
  " autocmd BufRead,BufNewFile *.Rmd setlocal filetype=markdown.rmd
  " }}}

  autocmd BufRead,BufNewFile *.csv setlocal filetype=csv
  autocmd BufRead,BufNewFile *.tsv setlocal filetype=tsv
  autocmd BufRead,BufNewFile *cvimrc,*.cvim setlocal filetype=cvim
  autocmd BufRead,BufNewFile *.tags setlocal filetype=tags


  " MySQLのEditorの設定
  " http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
  autocmd BufRead            /var/tmp/sql* setlocal filetype=sql

  autocmd BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache
augroup END
