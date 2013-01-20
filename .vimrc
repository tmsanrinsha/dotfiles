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
    NeoBundle 'Shougo/unite-ssh'
    "NeoBundle 'Shougo/unite-sudo'
    NeoBundle 'h1mesuke/unite-outline'
    NeoBundle 'Shougo/vimfiler'
    NeoBundle 'Shougo/vimshell'
    NeoBundleLazy 'Shougo/vimshell', {
                \   'autoload' : { 'commands' : [ 'VimShell', "VimShellBufferDir", "VimShellInteractive" ] }
                \}

    " 補完候補の自動表示
    NeoBundle 'Shougo/neocomplcache'
    " スニペット補完
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'honza/snipmate-snippets'

    " http://archiva.jp/web/tool/vim_grep2.html
    NeoBundle 'thinca/vim-qfreplace'

    NeoBundleLazy 'thinca/vim-quickrun', {
                \   'autoload' : { 'commands' : [ 'QuickRun' ] }
                \}

    " 部分的に別バッファで編集
    NeoBundleLazy 'thinca/vim-partedit', {
                \   'autoload' : { 'commands' : [ 'Partedit' ] }
                \}

    " Vimperatorのクイックヒント風にカーソル移動
    NeoBundle 'Lokaltog/vim-easymotion'

    " ファイルを保存時にシンタックスのチェック
    " https://github.com/scrooloose/syntastic
    NeoBundle 'scrooloose/syntastic'

    NeoBundle 'kana/vim-textobj-user'
    NeoBundle 'kana/vim-textobj-indent'

    "NeoBundle 'Align'
    NeoBundle 'h1mesuke/vim-alignta'
    NeoBundle "tyru/caw.vim"

    " ミニバッファにバッファ一覧を表示
    " https://github.com/fholgado/minibufexpl.vim
    NeoBundle 'fholgado/minibufexpl.vim'

    " バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
    " https://github.com/rgarver/Kwbd.vim
    NeoBundle 'rgarver/Kwbd.vim'

    " ステータスラインをカスタマイズ
    " https://github.com/Lokaltog/vim-powerline
    NeoBundle 'Lokaltog/vim-powerline'

    " sudo権限でファイルを開く・保存
    " http://www.vim.org/scripts/script.php?script_id=729
    NeoBundle 'sudo.vim'

    " ヤンクの履歴を選択してペースト
    " http://www.vim.org/scripts/script.php?script_id=1234
    NeoBundle 'YankRing.vim'

    " colorscheme
    "NeoBundle 'tomasr/molokai'
    "NeoBundle 'vim-scripts/wombat256.vim'
    NeoBundle 'altercation/vim-colors-solarized'
    "NeoBundle 'chriskempson/vim-tomorrow-theme'
    " http://www.vim.org/scripts/script.php?script_id=1732
    "NeoBundle 'rdark'
    " http://www.vim.org/scripts/script.php?script_id=2536
    "NeoBundle 'jonathanfilip/vim-lucius'
    "let g:lucius_contrast_bg = 'high'

    " JavaScript
    NeoBundle 'pangloss/vim-javascript'
    NeoBundleLazy 'jelera/vim-javascript-syntax', {
                \     'autoload' : { 'filetypes' : 'javascript' }
                \ }
    NeoBundleLazy 'nono/jquery.vim', {
                \     'autolaad' : { 'filetypes' : 'jquery' }
                \ }

    " confluenceのシンタックスファイル
    NeoBundleLazy 'confluencewiki.vim', {
                \   'autoload' : { 'filetypes' : 'confluence' }
                \ }
    " tmuxのシンタックスファイル
    NeoBundle 'zaiste/tmux.vim', {
                \   'autoload' : { 'filetypes' : 'tmux' }
                \ }

    "
    "NeoBundle 'thinca/vim-showtime'
    "NeoBundle 'pocket7878/presen-vim'
    "NeoBundle 'mattn/multi-vim'

    " NeoBundle 'thinca/vim-ref', {'type' : 'nosync', 'rev' : '91fb1b' }
    "NeoBundle 'L9'
    "NeoBundle 'FuzzyFinder'
    "NeoBundle 'rails.vim'

    " 自分で修正したプラグイン
    " https://github.com/tmsanrinsha/vim
    NeoBundle 'tmsanrinsha/vim'

    " コマンドモードをEmacsキーバインドにする
    if hostname() =~ 'sakura'
        NeoBundle 'tmsanrinsha/vim-emacscommandline', { 'type__protocol' : 'ssh' }
    else
        NeoBundle 'tmsanrinsha/vim-emacscommandline'
    endif

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

