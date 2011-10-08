set nocompatible "vi互換にしない

"----------------------------------------------------------
" 表示
"----------------------------------------------------------
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set number
set ruler

"----------------------------------------------------------
" ステータスライン 
"----------------------------------------------------------

" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"               0: 全く表示しない
"               1: ウィンドウの数が2以上のときのみ表示
"               2: 常に表示
set laststatus=2

set statusline=%f%=%m[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l]\ %P

"256色
set t_Co=256

"http://www.vim.org/scripts/script.php?script_id=2340
colorscheme molokai

syntax enable
filetype plugin on
 
"https://github.com/tpope/vim-pathogen
"call pathogen#infect()

"タブページの設定
" いつタブページのラベルを表示するかを指定する。
"                0: 表示しない
"                1: 2個以上のタブページがあるときのみ表示
"                2: 常に表示
set showtabline=1


"----------------------------------------------------------
" コマンドモード
"----------------------------------------------------------
set wildmenu "コマンド入力時にTabを押すと補完メニューを表示する
"前方一致をCtrl+PとCtrl+Nで
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>


"----------------------------------------------------------
" バッファ
"----------------------------------------------------------
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden

" buftabs 
" http://www.vim.org/scripts/script.php?script_id=1664
" バッファタブにパスを省略してファイル名のみ表示する
let g:buftabs_only_basename=1
" バッファタブをステータスライン内に表示する
let g:buftabs_in_statusline=1
" 現在のバッファをハイライト
let g:buftabs_active_highlight_group="Visual"
let g:buftabs_separator = " "  
 
"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
"ファイル内の <Tab> が対応する空白の数
set tabstop=4 
"<Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数
set softtabstop=4 
"インデントの各段階に使われる空白の数
set shiftwidth=4 
set expandtab
"新しい行のインデントを現在行と同じくする
set autoindent 
set smartindent


"----------------------------------------------------------
" paste
"----------------------------------------------------------
"pasteモードのトグル。autoindentをonにしてペーストすると
"インデントが入った文章が階段状になってしまう。
"pasteモードではautoindentが解除されそのままペーストできる
set pastetoggle=<F11>  

"Tera TermなどのBracketed Paste Modeをサポートした端末では
"以下の設定で、貼り付けるとき自動的にpasteモードに切り替えてくれる。
"ノーマルモードからも貼付けできる
"screenを使っていると使えない
if &term == "xterm"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  map <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
  imap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  cmap <special> <Esc>[200~ <nop>
  cmap <special> <Esc>[201~ <nop>
endif


"----------------------------------------------------------
" 検索
"----------------------------------------------------------
set incsearch
set ignorecase "検索パターンに大文字を含まなければ大文字小文字を区別しない
set smartcase "検索パターンに大文字を含んでいたら大文字小文字を区別する
set nohlsearch "検索結果をハイライトしない
"ヴィビュアルモードで選択した範囲だけ検索
vnoremap / <ESC>/\%V
vnoremap ? <ESC>?\%V

 
 
"----------------------------------------------------------
" カーソル
"----------------------------------------------------------
"カーソルを表示行で移動する。
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
 
" backspaceキーの挙動を設定する
" " indent        : 行頭の空白の削除を許す
" " eol           : 改行の削除を許す
" " start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start


"----------------------------------------------------------
" カッコ・タグの対応
"----------------------------------------------------------
set showmatch matchtime=1 "括弧の対応
source $VIMRUNTIME/macros/matchit.vim "HTML tag match


"----------------------------------------------------------
" マップ
"----------------------------------------------------------
inoremap jj <ESC>


"----------------------------------------------------------
" 文字コード
"----------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom
"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

" 文字コードの自動認識
"if &encoding !=# 'utf-8'
"  set encoding=japan
"  set fileencoding=japan
"endif
"if has('iconv')
"  let s:enc_euc = 'euc-jp'
"  let s:enc_jis = 'iso-2022-jp'
"  " iconvがeucJP-msに対応しているかをチェック
"  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'eucjp-ms'
"    let s:enc_jis = 'iso-2022-jp-3'
"  " iconvがJISX0213に対応しているかをチェック
"  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'euc-jisx0213'
"    let s:enc_jis = 'iso-2022-jp-3'
"  endif
"  " fileencodingsを構築
"  if &encoding ==# 'utf-8'
"    let s:fileencodings_default = &fileencodings
"    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
"    let &fileencodings = &fileencodings .','. s:fileencodings_default
"    unlet s:fileencodings_default
"  else
"    let &fileencodings = &fileencodings .','. s:enc_jis
"    set fileencodings+=utf-8,ucs-2le,ucs-2
"    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
"      set fileencodings+=cp932
"      set fileencodings-=euc-jp
"      set fileencodings-=euc-jisx0213
"      set fileencodings-=eucjp-ms
"      let &encoding = s:enc_euc
"      let &fileencoding = s:enc_euc
"    else
"      let &fileencodings = &fileencodings .','. s:enc_euc
"    endif
"  endif
"  " 定数を処分
"  unlet s:enc_euc
"  unlet s:enc_jis
"endif
"" 日本語を含まない場合は fileencoding に encoding を使うようにする
"if has('autocmd')
"  function! AU_ReCheck_FENC()
"    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
"      let &fileencoding=&encoding
"    endif
"  endfunction
"  autocmd BufReadPost * call AU_ReCheck_FENC()
"endif
"" 改行コードの自動認識
"set fileformats=unix,dos,mac
"" □とか○の文字があってもカーソル位置がずれないようにする
"if exists('&ambiwidth')
"  set ambiwidth=double
"endif


"----------------------------------------------------------
" Manual
"----------------------------------------------------------
":Man <man>でマニュアルを開く
runtime ftplugin/man.vim
nmap K <Leader>K
"コマンドラインでmanを使ったとき、vimの:Manで見るようにするための設定
"http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
".zshrc .bashrc等にも記述が必要
let $PAGER=''

"----------------------------------------------------------
" gVim
"----------------------------------------------------------
"Windowsのgvimのメニューの文字化け対応
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"----------------------------------------------------------
" neocomplcache
"----------------------------------------------------------
" setting examples:
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
