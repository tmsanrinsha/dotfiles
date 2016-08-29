scriptencoding utf-8

let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:openbrowser_open_filepath_in_vim = 0 " Vimで開かずに関連付けされたプログラムで開く

if !exists('g:openbrowser_search_engines')
    let g:openbrowser_search_engines = {}
endif

let g:openbrowser_search_engines.php =
\   'http://www.php.net/search.php?show=quickref&=&pattern={query}'
let g:openbrowser_search_engines.mql4 =
\   'http://www.mql4.com/search#!keyword={query}'

if $SSH_CLIENT !=# ''
    let g:openbrowser_browser_commands = [
    \   {
    \       'name': 'rfbrowser',
    \       'args': 'rfbrowser {uri}'
    \   }
    \]
endif