" vimrc全体で使うaugroup {{{
" ==============================================================================
" http://rhysd.hatenablog.com/entry/2012/12/19/001145
" autocmd!の回数を減らすことでVimの起動を早くする
" ネームスペースを別にしたい場合は別途augroupを作る
augroup MyVimrc
    autocmd!
augroup END
" }}}

" 基本設定 {{{
" ==============================================================================
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set number
set ruler
set cursorline
set list listchars=tab:>-,trail:_ "タブと行末の空白の表示
set t_Co=256 " 256色
" pasteモードのトグル。autoindentをonにしてペーストすると
" インデントが入った文章が階段状になってしまう。
" pasteモードではautoindentが解除されそのままペーストできる
set pastetoggle=<F11>
" デフォルトの設定にある~/tmpを入れておくと、swpファイルが自分のホームディレクトリ以下に生成されてしまい、他の人が編集中か判断できなくなるので除く
set directory=.,/var/tmp,/tmp
" key mappingに対しては3000ミリ秒待ち、key codeに対しては10ミリ秒待つ
set timeout timeoutlen=3000 ttimeoutlen=10
set mouse=a

scriptencoding utf-8

inoremap jj <ESC>
nnoremap Y y$

"" アンドゥの履歴をファイルに保存し、Vim を一度終了したとしてもアンドゥやリドゥを行えるようにする
"if has('persistent_undo')
"    set undofile
"    if !isdirectory(expand('~/.vimundo'))
"        call mkdir(expand('~/.vimundo'))
"    endif
"    set undodir=~/.vimundo
"endif
" カラースキーム {{{
" ------------------------------------------------------------------------------
if s:has_plugin('molokai')
    colorscheme molokai
else
    colorscheme default
endif
"colorscheme molokai
"set background=dark
"let g:molokai_original = 1
"set background=light
"let g:solarized_termcolors=256
"colorscheme solarized

augroup colerscheme
    autocmd!
    " 修正
    "autocmd ColorScheme *
    "            \   highlight Normal              ctermbg=none
    "            \|  highlight Visual              ctermbg=27
    "            \|  highlight Folded  ctermfg=67  ctermbg=16
    "            \|  highlight Comment ctermfg=246 cterm=none               guifg=#9c998e gui=italic
    "            \|  highlight Todo    ctermfg=231 ctermbg=232   cterm=bold

    " 全角スペースをハイライト （Vimテクニックバイブル1-11）
    " scriptencoding utf-8が必要
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

" window {{{
" ==============================================================================
"nnoremap <M-h> <C-w>h
"nnoremap <M-j> <C-w>j
"nnoremap <M-k> <C-w>k
"nnoremap <M-l> <C-w>l
nnoremap <M--> <C-w>-
nnoremap <M-;> <C-w>+
nnoremap <M-,> <C-w>>
nnoremap <M-.> <C-w><
nnoremap <M-0> <C-w>=
nnoremap <C-w>; <C-w>p


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
"}}}

" カーソル {{{
" ==============================================================================
set virtualedit=block       " 矩形選択でカーソル位置の制限を解除

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
nnoremap <silent> [VIMDIFF]T :windo diffthis<CR> :diffo<CR> <C-w><C-w>
nnoremap <silent> [VIMDIFF]O :windo diffoff<CR> <C-w><C-w>
nnoremap <silent> [VIMDIFF]U :windo diffupdate<CR> <C-w><C-w>
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

"}}}

" vimrcの編集 {{{
" ==============================================================================
" http://vim-users.jp/2009/09/hack74/
" .vimrcと.gvimrcの編集
nnoremap [VIMRC] <Nop>
nmap <Leader>v [VIMRC]
nnoremap <silent> [VIMRC]e :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [VIMRC]E :<C-u>edit $MYGVIMRC<CR>

" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> [VIMRC]r :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif<CR>
nnoremap <silent> [VIMRC]R :<C-u>source $MYGVIMRC<CR>

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
    set fileencodings=ucs-boms,utf-8,euc-jp,cp932
endif

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
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

