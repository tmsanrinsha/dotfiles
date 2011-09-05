set nocompatible "vi互換にしない

"----------------------------------------------------------
" 表示
"----------------------------------------------------------
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set number
set ruler
" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"               0: 全く表示しない
"               1: ウィンドウの数が2以上のときのみ表示
"               2: 常に表示
set laststatus=2

" ステータスライン
set statusline=%<%f%=%m[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%2v,%3l/%L]
"set statusline=%<%f%=%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%9(\ %m%r\ %)[%4v][%12(\ %5l/%5L%)]

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
" バッファの切り替え
"----------------------------------------------------------
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
 
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
set showmatch "括弧の対応
source $VIMRUNTIME/macros/matchit.vim "HTML tag match


"----------------------------------------------------------
" マップ
"----------------------------------------------------------
imap jj <ESC>


"----------------------------------------------------------
" 文字コード
"----------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom

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
" gVim
"----------------------------------------------------------
"Windowsのgvimのメニューの文字化け対応
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
