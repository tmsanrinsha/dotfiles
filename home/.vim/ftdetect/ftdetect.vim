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

  " :terminal {{{1
  " ========================================================================
  if has('terminal')
    if exists("##TerminalOpen")
      autocmd TerminalOpen * runtime! ftplugin/terminal.vim
    else
      " BufNew の時点では 'buftype' が設定されていないので timer を使う
      autocmd BufNew * call timer_start(10, { -> s:detect_terminal() })

      function! s:detect_terminal()
        if &buftype == "terminal"
          " filetypeを設定するとautocmdのSyntaxが発火し、
          " neosnippetのsyntax match neosnippetExpandSnippetsが設定され
          " Terminal-Normal modeで色がなくなるので、設定を読み込むだけにする
          runtime! ftplugin/terminal.vim
        endif
      endfunction
      " - Vim で :terminal の使い勝手をよくした - Secret Garden(Instrumental)
      "   http://secret-garden.hatenablog.com/entry/2017/11/14/113127
    endif
  endif
augroup END