" Quickfix {{{
" ==============================================================================
" show quickfix automatically
augroup quickfix
    autocmd!
    "autocmd QuickfixCmdPost * if !empty(getqflist()) | cwindow | lwindow | endif
    "autocmd QuickfixCmdPost * cwindow | lwindow
augroup END
"}}}

" >>>> filetype >>>> {{{

nnoremap <Leader>fp :<C-u>setlocal filetype=php<CR>
nnoremap <Leader>fj :<C-u>setlocal filetype=jquery.javascript-jquery.javascript<CR>
nnoremap <Leader>fh :<C-u>setlocal filetype=html<CR>

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
"augroup MyXML
"  autocmd!
"  autocmd Filetype xml  inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
"augroup END
"}}}
"}}}

" JavaScript {{{
" ==============================================================================
" nono/jqueryとhonza/snipmate-snippetsのjavaScript-jqueryを有効にするための設定
autocmd MyVimrc BufRead,BufNewFile *.js setlocal filetype=jquery.javascript-jquery.javascript
" }}}

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
autocmd MyVimrc BufRead /var/tmp/sql* setlocal filetype=mysql
"}}}

" apache {{{
" ==============================================================================
autocmd MyVimrc BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache
"}}}

" help {{{
" ==============================================================================
set helplang=en,ja
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :q<CR>
"}}}

" <<<< filetype <<<< }}}

" >>>> Plugin >>>> {{{
" unite {{{
" ==============================================================================
nnoremap [unite] <Nop>
nmap , [unite]

" カレントディレクトリ以下のファイル
nnoremap <silent> [unite]f :<C-u>Unite file_rec<CR>
" カレントディレクトリ以下のディレクトリ
nnoremap <silent> [unite]d :<C-u>Unite directory<CR>
call unite#custom_default_action('source/directory/directory' , 'vimfiler')
" バッファ
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"最近使用したディレクトリ一覧
nnoremap <silent> [unite]M :<C-u>Unite directory_mru<CR>
call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')
" ブックマーク
nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>
call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
" ファイル内検索結果
nnoremap <silent> [unite]l :<C-u>Unite line<CR>
" ヤンク履歴
let g:unite_source_history_yank_enable = 1  "history/yankの有効化
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>

let g:unite_source_grep_max_candidates = 1000
"}}}

" vimfiler {{{
" ==============================================================================
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0

nnoremap [VIMFILER] <Nop>
nmap <Leader>f [VIMFILER]
nnoremap <silent> [VIMFILER]f :VimFiler<CR>
nnoremap <silent> [VIMFILER]b    :VimFilerBufferDir<CR>
nnoremap <silent> [VIMFILER]c    :VimFilerCurrentDir<CR>
"}}}

" vimshell {{{
" ==============================================================================
nnoremap [VIMSHELL] <Nop>
nmap <leader>H [VIMSHELL]
nnoremap <silent> [VIMSHELL]H  :VimShell<CR>
nnoremap <silent> [VIMSHELL]b  :VimShellBufferDir<CR>
nnoremap          [VIMSHELL]i  :VimShellInteractive<Space>
nnoremap <silent> [VIMSHELL]py :VimShellInteractive python<CR>
nnoremap <silent> [VIMSHELL]ph :VimShellInteractive php<CR>
nnoremap <silent> [VIMSHELL]rb :VimShellInteractive irb<CR>
nnoremap <silent> [VIMSHELL]s  :VimShellSendString<CR>
" <Leader>ss: 非同期で開いたインタプリタに現在の行を評価させる
"vmap <silent> <Leader>ss :VimShellSendString<CR>
"" 選択中に<Leader>ss: 非同期で開いたインタプリタに選択行を評価させる
"nnoremap <silent> <Leader>ss <S-v>:VimShellSendString<CR>

if has('win32') || has('win64')
    " Display user name on Windows.
    let g:vimshell_prompt = $USERNAME."% "
else
    "let g:vimshell_prompt = $USER . "@" . hostname() . "% "
    let g:vimshell_prompt = hostname() . "% "
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    if has('mac')
        call vimshell#set_execute_file('html', 'gexe open -a /Applications/Firefox.app/Contents/MacOS/firefox')
        call vimshell#set_execute_file('avi,mp4,mpg,ogm,mkv,wmv,mov', 'gexe open -a /Applications/MPlayerX.app/Contents/MacOS/MPlayerX')
    endif
