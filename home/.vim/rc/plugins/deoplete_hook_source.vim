scriptencoding utf-8

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_yarp = 1
" 入力を止めてから表示するまでの時間
" let g:deoplete#auto_complete_delay = 1 " default 50
" let g:deoplete#auto_refresh_delay = 1 " default 500

" Memo: g:deoplete#enable_refresh_always を1にすると、通常の
" ```Shougo/deoplete.nvim/autoload/deoplete/handler.vim
"   autocmd TextChangedI * call s:completion_begin('TextChangedI')
" ```
" での補完に加え
" ```
"   if g:deoplete#enable_refresh_always
"     autocmd deoplete InsertCharPre *
"           \ call s:completion_begin('InsertCharPre')
"   endif
" ```
" でも補完が開始するようになる
" let g:deoplete#enable_refresh_always = 1 " defalult 0


" let g:deoplete#file#enable_buffer_path = 1 " default 0

" let g:deoplete#auto_complete_delay = 50 " default 50
" let g:deoplete#auto_refresh_delay = 500 " default 500
" 候補が更新される

" let g:deoplete#max_list = 20
" set pumheight=10

inoremap <expr><C-l> deoplete#complete_common_string()
" inoremap <expr><C-l> deoplete#refresh()
inoremap <expr><C-Space> deoplete#mappings#manual_complete()

" let g:deoplete#sources = get(g:, 'deoplete#sources', {})
" let g:deoplete#sources._ = ['mozc']

let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']

let g:deoplete#sources#mozc#mozc_emacs_helper_path = 'mozc_emacs_helper'

" let g:deoplete#enable_profile = 1
" call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
" call deoplete#custom#source('padawan', 'is_debug_enabled', 1)
