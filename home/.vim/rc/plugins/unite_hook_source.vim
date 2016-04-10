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
        execute 'verbose map' matchstr(candidate.unite__abbr, '^\S\+\s\+\zs\S\+\ze')
    endfor
endfunction

call unite#custom#action('source/output/*', 'verbose', s:action_verbose_map)

call unite#custom_default_action('directory' , 'vimfiler')
" vimfiler上ではvimfilerを増やさず、移動するだけ
" autocmd MyVimrc FileType vimfiler
" \   call unite#custom_default_action('directory', 'lcd')

call unite#custom_default_action('source/directory/directory' , 'vimfiler')
call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')

" dでファイルの削除
call unite#custom#alias('file', 'delete', 'vimfiler__delete')
call unite#custom#alias('directory', 'delete', 'vimfiler__delete')

call unite#custom#source('memo', 'sorters', ['sorter_ftime', 'sorter_reverse'])

call unite#custom#profile('source/grep', 'context',
\ {'no_quit' : 1})

call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

" unite-args {{{2
" ------------------------------------------------------------------------
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

if dein#tap('unite-ghq')
    call unite#custom_default_action('source/ghq/directory', 'vimfiler')
endif
