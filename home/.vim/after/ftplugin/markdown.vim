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

" setlocal nowrap

" イタリックを無効に
highlight! link markdownItalic Normal
highlight! link htmlItalic Normal

nmap <buffer> <expr> <C-P> yankround#is_active() ? "\<Plug>(yankround-prev)"  : "\<Plug>Markdown_MoveToPreviousHeader"
nmap <buffer> <expr> <C-N> yankround#is_active() ? "\<Plug>(yankround-next)"  : "\<Plug>Markdown_MoveToNextHeader"

command! -buffer -range=% Markdownize    :<line1>,<line2>!pandoc -f html -t markdown_phpextra --wrap=none
command! -buffer -range=% MarkdownStrict :<line1>,<line2>!pandoc -f markdown+hard_line_breaks -t markdown_strict --wrap=none
