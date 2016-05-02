scriptencoding utf-8
let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
\ . 'setlocal tabstop< softtabstop< shiftwidth< formatoptions< comments<'

" pandocのmarkdownだとスペース4つ分ないとリストが入れ子にならないのでコメントアウト
" setlocal tabstop=2
" let &l:softtabstop = &l:tabstop
" let &l:shiftwidth = &l:tabstop

set iskeyword+=-

" イタリックを無効に
highlight! link markdownItalic Normal
highlight! link htmlItalic Normal

nmap <buffer> <expr> <C-p> yankround#is_active() ? "\<Plug>(yankround-prev)"  : "\<Plug>Markdown_MoveToPreviousHeader"
nmap <buffer> <expr> <C-n> yankround#is_active() ? "\<Plug>(yankround-next)"  : "\<Plug>Markdown_MoveToNextHeader"
