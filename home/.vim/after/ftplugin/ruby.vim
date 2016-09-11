scriptencoding utf-8

setlocal tabstop=2
let &l:softtabstop = &l:tabstop
let &l:shiftwidth = &l:tabstop

setlocal textwidth=120
setlocal colorcolumn=+1
setlocal foldmethod=syntax

# ChefSpec用
setlocal errorformat^=\ %##\ %f:%l:%m

" MacVIM-KaoriYa で "現在の Ruby" の libruby.dylib を動的リンクする - ドレッシングのような
" http://d.hatena.ne.jp/mrkn/20110221/current_ruby_in_macvim_kaoriya
if has('gui_macvim') && has('kaoriya')
  let s:ruby_libdir = system("ruby -rrbconfig -e 'print RbConfig::CONFIG[\"libdir\"]'")
  let s:ruby_libruby = s:ruby_libdir . '/libruby.dylib'
  if filereadable(s:ruby_libruby)
    let $RUBY_DLL = s:ruby_libruby
  endif
endif

" Set async completion.
let g:monster#completion#rcodetools#backend = 'async_rct_complete'
