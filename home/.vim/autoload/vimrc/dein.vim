scriptencoding utf-8

" lazyに設定してないプラグインの取得
" dein#util#_get_lazy_plugins()の逆
function! vimrc#dein#get_non_lazy_plugins() abort
  return filter(values(g:dein#_plugins), 'v:val.sourced')
endfunction

" lazyに設定してなくて、plugin/やafter/plugin/ディレクトリがあるプラグイン
" dein#util#_check_lazy_plugins()の逆
function! vimrc#dein#check_non_lazy_plugins() abort
  return map(filter(vimrc#dein#get_non_lazy_plugins(),
        \   "isdirectory(v:val.rtp)
        \    && (isdirectory(v:val.rtp . '/plugin') || isdirectory(v:val.rtp . '/after/plugin'))
        \    && !get(v:val, 'lazy', 0)
        \   "),
        \   'v:val.name')
endfunction
