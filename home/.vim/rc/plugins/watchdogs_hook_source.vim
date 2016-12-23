scriptencoding utf-8

" let g:watchdogs_check_CursorHold_enable = 1
let g:watchdogs_check_BufWritePost_enable = 1

if !exists('g:quickrun_config')
    let g:quickrun_config = {}
endif

let g:quickrun_config['watchdogs_checker/_'] = {}

" quickrunの出力結果が空の時にquickrunのバッファを閉じる設定。
" watchdogsの場合は出力が無いので、これを1にしておくと
" quickrunでなんらかのプログラムを実行したあと保存をすると
" その出力結果が消えてしまうので、0にする
let g:quickrun_config['watchdogs_checker/_']['hook/close_buffer/enable_empty_data'] = 0

let g:quickrun_config['watchdogs_checker/_']['outputter/quickfix/open_cmd'] = 'botright cwindow'
" quickfixを開きたくない場合はopen_cmdを''にする
" let g:quickrun_config['watchdogs_checker/_']['outputter/quickfix/open_cmd'] = ''

" 出力先をbufixlistににする。hook/close_bufixlistにあたるものがない
" let g:quickrun_config['watchdogs_checker/_']['outputter'] = 'bufixlist'
" let g:quickrun_config['watchdogs_checker/_']['outputter/bufixlist/open_cmd'] = 'botright Bopen'

" fugitiveのdiffなどの表示画面ではcheckしない
autocmd MyVimrc BufRead fugitive://*
\   let b:watchdogs_checker_type = ''

" apaache {{{1
" ============================================================================
let g:quickrun_config['watchdogs_checker/apache'] = {
\   'command':           'apachectl',
\   'cmdopt':            'configtest',
\   'exec':              '%c %o',
\   'errorformat':       '%A%.%#Syntax error on line %l of %f:,%Z%m,%-G%.%#',
\}

let g:quickrun_config['apache/watchdogs_checker'] = {
\   'type' : 'watchdogs_checker/apache'
\}

" cpp {{{1
" ============================================================================
let g:quickrun_config['cpp/watchdogs_checker'] = {
\   'type'
\       : executable('g++')         ? 'watchdogs_checker/g++'
\       : executable('clang-check') ? 'watchdogs_checker/clang_check'
\       : executable('clang++')     ? 'watchdogs_checker/clang++'
\       : executable('cl')          ? 'watchdogs_checker/cl'
\       : '',
\}

let g:quickrun_config['watchdogs_checker/g++'] = {
\   'command'   : 'g++',
\   'exec'      : '%c %o -std=gnu++0x -fsyntax-only %s:p ',
\   'outputter' : 'quickfix',
\}

" Go lang {{{1
" ------------
" vim-goでやるので、typeの設定を外しておく
let g:quickrun_config['go/watchdogs_checker'] = {
\   'type': ''
\}

" let g:quickrun_config['go/watchdogs_checker'] = {
" \   'type'
" \       : executable('gometalinter') ? 'watchdogs_checker/gometalinter'
" \       : ''
" \}
"
let g:quickrun_config['watchdogs_checker/gometalinter'] = {
\   'command' : 'gometalinter',
\   'exec'    : '%c --disable-all --enable=vet --enable=golint --enable=errcheck %s:p:h',
\   'errorformat' : '%f:%l:%c:%t%*[^:]: %m,%-G%.%#',
\}

" mql {{{1
" ============================================================================
let g:quickrun_config['watchdogs_checker/mql'] = {
\   'hook/cd/directory': '%S:p:h',
\   'command':           'wine',
\   'cmdopt':            '~/Dropbox/src/localhost/me/MetaTrader/mql.exe /i:Z:'.$HOME.'/PlayOnMac''''''''s\ virtual\ drives/OANDA_MT4_/drive_c/Program\ Files/OANDA\ -\ MetaTrader/MQL4',
\   'exec':              '%c %o %S:t',
\   'errorformat':       '%f(%l\,%c) : %m',
\}
" hook/cd/directoryでファイルのあるディレクトリに移動して、execでファイル名を指定して実行。
" ディレクトリを移動しない場合、wine側で認識させるためにz:をファイルパスにつけル必要があり、つけた結果エラー結果にz:がついてしまい、Vimで開くことができなくなる
" cmdoptでmql.exeをwineに渡す。#includeを読み込むためにはProgram FilesのMetaTraderディレクトリにmql.exeを置いておくか、/i:オプションでworking directoryを指定する
" MetaTraderディレクトリにmql.exeを置いておくと、MetaTraderの再起動時にファイルが消えてしまうので後者の方法を取る
" シングルクォートが非常に多いが
" シングルクォートの中でシングルクォートを表すには''、
" さらにvimprocでシングルクォートを表すために''''、
" さらにwineの引数でシングルクォートを表すために''''''''
" となっている

