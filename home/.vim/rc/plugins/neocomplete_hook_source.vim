scriptencoding utf-8

" Use neocomplcache.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_ignore_case = 1

" smartcaseな補完にする
let g:neocomplete#enable_camel_case = 0

" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_syntax_length = 3

" for keyword
let g:neocomplete#auto_completion_start_length = 1

set pumheight=10
" 補完候補取得に時間がかかったときにスキップ
let g:neocomplete#skip_auto_completion_time = '0.1'
" let g:neocomplete#skip_auto_completion_time = '1'
" 候補の数を増やす
" execute 'let g:'.s:neocom_.'max_list = 3000'

" execute 'let g:'.s:neocom_.'force_overwrite_completefunc = 1'

" if !exists('g:neocomplete#same_filetypes')
"   let g:neocomplete#same_filetypes = {}
" endif
" " In default, completes from all buffers.
" let g:neocomplete#same_filetypes._ = '_'

let g:neocomplete#enable_auto_close_preview=0
" fugitiveのバッファも閉じてしまうのでコメントアウト
" autocmd MyVimrc InsertLeave *.* pclose

" let g:neocomplete#sources#tags#cache_limit_size = 1000000
" 使用する補完の種類を減らす
" http://alpaca-tc.github.io/blog/vim/neocomplete-vs-youcompleteme.html

" 現在のSourceの取得は
" `:echo keys(neocomplete#variables#get_sources())`
" デフォルト: ['file', 'tag', 'neosnippet', 'vim', 'dictionary',
" 'omni', 'member', 'syntax', 'include', 'buffer', 'file/include']

if !exists('g:neocomplete#sources')
    let g:neocomplete#sources = {}
endif
" let g:neocomplete#sources._    = ['tag', 'syntax', 'neosnippet', 'ultisnips', 'dictionary', 'omni', 'member', 'buffer', 'file', 'file/include']
let g:neocomplete#sources._    = ['tag', 'syntax', 'neosnippet', 'dictionary', 'omni', 'member', 'buffer', 'file', 'file/include']
" codeのハイライトのためsyntaxファイルを大量に読み込むため、syntaxを入れておくと、insertモード開始時に固まるので抜く
let g:neocomplete#sources.markdown = ['tag', 'dictionary', 'omni', 'member', 'buffer', 'file', 'file/include']
" shawncplus/phpcomplete.vimで補完されるため、syntaxはいらない
let g:neocomplete#sources.php      = ['tag', 'neosnippet', 'omni', 'member', 'buffer', 'file', 'file/include']
let g:neocomplete#sources.vim      = ['member', 'buffer', 'file', 'neosnippet', 'file/include', 'vim']
let g:neocomplete#sources.vimshell = ['buffer', 'vimshell']

let dictionary = g:memo_directory . '/memo/doc/memo.dict'
" neocompleteで日本語を出すには設定が必要
let g:neocomplete#sources#dictionary#dictionaries = {
\   'default': '',
\   'vimshell': $HOME.'/.vimshell_hist',
\   'markdown': g:memo_directory . '/memo.dict'
\ }

" 補完候補の順番
" defaultの値は ~/.vim/bundle/neocomplete.vim/autoload/neocomplete/sources/ 以下で確認
" ファイル名補完
call neocomplete#custom#source('file',         'rank', 450)
call neocomplete#custom#source('neosnippet',   'rank', 440)
call neocomplete#custom#source('member',       'rank', 430)
call neocomplete#custom#source('buffer',       'rank', 420)
call neocomplete#custom#source('omni',         'rank', 410)
call neocomplete#custom#source('file/include', 'rank', 370)
call neocomplete#custom#source('tag',          'rank', 360)
call neocomplete#custom#source('syntax',       'rank', 300)
" call neocomplete#custom#source('ultisnips',    'rank', 400)

" call neocomplete#custom#source('neosnippet', 'min_pattern_length', 2)

let g:neocomplete#data_directory = $VIM_CACHE_DIR . '/neocomplete'

" Enable omni completion.
augroup MyVimrc
    autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
    autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
augroup END
" let g:neocomplete#sources#omni#functions.sql =
" \ 'sqlcomplete#Complete'

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
endif

let g:neocomplete#sources#omni#functions.dot = 'GraphvizComplete'
let g:neocomplete#force_omni_input_patterns.dot = '\%(=\|,\|\[\)\s*\w*'
" forceで設定しているとmarkdownのコードブロックでも探そうとするらしく
"   -- オムニ補完 (^O^N^P) パターンは見つかりませんでした
" が表示される

let g:neocomplete#sources#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns = {
\   'ruby' : '[^. *\t]\.\w*\|\h\w*::',
\}

