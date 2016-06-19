scriptencoding utf-8

call unite#custom#profile('default', 'context', {
\   'start_insert': 1,
\   'direction': 'topleft',
\   'winheight': 10,
\   'auto_resize': 1,
\   'prompt': '> ',
\ })

" verbose mapするアクションの定義
" [unite.vim の action について理解する - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20131004/1380890539)
let s:action_verbose_map = {
\   'description' : 'verbose',
\   'is_selectable' : 1,
\}

function! s:action_verbose_map.func(candidates)
    for candidate in a:candidates
        let l:mapmode = matchstr(candidate.unite__abbr, '^\S\+') . 'map'
        let l:lhs = matchstr(candidate.unite__abbr, '^\S\+\s\+\zs\S\+\ze')
        execute 'verbose ' l:mapmode l:lhs
    endfor
endfunction

call unite#custom#action('source/output/*', 'verbose', s:action_verbose_map)

let s:action_open = {
\   'description' : 'open',
\   'is_selectable' : 1,
\}

function! s:action_open.func(candidates)
    for candidate in a:candidates
        let l:mapmode = matchstr(candidate.unite__abbr, '^\S\+') . 'map'
        let l:lhs = matchstr(candidate.unite__abbr, '^\S\+\s\+\zs\S\+\ze')
        redir => l:verbose_map
        silent execute 'verbose ' l:mapmode l:lhs
        redir END

        let l:rhs = matchstr(l:verbose_map, '\S\s\+\S\+\s\+\(\*[@ ]\)\?:\?\zs.\+\ze\n')
        let l:file = matchstr(l:verbose_map, 'Last set from \zs\f\+')

        " 割とよい
        echom 'grep ' . shellescape(escape(l:rhs, '\.*'), 1) . ' ' . escape(l:file, ' ')
        " execute 'grep ' . shellescape(escape(l:rhs, '\.*'), 1) . ' ' . escape(l:file, ' ')
        execute 'vimgrep /\V' . escape(l:rhs, '\') . '/ ' . escape(l:file, ' ')

        " echom 'grep ' . shellescape(escape(l:lhs, '\.*[]') . '\s\+' . escape(l:rhs, '\.*[]'), 1) . ' ' . escape(l:file, ' ')
        " verbose mapの結果は<Bar>を|、<Leader>を文字に変換してしまうので、記述と合わない場合がある
        " execute 'grep ' . shellescape(escape(l:lhs, '\.*[]') . '\s\+' . escape(l:rhs, '\.*[]'), 1) . ' ' . escape(l:file, ' ')
    endfor
endfunction

call unite#custom#action('source/output/*', 'open', s:action_open)

call unite#custom_default_action('directory' , 'vimfiler')
" vimfiler上ではvimfilerを増やさず、移動するだけ
" autocmd MyVimrc FileType vimfiler
" \   call unite#custom_default_action('directory', 'lcd')

call unite#custom_default_action('source/directory/directory' , 'vimfiler')
call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')

" dでファイルの削除
call unite#custom#alias('file', 'delete', 'vimfiler__delete')
call unite#custom#alias('directory', 'delete', 'vimfiler__delete')

" [unite-filters の converter を活用しよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20130919/1379602932)
if !exists('g:unite_source_alias_aliases')
    let g:unite_source_alias_aliases = {}
endif
let g:unite_source_alias_aliases['memo'] = {
\   'source' : 'file_rec/async',
\   'args' : g:memo_directory,
\}

call unite#custom#source('memo', 'sorters', ['sorter_ftime', 'sorter_reverse'])

call unite#custom#profile('source/grep', 'context',
\ {'no_quit' : 1})

call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

" unite-grep {{{1
" ========================================================================
" :h unite-source-grep
" grepの結果のファイル名を短くするのはこの辺を見ればできるかも
" :h unite#custom#profile()
" [:Unite file でどこにいるのかわからなくなる問題を解決する - basyura's blog](http://blog.basyura.org/entry/2013/05/08/210536)
if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    " --vimgrepは同一行の複数マッチが出てくるので-n --noheadingにする
    " -fはfollow symlinks
    let g:unite_source_grep_default_opts =
    \ '-f --noheading --nocolor --hidden --ignore ' .
    \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
    " ptは複数PATH指定ができない。
    " ptの文字コードチェックは512byteまで。
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '-e -S --nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
elseif executable('grep')
    let g:unite_source_grep_command = 'grep'
    let g:unite_source_grep_default_opts = '-inHE'
    let g:unite_source_grep_recursive_opt = '-r'
elseif executable('jvgrep')
    " jvgrepは遅い
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts = '--color=never -i'
    let g:unite_source_grep_recursive_opt = '-R'
endif

let g:unite_source_grep_max_candidates = 1000
    " Set "-no-quit" automatically in grep unite source.

" unite-args {{{1
" ========================================================================
function! s:set_arglist(candidates)
    let argslist = {}
    for candidate in a:candidates
        " h unite-kind-file
        let argslist[candidate.action__path] = 1
    endfor
    execute 'argadd' join(map(keys(argslist), 'fnameescape(v:val)'))
endfunction

" arglistにuniteで選択したファイルを設定する
let s:args_action = {'description': 'args', 'is_selectable': 1}

function! s:args_action.func(candidates)
    silent! argdelete *
    call s:set_arglist(a:candidates)
endfunction

" arglistにuniteで選択したファイルを追加する
let s:argadd_action = {'description': 'argadd', 'is_selectable': 1}

function! s:argadd_action.func(candidates)
    call s:set_arglist(a:candidates)
endfunction

call unite#custom#action('file', 'argadd', s:argadd_action)
call unite#custom#action('file', 'args', s:args_action)

" unite-ghq {{{1
" ============================================================================
if dein#tap('unite-ghq')
    call unite#custom_default_action('source/ghq/directory', 'vimfiler')
endif

" うまく言っていない
autocmd MyVimrc FileType unite call s:unite_my_settings()

function! s:unite_my_settings() "{{{
    imap <buffer> '          <Plug>(unite_quick_match_default_action)
    imap <buffer> <C-Space>  <Plug>(unite_toggle_mark_current_candidate)
endfunction
