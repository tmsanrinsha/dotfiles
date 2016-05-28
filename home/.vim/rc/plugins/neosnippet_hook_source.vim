scriptencoding utf-8

" Plugin key-mappings.
imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
\   "\<Plug>(neosnippet_expand_or_jump)" :
\   "\<C-o>D"
smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
\   "\<Plug>(neosnippet_expand_or_jump)" :
\   "\<C-o>D"
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:neosnippet#disable_select_mode_mappings = 1

snoremap <BS>     <BS><BS>
snoremap <BS>     <BS><BS>
snoremap <C-h>    <BS><BS>
snoremap <Del>    <BS><BS>

autocmd MyVimrc FileType markdown
\   inoremap <buffer> <C-k> <C-o>D

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
