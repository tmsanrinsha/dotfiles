scriptencoding utf-8

" let g:quickrun_no_default_key_mappings = 1
" map <Leader>r <Plug>(quickrun)

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-C> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-C>"

if !exists('g:quickrun_config')
    let g:quickrun_config = {}
endif

" 共通の設定
" [shabadou.vim を使って quickrun.vim をカスタマイズしよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20120919/1348054752)
" let g:quickrun_config['_'] = {
" \ 'runner':                                    'vimproc',
" \ 'runner/vimproc/updatetime':                 100,
let g:quickrun_config['_'] = {
\ 'runner':                                    'terminal',
\ 'runner/terminal/opener':                    'botright split',
\ 'outputter':                                 'multi:buffer:quickfix',
\ 'outputter/buffer/split':                    'botright 8split',
\ 'outputter/quickfix/open_cmd':               'botright cwindow',
\ 'hook/cd/directory':                         '%S:p:h',
\ 'hook/close_quickfix/enable_hook_loaded':    1,
\ 'hook/close_quickfix/enable_success':        1,
\ 'hook/close_buffer/enable_empty_data':       1,
\ 'hook/close_buffer/enable_failure':          1,
\ 'hook/hier_update/enable_exit':              1,
\ 'hook/hier_update/priority_exit':            2,
\ 'hook/qfsigns_update/enable_exit':           1,
\ 'hook/qfsigns_update/priority_exit':         2,
\}

" 現在の行がquickfixに含まれるなら、その内容を画面下にメッセージとして表示する
let g:quickrun_config['_']['hook/quickfix_status_enable/enable_exit'] = 1
let g:quickrun_config['_']['hook/quickfix_status_enable/priority_exit'] = 2

let g:quickrun_config['_']['hook/qfstatusline_update/enable_exit'] = 1
let g:quickrun_config['_']['hook/qfstatusline_update/priority_exit'] = 2

let g:quickrun_config['_']['hook/unya/enable'] = 1
let g:quickrun_config['_']['hook/echo/enable'] = 1
let g:quickrun_config['_']['hook/echo/output_success'] = 'Let''s＼(・ω・)／にゃー！'
let g:quickrun_config['_']['hook/echo/output_failure'] = '＼(・ω・＼)SAN値!(/・ω・)/ピンチ!'

" cwindowは認識されたエラーがるときにQuickFixウィンドを開く
" hook/cd/diretoryで%sを使うとパスがダブルクォートで囲まれてうまくいかない

" （」・ω・）」quick！（／・ω・）／run！ - C++でゲームプログラミング
" http://d.hatena.ne.jp/osyo-manga/20120508/1336437386
call quickrun#module#register(shabadou#make_quickrun_hook_anim(
\   'unya',
\   ['（」・ω・）」うー！', '(／・ω・)／にゃー！'],
\   4,
\), 1)

" make {{{1
" ============================================================================
let g:quickrun_config['make'] = {
\ 'command': 'make',
\ 'hook/cd/directory': '%S:p:h',
\ 'exec': '%c %o',
\}

" PHP {{{1
" ============================================================================
let g:quickrun_config['php'] = deepcopy(g:quickrun#default_config['php'])
let g:quickrun_config['php']['hook/cd/directory'] = '%S:p:h'
let g:quickrun_config['phpv'] = {
\   'exec': 'php %s',
\   'hook/eval/enable': 1,
\   'hook/eval/template': '<?php %s'
\}

let g:quickrun_config['php.phpunit'] = {
\ 'hook/cd/directory'              : '%S:p:h',
\ 'command'                        : 'phpunit.sh',
\ 'cmdopt'                         : '',
\ 'exec'                           : '%c -v --debug --colors %o %s',
\ 'outputter/quickfix/errorformat' : '%f:%l,%m in %f on line %l',
\}

let g:quickrun_config['sudo_phpunit'] = deepcopy(g:quickrun_config['php.phpunit'])
let g:quickrun_config['sudo_phpunit']['exec'] = 'echo %{GetPassword()} | sudo -S '.g:quickrun_config['sudo_phpunit']['exec']

let g:quickrun_config['php-cs-fixer'] = {
\   'hook/cd/directory'              : '%S:p:h',
\   'outputter'                     : 'buffer',
\   'hook/close_buffer/enable_failure':          0,
\   'command'                        : 'php-cs-fixer.sh',
\   'cmdopt'                         : '',
\   'exec'                           : '%c --diff %o %a',
\}
" composer.json {{{3
let g:quickrun_config['composer.json'] = {
\ 'hook/cd/directory' : '%S:p:h',
\ 'command'           : 'composer',
\ 'cmdopt'            : '',
\ 'exec'              : '%c %a',
\}

autocmd MyVimrc BufRead,BufNewFile composer.json
\   setlocal filetype=composer.json
\ | nnoremap <buffer> <Leader>ri :<C-u>QuickRun -args install<CR>
\ | nnoremap <buffer> <Leader>ru :<C-u>QuickRun -args update<CR>

" Python {{{1
" ============================================================================
let g:quickrun_config['python'] = {}
let g:quickrun_config['python']['command'] = 'python3'
" Ruby {{{1
" ============================================================================
let g:quickrun_config['ruby.chef'] = deepcopy(g:quickrun#default_config['ruby'])
let g:quickrun_config['ruby.chef']['command'] = 'ruby'

" R lang {{{1
" ============================================================================
let g:quickrun_config['rmd'] = {
\ 'command'                        : 'Rscript',
\ 'cmdopt'                         : '-e',
\ 'exec'                           : ['%c %o "library(rmarkdown);rmarkdown::render(''%s:p'')"'],
\ 'outputter'                      : 'quickfix',
\}

" dot, graphviz {{{1
" ============================================================================
let g:quickrun_config['dot'] = {
\ 'hook/cd/directory'              : '%S:p:h',
\ 'command'                        : 'dot',
\ 'cmdopt'                         : '',
\ 'exec'                           : ['%c -Tpng %s -o %s:r.png', 'open -a Firefox %s:r.png'],
\ 'outputter/quickfix/errorformat' : 'Error: %f: %m in line %l %.%#,%EError: %m,%C%m,%Z%m'
\}

" バッファに出力する {{{1
" ============================================================================
" [QuickRunでVimのメッセージの出力をキャプチャするコマンドを定義する - Qiita](https://qiita.com/sgur/items/9e243f13caa4ff294fa8)
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

" 選択範囲を実行して、出力で置き換え {{{1
" [quickrun-outputter-replace_region つくった - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20130224/1361703750)
command! -nargs=* -range=0 -complete=customlist,quickrun#complete
\   QuickRunReplace
\   QuickRun
\       -mode v
\       -outputter error
\       -outputter/success replace_region
\       -outputter/error message
\       -outputter/message/log 1
\       <args>
" }}}

call SourceRc('quickrun_local.vim')