" artur-shaik/vim-javacomplete2
autocmd MyVimrc FileType java          setlocal omnifunc=javacomplete#Complete
let g:neocomplete#sources#omni#input_patterns.java = '\h\w\{2,\}\|[^. \t]\.\%(\h\w\+\)\?'


" 日本語も補完させたい場合は
" g:neocomplete#enable_multibyte_completionをnon-0にして
" g:neocomplete#keyword_patternsも変更する必要あり

" key mappings {{{2
inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
execute 'inoremap <expr><C-l> neocomplete#complete_common_string()'
execute 'inoremap <expr><C-Space> neocomplete#start_manual_complete()'
" execute 'inoremap <expr><C-Space> pumvisible() ? "\<C-n>" : neocomplete#start_manual_complete()'
" inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-n>"
execute 'inoremap <expr><C-g>  pumvisible() ? neocomplete#undo_completion() : "\<C-g>"'

" <C-u>, <C-w>した文字列をアンドゥできるようにする
" http://vim-users.jp/2009/10/hack81/
" C-uでポップアップを消したいがうまくいかない
execute 'inoremap <expr><C-u>  pumvisible() ? neocomplete#smart_close_popup()."\<C-g>u<C-u>" : "\<C-g>u<C-u>"'
execute 'inoremap <expr><C-w>  pumvisible() ? neocomplete#smart_close_popup()."\<C-g>u<C-w>" : "\<C-g>u<C-w>"'

" previewしない
set completeopt-=preview
if MyHasPatch('patch-7.4.775')
    " insert,selectしない
    " set completeopt+=noinsert,noselect
endif

" auto_selectするとsnippetの方でうまくいかない
" let g:neocomplete#enable_auto_select = 1
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"     " For no inserting <CR> key.
"     return pumvisible() ? "\<C-y>" : "\<CR>"
"     " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
" endfunction

" " <TAB>: completion.
" " ポップアップが出ていたら下を選択
" " 出てなくて、
" "   *があるときは右にインデント。a<BS>しているのは、改行直後に<Esc>すると、autoindentによって挿入された
" "   空白が消えてしまうので
" "   それ以外は普通のタブ
" " 矩形選択して挿入モードに入った時にうまくいかない
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
"     \   (match(getline('.'), '^\s*\*') >= 0 ? "a<BS>\<Esc>>>A" : "\<Tab>")
" inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" :
"     \   (match(getline('.'), '^\s*\*') >= 0 ? "a<BS>\<Esc><<A" : "\<S-Tab>")

" ポップアップが出てない時に、カーソルの左側がスペースならばタブ、そうでない場合は手動補完
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
" \   <SID>check_back_space() ? "\<TAB>" :
" \   neocomplete#start_manual_complete()
" function! s:check_back_space()
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" <BS>, <C-h> でポップアップを閉じて文字を削除。ポップアップを選択していたときはそれがキャンセルされた後に削除される。
" 例) fuとタイプして、補完候補のfunctionを選択していた時に<BS>するとfになる
" lexima.vimと競合するのでコメントアウト
" execute 'inoremap <expr><BS>  pumvisible() ? neocomplete#smart_close_popup()."\<BS>"  : "\<BS>"'
" execute 'inoremap <expr><C-h> pumvisible() ? neocomplete#smart_close_popup()."\<C-h>" : "\<C-h>"'

" <CR> でポップアップ中の候補を選択し改行する
" execute 'inoremap <expr><CR> neocomplete#close_popup()."\<CR>"'

" これをやるとコピペに改行があるときにポップアップが選択されてしまう
" 補完候補が表示されている場合は確定。そうでない場合は改行
" execute 'inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"'

" endif

" let g:neocomplete#fallback_mappings =
" \ ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

" inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
" inoremap <expr><C-x><C-n>  neocomplete#start_manual_complete('buffer')
imap  <C-x>u <Plug>(neocomplete_start_unite_complete)
" imap  <C-x>u <Plug>(neocomplete_start_unite_quick_match)

" let g:neocomplete#enable_cursor_hold_i = 1
" let g:neocomplete#cursor_hold_i_time = 100

" let g:neocomplete#disable_auto_complete = 1
" let g:neocomplete#enable_refresh_always = 1
" autocmd MyVimrc FileType *
" \   if &filetype == 'php'
" \|      echom 'php'
" \|      let g:neocomplete#enable_cursor_hold_i=1
" \|      let g:neocomplete#cursor_hold_i_time=100
" \|      NeoCompleteEnable
" \|  else
" \|      let g:neocomplete#enable_cursor_hold_i=0
" \|      NeoCompleteEnable
" \|  endif

" ?
" let g:neocomplete#fallback_mappings =
" \ ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

" inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
" inoremap <expr><C-x><C-n>  neocomplete#start_manual_complete('buffer')
imap  <C-x>u <Plug>(neocomplete_start_unite_complete)
" imap  <C-x>u <Plug>(neocomplete_start_unite_quick_match)
