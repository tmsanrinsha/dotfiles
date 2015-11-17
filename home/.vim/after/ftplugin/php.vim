scriptencoding utf-8
" 7.4.52でこのファイルを読み込んだ後、$VIM/ftplugin.vimが読み込まれリセットさ
" れ、再度このファイルが読み込みれる現象が起きた。b_did_my_after_ftplugin_php
" のチェックを外して再度設定するようにする。
" if exists('b:did_my_after_ftplugin_php')
"   finish
" endif
" let b:did_my_after_ftplugin_php = 1
"
" let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
" \ . 'setlocal includeexpr< path<'

let php_sql_query = 1           " 文字列中のSQLをハイライトする
let php_htmlInStrings = 1       " 文字列中のHTMLをハイライトする
let php_noShortTags = 1         " ショートタグ (<?を無効にする→ハイライト除外にする)
let php_parent_error_close = 1  " for highlighting parent error ] or )
let php_parent_error_open = 0   " for skipping an php end tag,
                                " if there exists an open ( or [ without a closing one
" let php_folding = 0 " クラスと関数の折りたたみ(folding)を有効にする (重い)
" setlocal foldmethod=syntax
let PHP_vintage_case_default_indent = 1 " switch文でcaseをインデントする

" open_basedirの値をpathに追加
if !exists('g:php_open_basedir')
  let tmp = substitute(system("php -r 'echo ini_get(\"open_basedir\");'"), ':', '**,', 'g')
  let g:php_open_basedir = substitute(tmp, "\<NL>", '', '')
endif
let &l:path .= g:php_open_basedir

setlocal includeexpr=substitute(v:fname,'^/','','')

" 構文チェック
setlocal errorformat=%m\ in\ %f\ on\ line\ %l
setlocal makeprg=php\ -l\ %

let g:quickrun_config['php'] = deepcopy(g:quickrun#default_config['php'])
let g:quickrun_config['php']['hook/cd/directory'] = '%S:p:h'
let g:quickrun_config['phpv'] = {
\   'exec': 'php %s',
\   'hook/eval/enable': 1,
\   'hook/eval/template': '<?php %s'
\}

xnoremap <buffer> <Leader>r :QuickRun -type phpv -mode v<CR>

let g:quickrun_config['php.phpunit'] = {
\ 'hook/cd/directory'              : '%S:p:h',
\ 'command'                        : 'phpunit.sh',
\ 'cmdopt'                         : '',
\ 'exec'                           : '%c %o %s',
\ 'outputter/quickfix/errorformat' : '%f:%l',
\}

if neobundle#is_installed('phpcomplete-extended') &&
\   phpcomplete_extended#is_phpcomplete_extended_project()
  setlocal omnifunc=phpcomplete_extended#CompletePHP
else
  setlocal omnifunc=phpcomplete#CompletePHP
endif
