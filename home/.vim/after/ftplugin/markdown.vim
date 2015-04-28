let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
\ . 'setlocal formatoptions< path<'

" イタリックを無効に
highlight! link markdownItalic Normal
highlight! link htmlItalic Normal

" Automatically insert bullets
setlocal formatoptions+=ro
" Do not automatically insert bullets when auto-wrapping with text-width
setlocal formatoptions-=c
" Accept various markers as bullets
setlocal comments=b:*,b:+,b:-
