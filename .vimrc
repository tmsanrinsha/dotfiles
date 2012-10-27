" neobundle.vim {{{
" ==============================================================================
" https://github.com/Shougo/neobundle.vim
" http://vim-users.jp/2011/10/hack238/
if filereadable(expand('~/.vim/bundle/neobundle.vim/autoload/neobundle.vim'))
    set nocompatible "vi互換にしない
    filetype off     " required!

    if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif

    call neobundle#rc(expand('~/.vim/bundle/'))

    " let NeoBundle manage NeoBundle
    " required!
    NeoBundle 'Shougo/neobundle.vim'

    " recommended to install
    NeoBundle 'Shougo/vimproc', {
      \   'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }

    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/vimfiler'
    NeoBundle 'Shougo/vimshell'

    " 補完候補の自動表示
    NeoBundle 'Shougo/neocomplcache'
    " スニペット補完
    "NeoBundle 'Shougo/neocomplcache-snippets-complete'
    NeoBundle 'Shougo/neosnippet'

    " http://archiva.jp/web/tool/vim_grep2.html
    NeoBundle 'thinca/vim-qfreplace'

    NeoBundle 'thinca/vim-quickrun'

    " コマンドモードをEmacsキーバインドにする
    NeoBundle 'houtsnip/vim-emacscommandline'

    " ファイルを保存時にシンタックスのチェック
    " https://github.com/scrooloose/syntastic
    NeoBundle 'scrooloose/syntastic'

    " ミニバッファにバッファ一覧を表示
    " https://github.com/fholgado/minibufexpl.vim
    NeoBundle 'fholgado/minibufexpl.vim'

    " バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
    " https://github.com/rgarver/Kwbd.vim
    NeoBundle 'rgarver/Kwbd.vim'

    " ステータスラインをカスタマイズ
    " https://github.com/Lokaltog/vim-powerline
    NeoBundle 'Lokaltog/vim-powerline'

    " 自分で修正したプラグイン
    " https://github.com/tmsanrinsha/vim
    "NeoBundle 'tmsanrinsha/vim'

    " sudo権限でファイルを開く・保存
    " http://www.vim.org/scripts/script.php?script_id=729
    NeoBundle 'sudo.vim'

    " ヤンクの履歴を選択してペースト
    " http://www.vim.org/scripts/script.php?script_id=1234
    NeoBundle 'YankRing.vim'

    NeoBundle 'Align'

    NeoBundle 'confluencewiki.vim'

    " colorscheme
    NeoBundle 'tomasr/molokai'
    NeoBundle 'altercation/vim-colors-solarized'
    " http://www.vim.org/scripts/script.php?script_id=1732
    NeoBundle 'rdark'
    " http://www.vim.org/scripts/script.php?script_id=2536
    NeoBundle 'jonathanfilip/vim-lucius'
    let g:lucius_contrast_bg = 'high'
    NeoBundle 'vim-scripts/wombat256.vim'


    " tmuxのシンタックス
    NeoBundle 'zaiste/tmux.vim'

    "NeoBundle 'L9'
    "NeoBundle 'FuzzyFinder'
    "NeoBundle 'rails.vim'

    "" non github repos ----------------------------------------------------------
    "NeoBundle 'git://git.wincent.com/command-t.git'
    "" non git repos
    "NeoBundle 'http://svn.macports.org/repository/macports/contrib/mpvim/'
    "NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'


    filetype plugin indent on     " required!

    " Brief help
    " :NeoBundleList          - list configured bundles
    " :NeoBundleInstall(!)    - install(update) bundles
    " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles
    " :Unite neobundle/install:!
    " :Unite neobundle/install:neocomplcache
    " :Unite neobundle/install:neocomplcache:unite.vim


    " Installation check.
    if neobundle#exists_not_installed_bundles()
      echomsg 'Not installed bundles : ' .
            \ string(neobundle#get_not_installed_bundle_names())
      echomsg 'Please execute ":NeoBundleInstall" command.'
      "finish
    endif
else
    set nocompatible "vi互換にしない
    filetype plugin indent on
endif
"}}}

" Pluginの有無をチェックする関数 {{{
" ==============================================================================
" http://yomi322.hateblo.jp/entry/2012/06/20/225559
function! s:has_plugin(plugin)
  return !empty(globpath(&runtimepath, 'plugin/'   . a:plugin . '.vim'))
  \   || !empty(globpath(&runtimepath, 'autoload/' . a:plugin . '.vim'))
  \   || !empty(globpath(&runtimepath, 'colors/'   . a:plugin . '.vim'))
endfunction
"}}}

" 表示 {{{
" ==============================================================================
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set number
set ruler
set cursorline

" 不可視文字の可視化（Vimテクニックバイブル1-11） {{{
set list listchars=tab:>-,trail:_

" 全角スペースをハイライト
scriptencoding utf-8
augroup highlightIdeograpicSpace
    autocmd!
    autocmd ColorScheme * highlight IdeographicSpace term=underline ctermbg=67 guibg=#465457
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END
"}}}
"}}}

" タブ・インデント {{{
" ==============================================================================
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
"}}}

" ステータスライン {{{
" ==============================================================================

" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"               0: 全く表示しない
"               1: ウィンドウの数が2以上のときのみ表示
"               2: 常に表示
set laststatus=2

"set statusline=%f%=%m%r[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l]\ %P
"set statusline=%f%=%<%m%r[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l/%L]
"}}}

" カラースキーム {{{
" ==============================================================================
" 256色
set t_Co=256
"http://www.vim.org/scripts/script.php?script_id=2340
if s:has_plugin('molokai')
    colorscheme molokai
    set background=dark
    let g:molokai_original = 1
    "hi Normal                   ctermbg=0
else
    colorscheme default
endif
"colorscheme solarized
"set background=dark
"let g:solarized_termcolors=256
"}}}

" Mapping {{{
" ==============================================================================
set timeout timeoutlen=3000 ttimeoutlen=100

if !has('gui_running')
    " ターミナル上でのメタキーの設定
    set <M-0>=0
    set <M-1>=1
    set <M-2>=2
    set <M-3>=3
    set <M-4>=4
    set <M-5>=5
    set <M-6>=6
    set <M-7>=7
    set <M-8>=8
    set <M-9>=9
    set <M-n>=n
    set <M-p>=p

    " <C-Tab><S-C-Tab>など、ターミナル上で定義されていないキーを設定するためのトリック
    " http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    " MapFastKeycode: helper for fast keycode mappings
    " makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
    function! <SID>MapFastKeycode(key, keycode)
        if s:fast_i == 46
            echohl WarningMsg
            echomsg "Unable to map ".a:key.": out of spare keycodes"
            echohl None
            return
        endif
        let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
        exec 'set '.vkeycode.'='.a:keycode
        exec 'map '.vkeycode.' '.a:key
        let s:fast_i += 1
    endfunction
    let s:fast_i = 0

    call <SID>MapFastKeycode('<C-Tab>', "[27;5;9~")
    call <SID>MapFastKeycode('<S-C-Tab>', "[27;6;9~")
endif

inoremap jj <ESC>
nnoremap Y y$

"}}}

" バッファ {{{
" ==============================================================================
nnoremap <M-n> :bn<CR>
nnoremap <M-p> :bp<CR>
nnoremap <M-1> :b1<CR>
nnoremap <M-2> :b2<CR>
nnoremap <M-3> :b3<CR>
nnoremap <M-4> :b4<CR>
nnoremap <M-5> :b5<CR>
nnoremap <M-6> :b6<CR>
nnoremap <M-7> :b7<CR>
nnoremap <M-8> :b8<CR>
nnoremap <M-9> :b9<CR>
nnoremap <M-0> :b10<CR>

"変更中のファイルでも、保存しないで他のファイルを表示
set hidden

" bclose.vim
" バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
" https://github.com/rgarver/Kwbd.vim
" set hiddenを設定しておく必要あり
if filereadable(expand('~/.vim/bundle/Kwbd.vim/plugin/bclose.vim'))
    nmap <Leader>bd <Plug>Kwbd
endif
"}}}

" ウィンドウ {{{
" ==============================================================================
nnoremap <C-w>; <C-w>+
"  常にカーソル行を真ん中に
"set scrolloff=999

"縦分割されたウィンドウのスクロールを同期させる
"同期させたいウィンドウ上で<F12>を押せばおｋ
"解除はもう一度<F12>を押す
"横スクロールも同期させたい場合はこちら
"http://ogawa.s18.xrea.com/fswiki/wiki.cgi?page=Vim%A4%CE%A5%E1%A5%E2
nnoremap <F12> :set scrollbind!<CR>
"}}}

" タブ {{{
" ==============================================================================
"  いつタブページのラベルを表示するかを指定する。
"  0: 表示しない
"  1: 2個以上のタブページがあるときのみ表示
"  2: 常に表示
set showtabline=1

nnoremap [TAB] <Nop>
nmap <C-T> [TAB]
nnoremap [TAB]c :tabnew<CR>
nnoremap [TAB]q :tabc<CR>

nnoremap <C-Tab> :tabn<CR>
nnoremap <S-C-Tab> :tabp<CR>

nnoremap [TAB]1  :1tabn<CR>
nnoremap [TAB]2  :2tabn<CR>
nnoremap [TAB]3  :3tabn<CR>
nnoremap [TAB]4  :4tabn<CR>
nnoremap [TAB]5  :5tabn<CR>
nnoremap [TAB]6  :6tabn<CR>
nnoremap [TAB]7  :7tabn<CR>
nnoremap [TAB]8  :8tabn<CR>
nnoremap [TAB]9  :9tabn<CR>
nnoremap [TAB]0  :10tabn<CR>
"}}}

" コマンドモード {{{
" ==============================================================================
" 補完 {{{
" ------------------------------------------------------------------------------
" set wildmenu "コマンド入力時にTabを押すと補完メニューを表示する（リスト表示の方が好みなのでコメントアウト）
"
" コマンドモードの補完をシェルコマンドの補完のようにする
" http://vim-jp.org/vimdoc-ja/options.html#%27wildmode%27
" <TAB>で共通する最長の文字列まで補完して一覧表示
" 再度<Tab>を打つと候補を選択。<S-Tab>で逆
set wildmode=list:longest,full
"}}}


"前方一致をCtrl+PとCtrl+Nで
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>

set history=100000 "保存する履歴の数
"}}}

" 検索 {{{
" ==============================================================================
set incsearch
set ignorecase "検索パターンの大文字小文字を区別しない
set smartcase  "検索パターンに大文字を含んでいたら大文字小文字を区別する
set nohlsearch "検索結果をハイライトしない

" ESCキー2度押しでハイライトのトグル
nnoremap <Esc><Esc> :set hlsearch!<CR>

"ヴィビュアルモードで選択した範囲だけ検索
vnoremap <Leader>/ <ESC>/\%V
vnoremap <Leader>? <ESC>?\%V
"}}}

" ビジュアルモード {{{
" =============================================================================
" vipで選択後、IやAで挿入できるようにする {{{
" -----------------------------------------------------------------------------
" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
vnoremap <expr> I  <SID>force_blockwise_visual('I')
vnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)
    if mode() ==# 'v'
        return "\<C-v>" . a:next_key
    elseif mode() ==# 'V'
        return "\<C-v>0o$" . a:next_key
    else  " mode() ==# "\<C-v>"
        return a:next_key
    endif
endfunction
"}}}
"}}}

" ディレクトリ・ファイル {{{
" ==============================================================================
"augroup CD
"    autocmd!
"    autocmd BufEnter * execute ":lcd " . expand("%:p:h")
"augroup END
" 現在編集中のファイルのディレクトリをカレントディレクトリにする
nnoremap <silent><Leader>gc :cd %:h<CR>
" 現在編集中のファイルのフルパスを表示する
nnoremap <silent><Leader>fp :echo expand("%:p")<CR>
"}}}

" paste {{{
" ==============================================================================
"pasteモードのトグル。autoindentをonにしてペーストすると
"インデントが入った文章が階段状になってしまう。
"pasteモードではautoindentが解除されそのままペーストできる
set pastetoggle=<F11>

"Tera TermなどのBracketed Paste Modeをサポートした端末では
"以下の設定で、貼り付けるとき自動的にpasteモードに切り替えてくれる。
"http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html
"if &term =~ "xterm" && v:version > 603
"    "for screen
"    if &term == "xterm-256color"
"        let &t_SI = &t_SI . "\eP\e[?2004h\e\\"
"        let &t_EI = "\eP\e[?2004l\e\\" . &t_EI
"        let &pastetoggle = "\e[201~"
"    else
"        let &t_SI .= &t_SI . "\e[?2004h"
"        let &t_EI .= "\e[?2004l" . &t_EI
"        let &pastetoggle = "\e[201~"
"    endif
"
"    function! XTermPasteBegin(ret)
"        set paste
"        return a:ret
"    endfunction
"
"    imap <special> <expr> <Esc>[200~ XTermPasteBegin("")
"endif
"}}}

" カーソル {{{
" ==============================================================================
"カーソルを表示行で移動する。
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap <down> gj
vnoremap <down> gj
nnoremap <up> gk
vnoremap <up> gk
nnoremap 0 g0
vnoremap 0 g0
nnoremap $ g$
vnoremap $ g$
 
" backspaceキーの挙動を設定する
" " indent        : 行頭の空白の削除を許す
" " eol           : 改行の削除を許す
" " start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

" <C-u>, <C-w>した文字列をアンドゥできるようにする
" http://vim-users.jp/2009/10/hack81/
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>

" カーソルを行頭、行末で止まらないようにする。
" http://vimwiki.net/?'whichwrap'
"set whichwrap=b,s,h,l,<,>,[,],~

"カーソルの形状の変化
"http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html

"if &term == "xterm-256color" && v:version > 603
"    "let &t_SI .= "\eP\e[3 q\e\\"
"    let &t_SI .= "\eP\e[?25h\e[5 q\e\\"
"    let &t_EI .= "\eP\e[1 q\e\\"
"elseif &term == "xterm" && v:version > 603
"    "let &t_SI .= "\e[3 q"
"    let &t_SI .= "\e[?25h\e[5 q"
"    let &t_EI .= "\e[1 q"
"endif

"set notimeout      " マッピングについてタイムアウトしない
"set ttimeout       " 端末のキーコードについてタイムアウトする
"set timeoutlen=0 " ミリ秒後にタイムアウトする
"set timeout timeoutlen=3000 ttimeoutlen=100

"}}}

" カッコ・タグの対応 {{{
" ==============================================================================
set showmatch matchtime=1 "括弧の対応
runtime macros/matchit.vim "HTML tag match
"}}}

" vimdiff {{{
" ==============================================================================
nnoremap [VIMDIFF] <Nop>
nmap <Leader>d [VIMDIFF]
nnoremap <silent> [VIMDIFF]t :diffthis<CR>
nnoremap <silent> [VIMDIFF]u :diffupdate<CR>
nnoremap <silent> [VIMDIFF]o :diffoff<CR>
nnoremap          [VIMDIFF]s :vertical diffsplit<space>
"}}}

" Manual {{{
" ==============================================================================
":Man <man>でマニュアルを開く
runtime ftplugin/man.vim
nmap K <Leader>K
"コマンドラインでmanを使ったとき、vimの:Manで見るようにするための設定
"http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
".zshrc .bashrc等にも記述が必要
let $PAGER=''

autocmd FileType help nmap <buffer><silent> q :q<CR>
"}}}

" vimrcの編集 {{{
" ==============================================================================
" http://vim-users.jp/2009/09/hack74/
" .vimrcと.gvimrcの編集
nnoremap <silent> <Leader>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Leader>eg  :<C-u>edit $MYGVIMRC<CR>

" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> <Leader>rv :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif<CR>
nnoremap <silent> <Leader>rg :<C-u>source $MYGVIMRC<CR>

""vimrc auto update
"augroup MyAutoCmd
"  autocmd!
"  " nested: autocmdの実行中に更に別のautocmdを実行する
"  autocmd BufWritePost .vimrc nested source $MYVIMRC
"  " autocmd BufWritePost .vimrc RcbVimrc
"augroup END
"}}}

" gf(goto file)の設定 {{{
" ==============================================================================
" http://sanrinsha.lolipop.jp/blog/2012/01/vim%E3%81%AEgf%E3%82%92%E6%94%B9%E8%89%AF%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B.html
" ファイルの検索の範囲の変更
augroup htmlInclude
    autocmd!
    autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','')
augroup END
set path+=./;/
"}}}

" 文字コード {{{
" ==============================================================================
set encoding=utf-8
set fileencoding=utf-8

" ファイルのエンコードの判定を前から順番にする
" ファイルを読み込むときに 'fileencodings' が "ucs-bom" で始まるならば、
" BOM が存在するかどうかが調べられ、その結果に従って 'bomb' が設定される。
" http://vim-jp.org/vimdoc-ja/options.html#%27fileencoding%27
" 以下はVimテクニックバイブル「2-7ファイルの文字コードを変換する」に書いてあるfileencodings。
" ただし2つあるeuc-jpの2番目を消した
if has("win32") || has("win64")
    set fileencodings=iso-2222-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,eucjp-ms,cp932
else
    " 上の設定はたまに誤判定をするので、UNIX上で開く可能性があるファイルのエンコードに限定
    set fileencodings=ucs-boms,utf-8,euc-jp
endif

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
"}}}

" マウス {{{
" ==============================================================================
" Enable mouse support.
" Ctrlを押しながらマウスをを使うとmouse=aをセットしてないときの挙動になる
set mouse=a
 
" For screen, tmux
if &term == "xterm-256color"
    augroup MyAutoCmd
        autocmd VimLeave * :set mouse=
    augroup END

    " screenでマウスを使用するとフリーズするのでその対策
    " Tere Termだと自動で認識されているかも
    " http://slashdot.jp/journal/514186/vim-%E3%81%A7%E3%81%AE-xterm-%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%AE%E8%87%AA%E5%8B%95%E8%AA%8D%E8%AD%98
    set ttymouse=xterm2
endif

if has('gui_running')
    " Show popup menu if right click.
    set mousemodel=popup

    " Don't focus the window when the mouse pointer is moved.
    set nomousefocus
    " Hide mouse pointer on insert mode.
    set mousehide
endif
"}}}

" printing {{{
set printoptions=wrap:y,number:y,header:0
set printfont=Andale\ Mono:h12:cUTF8
"}}}

" Syntax {{{
" ==============================================================================
syntax enable
set foldmethod=marker

" Vimテクニックバイブル1-13
" PHPプログラムの構文チェック
" http://d.hatena.ne.jp/i_ogi/20070321/1174495931
"augroup phpsyntaxcheck
"    autocmd!
"    autocmd FileType php set makeprg=php\ -l\ % | set errorformat=%m\ in\ %f\ on\ line\ %l
"    "autocmd BufWrite *.php w !php -l 2>&1 | sed -e 's/\(.*Errors.*\)/[31m\1[0m/g'
"    autocmd BufWrite *.php w | make
"augroup END
"http://d.hatena.ne.jp/Cside/20110805/p1に構文チェックを非同期にやる方法が書いてある
"}}}

" >>>> Language >>>> {{{

" HTML {{{
" ==============================================================================
" HTML Key Mappings for Typing Character Codes: {{{
" ------------------------------------------------------------------------------
" * http://www.stripey.com/vim/html.html
" * https://github.com/sigwyg/dotfiles/blob/8c70c4032ebad90a8d92b76b1c5d732f28559e40/.vimrc
"
" |--------------------------------------------------------------------
" |Keys     |Insert   |For  |Comment
" |---------|---------|-----|-------------------------------------------
" |\&       |&amp;    |&    |ampersand
" |\<       |&lt;     |<    |less-than sign
" |\>       |&gt;     |>    |greater-than sign
" |\.       |&middot; |・   |middle dot (decimal point)
" |\?       |&#8212;  |?    |em-dash
" |\2       |&#8220;  |“   |open curved double quote
" |\"       |&#8221;  |”   |close curved double quote
" |\`       |&#8216;  |‘   |open curved single quote
" |\'       |&#8217;  |’   |close curved single quote (apostrophe)
" |\`       |`        |`    |OS-dependent open single quote
" |\'       |'        |'    |OS-dependent close or vertical single quote
" |\<Space> |&nbsp;   |     |non-breaking space
" |---------------------------------------------------------------------
"
augroup MapHTMLKeys
    autocmd!
    autocmd FileType html call MapHTMLKeys()
    function! MapHTMLKeys()
        inoremap <buffer> \\ \
        inoremap <buffer> \& &amp;
        inoremap <buffer> \< &lt;
        inoremap <buffer> \> &gt;
        inoremap <buffer> \. ・
        inoremap <buffer> \- &#8212;
        inoremap <buffer> \<Space> &nbsp;
        inoremap <buffer> \` &#8216;
        inoremap <buffer> \' &#8217;
        inoremap <buffer> \2 &#8220;
        inoremap <buffer> \" &#8221;
    endfunction " MapHTMLKeys()
augroup END
"}}}

" input </ to auto close tag on XML {{{
" ------------------------------------------------------------------------------
" https://github.com/sorah/config/blob/master/vim/dot.vimrc
augroup MyXML
  autocmd!
  autocmd Filetype xml  inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END
"}}}
"}}}

" PHP {{{
" ==============================================================================
let php_sql_query=1 " 文字列中のSQLをハイライトする
let php_htmlInStrings=1 " 文字列中のHTMLをハイライトする
let php_noShortTags = 1 " ショートタグ (<?を無効にする→ハイライト除外にする)
"let php_folding = 0 " クラスと関数の折りたたみ(folding)を有効にする (重い)
" augroup php
"     autocmd!
"     au Syntax php set foldmethod=syntax
" augroup END
"}}}

" MySQL {{{
" ==============================================================================
" Editorの設定
" http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
augroup mysqlEditor
    autocmd!
    au BufRead /var/tmp/sql* setlocal filetype=mysql
augroup END
"}}}

" <<<< Language <<<< }}}

" >>>> Plugin >>>> {{{
" unite {{{
" ==============================================================================
if s:has_plugin('unite')
    nnoremap [unite] <Nop>
    nmap <Leader>u [unite]

    call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
    " ブックマーク一覧
    nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>

    nnoremap <silent> [unite]l :<C-u>Unite line<CR>

    let g:unite_source_history_yank_enable =1  "history/yankの有効化
    nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
endif
"}}}

" vimfiler {{{
" ==============================================================================
if s:has_plugin('vimfiler')
    let g:vimfiler_as_default_explorer = 1
    "セーフモードを無効にした状態で起動する
    let g:vimfiler_safe_mode_by_default = 0

    nnoremap [VIMFILER] <Nop>
    nmap <Leader>f [VIMFILER]
    nnoremap <silent> [VIMFILER]<CR> :VimFiler<CR>
    nnoremap <silent> [VIMFILER]c :VimFilerCurrentDir<CR>
endif
"}}}

" vimshell {{{
" ==============================================================================
if s:has_plugin('vimshell')
    nnoremap [VIMSHELL] <Nop>
    nmap <leader>H [VIMSHELL]
    nnoremap <silent> [VIMSHELL]<CR>   :VimShell<CR>
    nnoremap          [VIMSHELL]i      :VimShellInteractive<Space>
    nnoremap <silent> [VIMSHELL]py     :VimShellInteractive python<CR>
    nnoremap <silent> [VIMSHELL]ph     :VimShellInteractive php<CR>
    nnoremap <silent> [VIMSHELL]rb     :VimShellInteractive irb<CR>
    nnoremap <silent> [VIMSHELL]s      :VimShellSendString<CR>
    " <Leader>ss: 非同期で開いたインタプリタに現在の行を評価させる
    "vmap <silent> <Leader>ss :VimShellSendString<CR>
    "" 選択中に<Leader>ss: 非同期で開いたインタプリタに選択行を評価させる
    "nnoremap <silent> <Leader>ss <S-v>:VimShellSendString<CR>
endif

augroup vimshell
  autocmd!
  autocmd Filetype vimshell setlocal nonumber
augroup END

" }}}

" neocomplcache {{{
" ==============================================================================
if s:has_plugin('vimshell') && v:version >= 702
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Use camel case completion.
    let g:neocomplcache_enable_camel_case_completion = 0
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
    "imap <C-k>     <Plug>(neocomplcache_snippets_expand_or_jump)
    smap <C-k>     <Plug>(neocomplcache_snippets_expand)
    "smap <C-k>     <Plug>(neocomplcache_snippets_expand_or_jump)
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

    " Shell like behavior(my setting)
    " complet_common_stringではsmartcaseが効かない
    " 余計な候補を出して欲しくないので
    " set g:neocomplcache_enable_smart_case = 0と上のほうで設定しておく
    " <TAB>で上で設定したneocomplcache#complete_common_string()を呼び出す
    "imap <expr><TAB>  pumvisible() ? "\<C-l>" : "\<TAB>"
    "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

    " Enable omni completion.
    autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType php           setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
    autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c    = '\%(\.\|->\)\h\w*'
    let g:neocomplcache_omni_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
endif
"}}}

" vim-quickrun {{{
" ==============================================================================
if s:has_plugin('vim-quickrun')
    let g:quickrun_config = {}
    let g:quickrun_config.['_'] = {
                \   'runner'                    : 'vimproc',
                \   'runner/vimproc/updatetime' : 100
                \}

    " phpunit {{{
    " --------------------------------------------------------------------------
    " http://www.karakaram.com/quickrun-phpunit
    " http://nishigori.blogspot.jp/2011/08/neocomplcache-phpunit-snippet-tddbc-17.html
    augroup QuickRunPHPUnit
        autocmd!
        autocmd BufWinEnter,BufNewFile *Test.php setlocal filetype=php.phpunit
    augroup END

    let g:quickrun_config['php.phpunit'] = {
                \   'outputter/buffer/split' : '',
                \   'command'                : 'phpunit',
                \   'cmdopt'                 : '',
                \   'exec'                   : '%c %o %s'
                \}
    "}}}
endif
"}}}

" vim-emacscommandline {{{
" ==============================================================================
" これを設定しないとTera Termで<A-BS>, <A-C-H>が使えなかった
" has_pluginの中に入れるとなぜか設定できない
cmap <Esc><C-H> <Esc><BS>
"}}}

" sudo.vim {{{
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
"nmap <Leader>e :e sudo:%<CR><C-^>:bd<CR>
"nmap <Leader>w :w sudo:%<CR>
if s:has_plugin('sudo')
    "if filereadable(expand('~/.vim/bundle/Kwbd.vim/plugin/bclose.vim'))
    if s:has_plugin('bclose')
        nmap <Leader>se :e sudo:%<CR><C-^><Plug>Kwbd
    else
        nnoremap <Leader>se :e sudo:%<CR><C-^>:bd<CR>
    endif
    nnoremap <Leader>sw :w sudo:%<CR>
endif
"}}}

" YankRing.vim {{{
" ==============================================================================
if s:has_plugin('yankring.vim')
    let g:yankring_manual_clipboard_check = 0
endif
"}}}

" minibufexpl.vim {{{
" ==============================================================================
if s:has_plugin('minibufexpl')
    " Put new window below current or on the right for vertical split
    let g:miniBufExplSplitBelow=1
"function! Md()
"    return expand("%:p")
"    "echo "a"
"    "set paste
"endfunction
""let g:statusLineText = "-MiniBufExplorer-" . Md()
"let g:statusLineText = Md()
endif
"}}}

" vim-powerline{{{
" ==============================================================================
if s:has_plugin('Powerline')
    let g:Powerline_dividers_override = ['>>', '>', '<<', '<']
    "let g:Powerline_theme = 'skwp'
    "let g:Powerline_colorscheme = 'skwp'
    "let g:Powerline_colorscheme = 'default_customized'
    "let g:Powerline_stl_path_style = 'short'
    "let g:Powerline_symbols = 'fancy'
    "call Pl#Theme#InsertSegment('charcode', 'after', 'filetype')
    "call Pl#Theme#InsertSegment('', 'after', 'filetype')
    "call Pl#Hi#Segments(['SPLIT'], {
    "		\ 'n': ['white', 'gray2'],
    "		\ 'N': ['white', 'gray0'],
    "		\ 'i': ['white', 'gray0'],
    "		\ }),
endif
"}}}

" <<<< Plugin <<<< }}}

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
