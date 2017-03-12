scriptencoding utf-8
let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
\ . 'setlocal tabstop< softtabstop< shiftwidth< formatoptions< comments<'

" pandocのmarkdownだとスペース4つ分ないとリストが入れ子にならない
setlocal tabstop=4
" setlocal softtabstop=4
" setlocal shiftwidth=4

setlocal iskeyword+=-
setlocal commentstring=<!--%s-->

" setlocal tabstop=2 " front matterは2スペースにしたいが、リストのネストを考えると4スペース

setlocal nowrap

" イタリックを無効に
highlight! link markdownItalic Normal
highlight! link htmlItalic Normal

nmap <buffer> <expr> <C-P> yankround#is_active() ? "\<Plug>(yankround-prev)"  : "\<Plug>Markdown_MoveToPreviousHeader"
nmap <buffer> <expr> <C-N> yankround#is_active() ? "\<Plug>(yankround-next)"  : "\<Plug>Markdown_MoveToNextHeader"