endif
"let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b] ", "(%s)-[%b|%a] ") . "[" . getcwd() . "]"'
let g:vimshell_max_command_history = 3000

autocmd MyVimrc FileType vimshell
            \   setlocal nonumber
            \|  call vimshell#altercmd#define('g', 'git')
            \|  call vimshell#altercmd#define('l', 'll')
            \|  call vimshell#altercmd#define('ll', 'ls -l')
            \|  call vimshell#altercmd#define('la', 'ls -a')
            \|  call vimshell#altercmd#define('lla', 'ls -la')
"\|  call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
"function! g:my_chpwd(args, context)
"    call vimshell#execute('ls')
"endfunction

" 参考
" http://d.hatena.ne.jp/joker1007/20111018/1318950377
" }}}

" neocomplcache {{{
" ==============================================================================
if s:has_plugin('neocomplcache') && v:version >= 702
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Use camel case completion.
    let g:neocomplcache_enable_camel_case_completion = 0
    " Use underbar completion.
    let g:neocomplcache_enable_underbar_completion = 0
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
                \ 'default'  : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme'   : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-l>     neocomplcache#complete_common_string()

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
    augroup neocomplcache
        autocmd!
        autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType php           setlocal omnifunc=phpcomplete#CompletePHP
        autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
        autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
    augroup END

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c    = '\%(\.\|->\)\h\w*'
    let g:neocomplcache_omni_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neocomplcache_snippets_expand)
    smap <C-k>     <Plug>(neocomplcache_snippets_expand)

    " Plugin key-mappings.
    " imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    " smap <C-k>     <Plug>(neosnippet_expand_or_jump)

    " SuperTab like snippets behavior.
    "imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
    "smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif

    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/snipmate-snippets/snippets'
endif
"}}}

" vim-quickrun {{{
" ==============================================================================
nnoremap <Leader>r :QuickRun<CR>
vnoremap <Leader>r :QuickRun<CR>

let g:quickrun_config = {}
let g:quickrun_config['_'] = {
            \   'runner'                    : 'vimproc',
            \   'runner/vimproc/updatetime' : 100,
            \   'outputter/buffer/split'    : ''
            \}

" phpunit {{{
" --------------------------------------------------------------------------
" http://www.karakaram.com/quickrun-phpunit
" http://nishigori.blogspot.jp/2011/08/neocomplcache-phpunit-snippet-tddbc-17.html
autocmd MyVimrc BufWinEnter,BufNewFile *Test.php setlocal filetype=php.phpunit

let g:quickrun_config['php.phpunit'] = {
            \   'command'                : 'phpunit',
            \   'cmdopt'                 : '',
            \   'exec'                   : '%c %o %s'
            \}
"}}}
"}}}

" vim-partedit {{{
" =============================================================================
if s:has_plugin('vim-partedit')
    let g:partedit#auto_prefix = 0
endif
"}}}

" vim-easymotion {{{
" ==============================================================================
if s:has_plugin('EasyMotion')
    "let g:EasyMotion_leader_key = '<Leader>'
    let g:EasyMotion_keys = 'asdfgghjkl;:qwertyuiop@zxcvbnm,./1234567890-'
    let g:EasyMotion_mapping_f = '+'
    let g:EasyMotion_mapping_F = '-'
endif
"}}}

" vim-alignta {{{
" ==============================================================================
if s:has_plugin('alignta')
    xnoremap [ALINGTA] <Nop>
    xmap <Leader>a [ALINGTA]
    xnoremap [ALINGTA]= :Alignta =<CR>
    xnoremap [ALINGTA]> :Alignta =><CR>
    xnoremap [ALINGTA]: :Alignta :<CR>
endif
" }}}

" caw {{{
" ==============================================================================
" http://d.hatena.ne.jp/osyo-manga/20120106/1325815224
if s:has_plugin('caw')
    " コメントアウトのトグル
    nmap <Leader>cc <Plug>(caw:i:toggle)
    xmap <Leader>cc <Plug>(caw:i:toggle)
    " http://d.hatena.ne.jp/osyo-manga/20120303/1330731434
    " 現在の行をコメントアウトして下にコピー
    nmap <Leader>cy yyPgcij
    xmap <Leader>cy ygvgcigv<C-c>p
endif
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

if !has('gui_running') && filereadable(expand('~/.cvimrc'))
    source ~/.cvimrc
endif

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