let g:quickrun_config['mql4/watchdogs_checker'] = {
\   'type' : 'watchdogs_checker/mql'
\}

" php {{{1
" ============================================================================
" if executable('phpcs')
"     let g:quickrun_config['watchdogs_checker/php'] = {
"     \   'exec' : ['php -l %s:p', 'phpcs --standard=PSR2 --report=csv %s:p'],
"     \   'errorformat' :
"     \       '%m\ in\ %f\ on\ line\ %l,'.
"     \       '%-GNo syntax errors detected in %.%#,'.
"     \       '%-GErrors parsing %.%#,'.
"     \       '%-G,'.
"     \       '"%f"\,%l\,%c\,%t%*[^\,]\,"%m"\,%.%#,'.
"     \       '%-GFile\,Line\,Column\,Type\,Message\,Source\,Severity\,Fixable'
"     \}
" else
    let g:quickrun_config['watchdogs_checker/php'] = {
    \   'command' : 'php',
    \   'exec'    : '%c %o -l %s:p',
    \   'errorformat' : '%m\ in\ %f\ on\ line\ %l,%Z%m,%-G%.%#',
    \}
" endif


let g:quickrun_config['php.phpunit/watchdogs_checker'] = {
\   'type': 'watchdogs_checker/php'
\}

" R-lang {{{1
" --------------------------------------------------------------------
" Rmd {{{3
let g:quickrun_config['rmd/watchdogs_checker'] = {
\   'type': 'watchdogs_checker/rmd'
\}

let g:quickrun_config['watchdogs_checker/rmd'] = {
\   'hook/cd/directory': '%S:p:h',
\   'command': 'Rscript',
\   'cmdopt': '-e',
\   'exec': ['%c %o "library(rmarkdown);rmarkdown::render(''%s:p'')"', 'sleep 1', 'touch %s:p:r.html'],
\}

" sh {{{1
" --------------------------------------------------------------------
" filetypeがshでも基本的にbashを使うので、bashでチェックする
let g:quickrun_config['sh/watchdogs_checker'] = {
\   'type': (executable('bash') ? 'watchdogs_checker/bash' : '')
\}

let g:quickrun_config['watchdogs_checker/bash'] = {
\   'command':     'bash',
\   'exec':        '%c -n %o %s:p',
\   'errorformat': '%f:\ line\ %l:%m',
\}

" solidity {{{1
" --------------------------------------------------------------------
let g:quickrun_config['solidity/watchdogs_checker'] = {
\   'type': (executable('solc') ? 'watchdogs_checker/solc' : '')
\}

let g:quickrun_config['watchdogs_checker/solc'] = {
\   'command':     'solc',
\   'exec':        '%c %s:p',
\   'errorformat': '%f:%l:%c: %m,%-G%.%#',
\}

" sql {{{1
" ============================================================================
" let g:quickrun_config['sql/watchdogs_checker'] = {
" \   'type': 'watchdogs_checker/sql'
" \}
"
" " https://sql.treasuredata.com/
" let g:quickrun_config['watchdogs_checker/sql'] = {
" \   'command':     'curl',
" \   'exec':        '%c -s "https://td-sql.herokuapp.com/api/v1/query/validate?callback=angular.callbacks._1\&engine=hive\&query=`cat %s | perl -pe ''s/\n/%%0A/''`"',
" \   'errorformat': '%f:\ line\ %l:%m',
" \}
\}

" vim {{{1
" ============================================================================
let g:quickrun_config['vim/watchdogs_checker'] = {
\   'type': executable('vint') ? 'watchdogs_checker/vint' : '',
\}

let g:quickrun_config['watchdogs_checker/vint'] = {
\       'command'   : 'vint',
\       'exec'      : '%c %o %s:p',
\}

" zsh {{{1
" ============================================================================
" let g:quickrun_config['zsh/watchdogs_checker'] = {
" \   'type': ''
" \}

call SourceRc('watchdogs_local.vim')

" watchdogs.vim の設定を更新（初回は呼ばれるが、リロード時のために書いておく）
call watchdogs#setup(g:quickrun_config)
