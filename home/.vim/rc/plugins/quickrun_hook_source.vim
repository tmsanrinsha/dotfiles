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
let g:quickrun_config['_'] = {
\ 'runner':                                    'vimproc',
\ 'runner/vimproc/updatetime':                 50,
\ 'outputter':                                 'multi:buffer:quickfix',
\ 'outputter/buffer/split':                    'botright 8sp',
\ 'hook/cd/directory':                         '%S:p:h',
\ 'hook/close_quickfix/enable_hook_loaded':    1,
\ 'hook/close_quickfix/enable_success':        1,
\ 'hook/close_buffer/enable_empty_data':       1,
\ 'hook/close_buffer/enable_failure':          1,
\ 'hook/hier_update/enable_exit':              1,
\ 'hook/hier_update/priority_exit':            2,
\ 'hook/qfsigns_update/enable_exit':           1,
\ 'hook/qfsigns_update/priority_exit':         2,
\ 'hook/quickfix_status_enable/enable_exit':   1,
\ 'hook/quickfix_status_enable/priority_exit': 2,
\ 'hook/unya/enable': 1,
\ 'hook/echo/enable': 1,
\ 'hook/echo/output_success': 'Let''s＼(・ω・)／にゃー！',
\ 'hook/echo/output_failure': '＼(・ω・＼)SAN値!(/・ω・)/ピンチ!',
\}

" \ 'hook/qfstatusline_update/enable_exit':      1,
" \ 'hook/qfstatusline_update/priority_exit':    2,

" hook/cd/diretoryで%sを使うとパスがダブルクォートで囲まれてうまくいかない

" （」・ω・）」quick！（／・ω・）／run！ - C++でゲームプログラミング
" http://d.hatena.ne.jp/osyo-manga/20120508/1336437386
call quickrun#module#register(shabadou#make_quickrun_hook_anim(
\   'unya',
\   ['（」・ω・）」うー！', '(／・ω・)／にゃー！'],
\   4,
\), 1)

" PHP {{{2
" --------------------------------------------------------------------
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

" ruby {{{2
" --------------------------------------------------------------------
let g:quickrun_config['ruby.chef'] = deepcopy(g:quickrun#default_config['ruby'])
let g:quickrun_config['ruby.chef']['command'] = 'ruby'

" R lang {{{2
" --------------------------------------------------------------------
let g:quickrun_config['rmd'] = {
\ 'command'                        : 'Rscript',
\ 'cmdopt'                         : '-e',
\ 'exec'                           : ['%c %o "library(rmarkdown);rmarkdown::render(''%s:p'')"'],
\ 'outputter'                      : 'quickfix',
\}

" dot, graphviz {{{2
" --------------------------------------------------------------------
let g:quickrun_config['dot'] = {
\ 'hook/cd/directory'              : '%S:p:h',
\ 'command'                        : 'dot',
\ 'cmdopt'                         : '',
\ 'exec'                           : ['%c -Tpng %s -o %s:r.png', 'open -a Firefox %s:r.png'],
\ 'outputter/quickfix/errorformat' : 'Error: %f: %m in line %l %.%#,%EError: %m,%C%m,%Z%m'
\}

" Android Dev {{{2
" --------------------------------------------------------------------
" function! s:QuickRunAndroidProject()
"     let l:project_dir = unite#util#path2project_directory(expand('%'))
"
"     for l:line in readfile(l:project_dir.'/AndroidManifest.xml')
"         " package名の取得
"         " ex) com.sample.helloworld
"         if !empty(matchstr(l:line, 'package="\zs.*\ze"'))
"             let l:package = matchstr(l:line, 'package="\zs.*\ze"')
"             continue
"         endif
"
"         " android:nameの取得
"         " ex) com.sample.helloworld.HelloWorldActivity
"         if !empty(matchstr(l:line, 'android:name="\zs.*\ze"'))
"             let l:android_name = matchstr(l:line, 'android:name="\zs.*\ze"')
"             break
"         endif
"     endfor
"
"     if empty(l:package)
"         echo 'package名が見つかりません'
"         return -1
"     elseif empty(l:android_name)
"         echo 'android:nameが見つかりません'
"         return -1
"     endif
"
"     let l:apk_file = l:project_dir.'/bin/'.matchstr(l:android_name, '[^.]\+$').'-debug.apk'
"     " ex) com.sample.helloworld/.HelloWorldActivity
"     let l:component = substitute(l:android_name, '\zs\.\ze[^.]*$', '/.', '')
"
"     let g:quickrun_config['androidProject'] = {
"     \   'hook/cd/directory'           : l:project_dir,
"     \   'hook/output_encode/encoding' : 'sjis',
"     \   'exec'                        : [
"     \       'android update project --path .',
"     \       'ant debug',
"     \       'adb -d install -r '.l:apk_file,
"     \       'adb shell am start -a android.intent.action.MAIN -n '.l:package.'/'.l:android_name
"     \   ]
"     \}
"
"     QuickRun androidProject
" endfunction
"
" command! QuickRunAndroidProject call s:QuickRunAndroidProject()
" autocmd MyVimrc BufRead,BufNewFile */workspace/* nnoremap <buffer> <Leader>r :QuickRunAndroidProject<CR>

" Node.js {{{2
" --------------------------------------------------------------------
" let g:quickrun_config['node'] = {
"             \   'runner/vimproc/updatetime' : 1000,
"             \   'command'                : 'tail',
"             \   'cmdopt'                 : '',
"             \   'exec'                   : '%c %o ~/git/jidaraku_schedular/log',
"             \   'outputter/multi'   : [ 'buffer', 'quickfix' , 'message'],
"             \}
" "
" set errorformat=debug:\%s
call SourceRc('quickrun_local.vim')
