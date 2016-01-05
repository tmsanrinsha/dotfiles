" from plasticboy/vim-markdown/indent/markdown.vim
" Automatically insert bullets
setlocal formatoptions+=r
" Do not automatically insert bullets when auto-wrapping with text-width
setlocal formatoptions-=c
" Accept various markers as bullets
setlocal comments=b:*,b:+,b:-,b:1.

" Automatically continue blockquote on line break
setlocal comments+=bn:>

command! Preview execute '!open '.expand('%:p:r').'.html'
