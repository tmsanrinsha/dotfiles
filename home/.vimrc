set encoding=utf-8
scriptencoding utf-8
" vimrcでマルチバイト文字を使うためにscriptencodingを設定する。
" この時、set encodingはscriptencodingより先に宣言する。
" vimrcやgvimrcがあると自動的にset nocompatibleになるので、set nocompatibleは書かない。
" 書くとオプションhistoryが初期化され、履歴が削除されてしまう。
"   vim -u <vimの設定ファイル>
" のように指定して起動すると、set nocompatibleにならないので、
"   vim -u <vimの設定ファイル> -N
" のように-Nオプションを付けて起動する
" cf. vimrcアンチパターン - rbtnn雑記
"     http://rbtnn.hateblo.jp/entry/2014/11/30/174749
" 初期設定 {{{1
" ============================================================================
let $VIMDIR = expand('~/.vim')
let $VIMRC_DIR = $VIMDIR . '/rc'
let $VIM_CACHE_DIR = expand('~/.cache/vim')
if !isdirectory($VIM_CACHE_DIR)
    call mkdir($VIM_CACHE_DIR, 'p')
endif

if has('win32')
    set runtimepath&
    set runtimepath^=$HOME/.vim
    set runtimepath+=$HOME/.vim/after
    cd ~
endif

" function {{{1
" ============================================================================
function! SourceRc(path) " {{{
    if filereadable(expand('$VIMRC_DIR/'.a:path))
        execute 'source $VIMRC_DIR/'.a:path
    endif
endfunction " }}}
function! MyHasPatch(str) " {{{
    if has('patch-7.4.237')
        return has(a:str)
    else
        let l:patches =  split(matchstr(a:str, '\v(\d|\.)+'), '\.')
        return v:version >  l:patches[0] . 0 . l:patches[1] ||
            \  v:version == l:patches[0] . 0 . l:patches[1] && has('patch' . l:patches[2])
    endif
endfunction " }}}
function! MyIsRuning(str) " {{{
    if executable('pgrep')
        return system('pgrep '.a:str) || 0
    endif
    return 0
endfunction " }}}
"" バッファ名nameを持つウィンドウに移動する {{{
function! GotoWin(name)
    let l:nr = bufwinnr(a:name)
    if l:nr > 0
        execute l:nr . 'wincmd w'
    endif
    return l:nr
endfunction " }}}
function! IsInstalled(plugin) " {{{
    " NeoBundleLazyを使うと最初はruntimepathに含まれないため、
    " runtimepathのチェックでプラグインがインストールされているかをチェックできない
    " neobundle#is_installedを直接使うとneobundleがない場合にエラーが出るので確認
    if exists('*neobundle#is_installed')
        return neobundle#is_installed(a:plugin)
    else
        " runtimepathにあるか
        " http://yomi322.hateblo.jp/entry/2012/06/20/225559
        " return !empty(globpath(&runtimepath, 'plugin/'   . a:plugin . '.vim'))
        " \   || !empty(globpath(&runtimepath, 'autoload/' . a:plugin . '.vim'))
        " \   || !empty(globpath(&runtimepath, 'colors/'   . a:plugin . '.vim'))
        return match(&runtimepath, a:plugin) >= 0
    endif
endfunction " }}}

" vimrc全体で使うaugroup {{{1
" ============================================================================
" http://rhysd.hatenablog.com/entry/2012/12/19/001145
" autocmd!の回数を減らすことでVimの起動を早くする
" ネームスペースを別にしたい場合は別途augroupを作る
augroup MyVimrc
    autocmd!
augroup END
" }}}

call SourceRc('local_pre.vim')
call SourceRc('bundle.vim')

" 基本設定 {{{
" ============================================================================
set showmode "現在のモードを表示
set showcmd  "コマンドを表示
set cmdheight=2 "コマンドラインの高さを2行にする
set number   " 左側に行数を表示
set display=lastline " 1行が長い場合でも表示
set ruler

set showmatch matchtime=1 "括弧の対応
set matchpairs& matchpairs+=<:>
" 7.3.769からmatchpairsにマルチバイト文字が使える
if MyHasPatch('patch-7.3.769')
    set matchpairs+=（:）,「:」
endif

runtime macros/matchit.vim

" ビジュアルベルにして、設定を空にすることで、ビープ音もビジュアルベルも無効化
set visualbell t_vt=

" CTRL-AやCTRL-Xを使った時の文字の増減の設定
" alpha アルファベットの増減
" octal 8進数の増減
" hex   16進数の増減
" * アルファベットは増減させない
" * 0で始まる数字列を8進数とみなさず、10進数として増減させる。
" * 10進数と16進数を増減させる。
set nrformats=hex

"変更中のファイルでも、保存しないで他のファイルを表示
set hidden

set shellslash

" macに最初から入っているvimはセキュリティの問題からシステムのvimrcでset modelines=0している。
" http://unix.stackexchange.com/questions/19875/setting-vim-filetype-with-modeline-not-working-as-expected
" この問題は7.0.234と7.0.235のパッチで修正された
" https://bugzilla.redhat.com/show_bug.cgi?id=cve-2007-2438
if MyHasPatch('patch-7.0.234') && MyHasPatch('patch-7.0.235')
    set modelines&
else
    set modelines=0
endif

set mouse=a

" cursor {{{1
" ============================================================================
" backspaceキーの挙動を設定する
"   indent        : 行頭の空白の削除を許す
"   eol           : 改行の削除を許す
"   start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

" カーソルを行頭、行末で止まらないようにする。
set whichwrap&
" set whichwrap=b,s,h,l,<,>,[,],~
" " 矩形選択でカーソル位置の制限を解除
" set virtualedit=block

" encode, fileformat {{{1
" ============================================================================
" 文字コード
" set encoding=utf-8 上で設定
set fileencoding=utf-8

" ファイルのエンコードの判定を前から順番にする
" ファイルを読み込むときに 'fileencodings' が "ucs-bom" で始まるならば、
" BOM が存在するかどうかが調べられ、その結果に従って 'bomb' が設定される。
" http://vim-jp.org/vimdoc-ja/options.html#%27fileencoding%27
" 以下はVimテクニックバイブル「2-7ファイルの文字コードを変換する」に書いてあるfileencodings。
" ただし2つあるeuc-jpの2番目を消した
" if has("win32")
    " set fileencodings=iso-2222-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,eucjp-ms,cp932
" else
    " 上の設定はたまに誤判定をするので、UNIX上で開く可能性があるファイルのエンコードに限定
    " set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" endif

if has('guess_encode')
    set fileencodings=guess,ucs-boms,utf-8,euc-jp,cp932
else
    set fileencodings=ucs-boms,utf-8,euc-jp,cp932
endif

" エンコーディングを指定して開き直す
command! EncCp932     edit ++enc=cp932
command! EncEucjp     edit ++enc=euc-jp
command! EncIso2022jp edit ++enc=iso-2022-jp
command! EncUtf8      edit ++enc=uff-8
command! EncLatin1    edit ++enc=latin1
" alias
command! EncJis  EncIso2022jp
command! EncSjis EncCp932

" 改行
set fileformat=unix
set fileformats=unix,dos,mac
" 改行コードを指定して開き直すには
"  :e ++ff=dos
" などとする

" 最後に改行が無いテキストファイルに改行を付加しない
if exists('&fixeol')
    set nofixeol
endif

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double

command! DecodeUnicode %s/\\u\([0-9a-fA-Z]\{4}\|[0-9a-zA-Z]\{2}\)/\=nr2char(eval("0x".submatch(1)),1)/g

" tab, indent {{{1
" ==============================================================================
" ハードタブを表示させるときの幅
set tabstop=4
" 挿入モードで<Tab>を押したときにスペースに展開する
set expandtab
" タブを展開するときのスペースの数
set softtabstop=4

" インデントに使われる空白の数
set shiftwidth=4
" '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set shiftround

" http://vim-jp.org/vimdoc-ja/indent.html
" 後のものが有効にされると、前のものより優先される
set autoindent    " 一つ前の行に基づくインデント
set smartindent   " 'autoindent' と同様だが幾つかのC構文を認識し、適切な箇所のイン
                  " デントを増減させる。
" set cindent     " 他の2つの方法よりも賢く動作し、設定することで異なるインデント
                  " スタイルにも対応できる。

" 不可視文字の表示
set list
" set listchars=tab:»-,trail:_,extends:»,precedes:«,nbsp:%,eol:↲
set listchars=tab:»･,trail:･,nbsp:%

" autoindentなどがonの状態でペーストするとインデントが入った文章が階段状になってしまう。
" pasteモードではautoindentなどのオプションが解除されそのままペーストできるようになる。
" pasteモードのトグル
set pastetoggle=<F11>
" ターミナルで自動でpasteモードに変更する設定は.cvimrc参照

" format {{{1
" ==============================================================================
set textwidth=0

" :h fo-table
set formatoptions&
" r : Insert modeで<Enter>を押したら、comment leaderを挿入する
set formatoptions+=r
" M : マルチバイト文字の連結(J)でスペースを挿入しない
set formatoptions+=M
if MyHasPatch('patch-7.3.541') && MyHasPatch('patch-7.3.550')
    " j : コメント行の連結でcomment leaderを取り除く
    set formatoptions+=j
endif
" t : textwidthを使って自動的に折り返す
set formatoptions-=t
" c : textwidthを使って、コマントを自動的に折り返しcomment leaderを挿入する

set formatoptions-=c
" o : Normal modeでoまたOを押したら、comment leaderを挿入する
set formatoptions+=o

" mapping {{{
" ------------------------------------------------------------------------------
" :h map-modes
" gvimにAltのmappingをしたい場合は先にset encoding=...をしておく

" key mappingに対しては9000ミリ秒待ち、key codeに対しては20ミリ秒待つ
set timeout timeoutlen=9000 ttimeoutlen=20
if exists('+macmeta')
    " MacVimでMETAキーを使えるようにする
    set macmeta
endif
let g:mapleader = ';'
let g:maplocalleader = '\'

" prefix
" http://blog.bouzuya.net/2012/03/26/prefixedmap-vim/
" [:space:]でmapするようにするとVimFilerのスペースキーでキー待ちが発生しなくなる
nnoremap [:space:]   <Nop>
xnoremap [:space:]   <Nop>
nmap <Space> [:space:]
xmap <Space> [:space:]

" noremap ; :
" noremap : ;

nnoremap [Colon] :

inoremap jj <ESC>
"cnoremap jj <ESC>
nnoremap Y y$

" カーソルを表示行で移動する
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk
nnoremap <down> gj
xnoremap <down> gj
nnoremap <up> gk
xnoremap <up> gk
nnoremap 0 g0
xnoremap 0 g0
nnoremap $ g$
" これをやると<C-V>$Aできなくなる
" xnoremap $ g$
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k
nnoremap g0 0
xnoremap g0 0
nnoremap g$ $
xnoremap g$ $

"挿入モードのキーバインドをemacs風に
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
if !IsInstalled('lexima.vim')
    noremap <C-d> <Del>
endif

" 元々のi_CTRL-Dは左にインデントする処理。
" 右にインデントするのがi_CTRL-Tなので<M-t>に設定する
inoremap <M-t> <C-d>

" neocomplcacheにて設定
" inoremap <C-h> <BS>
" inoremap <C-n> <Down>
" inoremap <C-p> <Up>
" inoremap <C-e> <End>

if !IsInstalled('neosnippet.vim')
    inoremap <C-k> <C-o>D
endif

" * があるときに<Tab>を打つと右にインデントしたい
" →insertモードで<C-t>打つと右にインデントできる
" function! s:MyIndent()
"     if match(getline('.'), '^\s*\*') >= 0
"         normal! >>A
"     else
"         execute "normal! i\<Tab>"
"     endif
" endfunction
" command! MyIndent call s:MyIndent()

" inoremap <Tab> <C-o>:MyIndent<CR>

" インデントしない改行
" [vim-jp » Hack #57: 空行を挿入する](http://vim-jp.org/vim-users-jp/2009/08/15/Hack-57.html)
" [空行を挿入する+α - derisの日記](http://deris.hatenablog.jp/entry/20130404/1365086716)
nnoremap <silent><C-j> :<C-u>call append(expand('.'), '')<CR>ji

inoremap <silent><C-j> <C-o>o

nnoremap ]h /\vhttps?:\/\/<CR>
nnoremap [h ?\vhttps\?://<CR>

nnoremap ]p p`[v`]=
nnoremap ]P P`[v`]=

" インデントを考慮したペースト]p,]Pとペーストしたテキストの最後に行くペーストgp,gPを合わせたようなもの
" nnoremap ]gp ]p`]j
" nnoremap ]gP ]P`]j

" inoremap <expr> <C-d> "\<C-g>u".(col('.') == col('$') ? '<Esc>^y$A<Space>=<Space><C-r>=<C-r>"<CR>' : '<Del>')
" inoremap <Leader>= <Esc>^y$A<Space>=<Space><C-r>=<C-r>"<CR>
" }}}
" swap, backup, undo {{{1
" ==============================================================================
" updatetimeを短くして、CursorHoldに使うので
" swap fileがupdatetimeごとに作成されないようにする
set noswapfile

"" デフォルトの設定にある~/tmpを入れておくと、swapファイルが自分のホームディレクトリ以下に生成されてしまい、他の人が編集中か判断できなくなるので除く
""   set directory&
""   set directory-=~/tmp
""   " 他の人が編集する可能性がない場合はswapファイルを作成しない
""   if has('win32') || has('mac')
""       set noswapfile
""   endif

" FreeBSD, Macでcrontab -eしたときに
"   crontab: temp file must be edited in place
" というエラーが出てcrontabが更新されないときの対策
" [crontabをVimで編集した時に出るエラーの対処法](http://sanrinsha.lolipop.jp/blog/2013/03/post-10825.html)
set backupskip&
set backupskip+=/home/tmp/*,/private/tmp/*

" 富豪的バックアップ
" http://d.hatena.ne.jp/viver/20090723/p1
" http://synpey.net/?p=127
" savevers.vimが場合はそちらを使う
if ! isdirectory(expand('~/.vim/bundle/savevers.vim'))
    set backup
    set backupdir=$VIM_CACHE_DIR/backup

    augroup backup
        autocmd!
        autocmd BufWritePre,FileWritePre,FileAppendPre * call UpdateBackupFile()
        function! UpdateBackupFile()
            let l:basedir = expand('$VIM_CACHE_DIR/backup')
            let l:dir = strftime(l:basedir.'/%Y%m/%d', localtime()).substitute(expand('%:p:h'), '\v\c^([a-z]):', '/\1/' , '')
            if !isdirectory(l:dir)
                call mkdir(l:dir, 'p')
            endif

            let l:dir = escape(l:dir, ' ')
            exe 'set backupdir='.l:dir
            let l:time = strftime('%H-%M', localtime())

            execute 'set backupext=.'.l:time
        endfunction
    augroup END
endif

" アンドゥの履歴をファイルに保存し、Vim を一度終了したとしてもアンドゥやリドゥを行えるようにする
" 開いた時に前回保存時と内容が違う場合はリセットされる
if has('persistent_undo')
    set undofile
    if !isdirectory($VIM_CACHE_DIR.'/undo')
        call mkdir($VIM_CACHE_DIR.'/undo', 'p')
    endif
    set undodir=$VIM_CACHE_DIR/undo
endif

" 前回のカーソル位置にジャンプ
" Always Jump to the Last Known Cursor Position
autocmd MyVimrc BufReadPost *
            \ if line("`\"") > 1 && line("`\"") <= line("$") |
            \   execute "normal! g`\"" |
            \ endif

" optionsを設定するとおかしくなる
set sessionoptions-=options
autocmd MyVimrc VimLeavePre * call s:save_session()

function! s:save_session()
    if !empty(expand('%'))
        mksession! $VIM_CACHE_DIR/session.vim 
    endif
endfunction

" statusline {{{1
" ==============================================================================
" 最下ウィンドウにいつステータス行が表示されるかを設定する。
" 0: 全く表示しない
" 1: ウィンドウの数が2以上のときのみ表示
" 2: 常に表示
set laststatus=2

" lightline.vimで設定
" set statusline=%f%=%m%r[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l]\ %P
" set statusline=%f%=%<%m%r[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l/%L]

" titlestring {{{1
" ============================================================================
set title
let &titlestring = "%{expand('%:p')} @" . hostname()

" tmux使用時もtitlestringを変更できるように設定する
if &term ==# 'screen'
    let &t_ts = "\ePtmux;\e\e]2;"
    let &t_fs = "\007\e\\"
endif

" window {{{1
" ==============================================================================
"nnoremap <M-h> <C-w>h
"nnoremap <M-j> <C-w>j
"nnoremap <M-k> <C-w>k
"nnoremap <M-l> <C-w>l
nnoremap <M--> <C-w>-
nnoremap <M-+> <C-w>+
nnoremap <M-,> <C-w><
nnoremap <M-.> <C-w>>
nnoremap <M-0> <C-w>=
nnoremap <C-w><C-w> <C-w>p

set splitbelow
set splitright

" 常にカーソル行を真ん中にする場合は999など
set scrolloff=1

"縦分割されたウィンドウのスクロールを同期させる
"同期させたいウィンドウ上で<F12>を押せばおｋ
"解除はもう一度<F12>を押す
"横スクロールも同期させたい場合はこちら
"http://ogawa.s18.xrea.com/fswiki/wiki.cgi?page=Vim%A4%CE%A5%E1%A5%E2
"nnoremap <F12> :set scrollbind!<CR>
"}}}
" tab {{{
" ==============================================================================
"  いつタブページのラベルを表示するかを指定する。
"  0: 表示しない
"  1: 2個以上のタブページがあるときのみ表示
"  2: 常に表示
set showtabline=1

nnoremap [TAB] <Nop>
nmap <Leader>t [TAB]
" 一番右にタブを作る
" nnoremap <M-t> :tablast <Bar> tabnew<CR>
nnoremap <M-t> :tabnew<CR>
nnoremap <M-T> :tabnew %<CR>
nnoremap [TAB]q :tabclose<CR>

nnoremap <C-Tab> :tabn<CR>
nnoremap <S-C-Tab> :tabp<CR>

nnoremap [TAB]n :tabn<CR>
nnoremap [TAB]p :tabp<CR>

nnoremap <M-n> :tabn<CR>
nnoremap <M-p> :tabp<CR>
nnoremap <M-1> :1tabn<CR>
nnoremap <M-2> :2tabn<CR>
nnoremap <M-3> :3tabn<CR>
nnoremap <M-4> :4tabn<CR>
nnoremap <M-5> :5tabn<CR>
nnoremap <M-6> :6tabn<CR>
nnoremap <M-7> :7tabn<CR>
nnoremap <M-8> :8tabn<CR>
nnoremap <M-9> :9tabn<CR>
nnoremap <M-0> :10tabn<CR>
nnoremap [TAB]1 :1tabn<CR>
nnoremap [TAB]2 :2tabn<CR>
nnoremap [TAB]3 :3tabn<CR>
nnoremap [TAB]4 :4tabn<CR>
nnoremap [TAB]5 :5tabn<CR>
nnoremap [TAB]6 :6tabn<CR>
nnoremap [TAB]7 :7tabn<CR>
nnoremap [TAB]8 :8tabn<CR>
nnoremap [TAB]9 :9tabn<CR>
nnoremap [TAB]0 :10tabn<CR>
"}}}
" Command-line mode {{{
" ==============================================================================
" 補完 {{{
" ------------------------------------------------------------------------------
set wildmenu "コマンド入力時にTabを押すと補完メニューを表示する

" コマンドモードの補完をシェルコマンドの補完のようにする
" http://vim-jp.org/vimdoc-ja/options.html#%27wildmode%27
" <TAB>で共通する最長の文字列まで補完して一覧表示
" 再度<Tab>を打つと候補を選択。<S-Tab>で逆
set wildmode=list:longest,full
"}}}

"前方一致をCtrl+PとCtrl+Nで
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>
cnoremap <UP> <C-P>
cnoremap <DOWN> <C-N>

" vim-emacscommandlineで<C-F>は右に進むになっているので、
" コマンドラインウィンドウを開きたいときは<C-Space>にする
cnoremap <C-Space> <C-F>

set history=10000 "保存する履歴の数

" 外部コマンド実行でエイリアスを使うための設定
" http://sanrinsha.lolipop.jp/blog/2013/09/vim-alias.html
" bashスクリプトをquickrunで実行した時にエイリアス展開されてしまうのでコメント
" アウト
" let $BASH_ENV=expand('~/.bashenv')
" let $ZDOTDIR=expand('~/.vim/')
" }}}
" cmdline-window {{{
" ==============================================================================
" http://vim-users.jp/2010/07/hack161/
" nnoremap <sid>(command-line-enter) q:
" xnoremap <sid>(command-line-enter) q:
" nnoremap <sid>(command-line-norange) q:<C-u>
"
" nmap :  <sid>(command-line-enter)
" xmap :  <sid>(command-line-enter)

autocmd MyVimrc CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin()
    nnoremap <buffer> q :<C-u>quit<CR>
    nnoremap <buffer> <TAB> :<C-u>quit<CR>
    inoremap <buffer><expr><CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
    " inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
    " inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"

    " Completion.
    inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <buffer><expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-x>\<C-l>"

    startinsert!
endfunction
" }}}
" search/substitute {{{1
" ==============================================================================
set incsearch
set ignorecase "検索パターンの大文字小文字を区別しない
set smartcase  "検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch   "検索結果をハイライト

" ESCキー2度押しでハイライトのトグル
nnoremap <Esc><Esc> :set hlsearch!<CR>

nnoremap * *N
nnoremap # g*N

" function! s:RegistSearchWord()
"     silent normal yiw
"     let @/ = '\<'.@".'\>'
" endfunction
"
" command! -range RegistSearchWord :call s:RegistSearchWord()
" nnoremap <silent> * :RegistSearchWord<CR>

" /で検索しても、?で検索してもnで前方検索、Nで後方検索
" http://deris.hatenablog.jp/entry/2014/05/20/235807
nnoremap <expr> n <SID>search_forward_p() ? 'n' : 'N'
nnoremap <expr> N <SID>search_forward_p() ? 'N' : 'n'
vnoremap <expr> n <SID>search_forward_p() ? 'n' : 'N'
vnoremap <expr> N <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
    return exists('v:searchforward') ? v:searchforward : 1
endfunction

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
cnoremap <expr> \/ getcmdtype() == '/' ? '/'  : '\/'
cnoremap <expr> \? getcmdtype() == '?' ? '?'  : '\?'

"ヴィビュアルモードで選択した範囲だけ検索
xnoremap <Leader>/ <ESC>/\%V
xnoremap <Leader>? <ESC>?\%V

" ビジュアルモード {{{1
" =============================================================================
" ビジュアル矩形モードでなくても、IやAで挿入できるようにする {{{
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
" 最後に変更したテキスト（ペーストした部分など）を選択
" ----------------------------------------------------------------------------
nnoremap gm `[v`]
vnoremap gm :<C-u>normal gm<CR>
onoremap gm :<C-u>normal gm<CR>
"}}}
"}}}
" diretory, path {{{1
" ==============================================================================
"augroup CD
"    autocmd!
"    autocmd BufEnter * execute ":lcd " . expand("%:p:h")
"augroup END
" 現在編集中のファイルのディレクトリをカレントディレクトリにする
nnoremap <silent><Leader>gc :cd %:h<CR>
command! Shell lcd %:h <Bar> shell

" <C-r>%で%の内容を挿入できる
" file name
inoremap <C-r>f <C-r>=expand("%:t")<CR>
cnoremap <C-r>f <C-r>=expand("%:t")<CR>
" full path of file
inoremap <C-r>F <C-r>=expand('%:p')<CR>
cnoremap <C-r>F <C-r>=expand('%:p')<CR>
" full path of directory
inoremap <C-r>d <C-r>=expand('%:p:h')<CR>/
cnoremap <C-r>d <C-r>=expand('%:p:h')<CR>/

" yank file name
nnoremap yf :let @" = expand("%:t")<CR>
" yank full path of file
nnoremap yF :let @" = expand('%:p')<CR>
" yank full path of directory
nnoremap yd :let @" = expand('%:p:h')<CR>

" copy full path of file
nnoremap [:space:]yp :let @* = expand('%:p')<CR>
" copy full path of directory
nnoremap [:space:]yd :let @* = expand('%:p:h')<CR>
" copy file name
nnoremap [:space:]yf :let @* = expand("%:t")<CR>

" Vim-users.jp - Hack #17: Vimを終了することなく編集中ファイルのファイル名を変更する {{{2
" http://vim-users.jp/2009/05/hack17/
" command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
" 上のコマンドだとパーミッションは引き継がれないので、mvで処理するようにする。
command! -nargs=1 -complete=file Rename call s:move(expand('%'), '<args>')
function! s:move(src, dest)
    call system('mv '.a:src.' '.a:dest)
    execute 'e '.a:dest
    bdelete #
endfunction


" Vim-users.jp - Hack #202: 自動的にディレクトリを作成する <http://vim-users.jp/2011/02/hack202/> {{{2
autocmd MyVimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
        \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction

" cdr {{{2
" ----------------------------------------------------------------------------
if IsInstalled('vital.vim')
    let g:recent_dirs_file = $ZDOTDIR.'/.cache/chpwd-recent-dirs'
    augroup cdr
        autocmd!
        autocmd BufEnter * call s:update_cdr(expand('%:p:h'))
    augroup END

    function! s:update_cdr(dir)
        " .gitなどのdirectoryは書き込まない
        let l:ignore_pattern = '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
        \   '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'

        if !isdirectory(a:dir) || a:dir =~ l:ignore_pattern
            return
        end

        if filereadable(g:recent_dirs_file)
            let l:recent_dirs = readfile(g:recent_dirs_file)
            call insert(l:recent_dirs, "$'".a:dir."'", 0)
            let l:V = vital#of('vital')
            let l:List = l:V.import('Data.List')
            let l:recent_dirs = l:List.uniq(l:recent_dirs)
            call writefile(l:recent_dirs, g:recent_dirs_file)
        endif
    endfunction
endif

" vimdiff {{{1
" ============================================================================
set diffopt+=vertical
nnoremap [VIMDIFF] <Nop>
nmap <Leader>d [VIMDIFF]
nnoremap <silent> [VIMDIFF]t :diffthis<CR>
nnoremap <silent> [VIMDIFF]u :diffupdate<CR>
nnoremap <silent> [VIMDIFF]o :diffoff<CR>
nnoremap <silent> [VIMDIFF]T :windo diffthis<CR>
nnoremap <silent> [VIMDIFF]O :windo diffoff<CR>
nnoremap          [VIMDIFF]s :vertical diffsplit<space>
nnoremap          [VIMDIFF]w :set diffopt+=iwhite<CR>
nnoremap          [VIMDIFF]W :set diffopt-=iwhite<CR>

" diffchar.vim {{{2
" ----------------------------------------------------------------------------
" vimdiffで単語単位の差分表示: diffchar.vimが超便利 - Qiita
" http://qiita.com/takaakikasai/items/0d617b6e0aed490dff35
if IsInstalled('diffchar.vim')
    let g:DiffUnit='Word3'
    " vimdiffで起動した時にdiffcharを有効にする
    if &diff
        autocmd MyVimrc VimEnter * %SDChar
    endif

    " Gdiff使った時に自動的にdiffcharを有効にしたかったが、エラーが出るため断念
    " autocmd MyVimrc BufEnter *
    " \   if &diff |
    " \       execute '%SDChar' |
    " \   endif
endif

" ctags {{{1
" ============================================================================
if has('path_extra')
    set tags+=~/tags
endif

function! s:ctags(dir)
    call system('ctags -R -f ~/tags "'.fnamemodify(a:dir, ':p').'" &')
endfunction
command! -nargs=1 -complete=file Ctags call s:ctags('<args>')

" Gitリポジトリ以下のときに、保存するたびにctagsを実行 {{{2
" ----------------------------------------------------------------------------
" http://sanrinsha.lolipop.jp/blog/2014/04/git-hook-ctags.html
autocmd MyVimrc BufWritePost *
\ if exists('b:git_dir') && executable(b:git_dir.'/hooks/ctags') |
\   call system('"'.b:git_dir.'/hooks/ctags" &') |
\ endif

" tsukkee/unite-tag {{{2
" ----------------------------------------------------------------------------
nnoremap [unite]t :<C-u>Unite tag<CR>

let g:unite_source_tag_max_fname_length = 1000
let g:unite_source_tag_max_name_length = 100
let g:unite_source_tag_strict_truncate_string = 0

" helpやfiletypeがjavaのとき以外
" gitのhookで.git/tagsが生成されるように設定しておく
" [GitのhookでCtagsを実行する | SanRin舎](http://sanrinsha.lolipop.jp/blog/2014/04/git-hook-ctags.html)
autocmd MyVimrc FileType * call s:configure_tag()

function! s:configure_tag()
    if !empty(&buftype) || &filetype ==# 'java'
        return
    endif

    if &filetype ==# 'vim'
        " 引数が4つまでになるのは7.4.279以上
        " [Vim script言語仕様の変更 · rbtnn/vimscript Wiki](https://github.com/rbtnn/vimscript/wiki/Vim-script%E8%A8%80%E8%AA%9E%E4%BB%95%E6%A7%98%E3%81%AE%E5%A4%89%E6%9B%B4)
        " execute 'setlocal tags+='.join(globpath(&runtimepath, '.git/tags', 0, 1), ',')
        execute 'setlocal tags+='.substitute(globpath(&runtimepath, '.git/tags', 0), "\<NL>", ',', 'g')
    endif

    nnoremap <buffer> <C-]> :UniteWithCursorWord -immediately tag<CR>
endfunction

" tagsにその都度個別に追加する版 {{{3
" 全部tagsに追加しても遅くないのと#使ってないものが検索できないのでやめた
" " helpやfiletypeがjavaのとき以外
" " autocmd MyVimrc FileType *
" \   if empty(&buftype) && &filetype != 'java'
" \|      nnoremap <buffer> <C-]> :<C-u>MyUniteTag<CR>
" \|  endif
"
" function! s:
"     if &filetype == 'vim'
"         " quickrun#is_runnig()などの上で<C-]>したときにquickrunリポジトリ
"         " の.git/tagsをtagsに追加する。
"         let plugin_name = matchstr(expand('<cword>'), '[^#]\+\ze#')
"         if plugin_name != ''
"           " execute 'setlocal tags+='.substitute(globpath(&runtimepath, 'autoload/'.plugin_name.'.vim'), 'autoload/'.plugin_name.'.vim', '.git/tags', '')
"         endif
"     endif
"     UniteWithCursorWord -immediately tag
" endfunction
" command! MyUniteTag call s:
" }}}

" crypt {{{1
" ============================================================================
" [Using VIM as Your Password Manager - Stelfox Athenæum](http://stelfox.net/blog/2013/11/using-vim-as-your-password-manager/)
" 暗号化して保存するためには
"   :set cryptmethod=blowfish2 (Vim 7.4.399以前はblowfish)
"   :X
" set cryptmethod=blowfishは重いのでkeyがあるときのみ設定
autocmd MyVimrc BufReadPost *
\   if &key != ""
\|      setlocal noswapfile nowritebackup noshelltemp secure
\|  endif
" \|      setlocal cryptmethod=blowfish noswapfile nowritebackup noshelltemp secure

" man {{{1
" ==============================================================================
" * macでのManの調子が悪い
" * 補完がきかない
" のでvim-refの:Ref manを使うことにする (see: .vim/rc/plugin.vim)

" :Man <man>でマニュアルを開く
" http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
" [manをVimで見る - rcmdnk's blog](http://rcmdnk.github.io/blog/2014/07/20/computer-vim/)
" runtime ftplugin/man.vim
" nmap K <Leader>K
" let $PAGER=''
" コマンドラインでmanを使ったとき、vimの:Manで見るようにするためには
".zshrc .bashrc等にも記述が必要

" printing {{{1
" ==============================================================================
set printoptions=wrap:y,number:y,header:0
set printfont=Andale\ Mono:h12:cUTF8

" Quickfix {{{1
" ==============================================================================
nnoremap [Q :cprevious<CR>
nnoremap ]Q :cnext<CR>
noremap [*quickfix] <Nop>
nmap <Leader>q [*quickfix]
noremap [*quickfix]o :botright copen<CR>
noremap [*quickfix]q :cclose<CR>
nnoremap [L :<C-u>lprevious<CR>
nnoremap ]L :<C-u>lnext<CR>
noremap [*location] <Nop>
nmap <Leader>l [*location]
noremap [*location]o :lopen<CR>
noremap [*location]q :lclose<CR>

autocmd MyVimrc FileType qf
\   nnoremap <buffer> q :q<CR>

" 現在のカーソル位置の次/前のquickfix/location listに飛ぶにはQuickFixCurrentNumberを使う
" http://www.vim.org/scripts/script.php?script_id=4449

" show quickfix automatically {{{2
" ----------------------------------------------------------------------------
" これをやるとneocomlcacheの補完時にquickfix winodow（中身はtags）が開くのでコメントアウト
" autocmd MyVimrc QuickfixCmdPost * if !empty(getqflist()) | botright cwindow | botright lwindow | endif

" quickfixの高さを最初にする {{{2
" ----------------------------------------------------------------------------
" Automatically fitting a quickfix window height - Vim Tips Wiki
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
autocmd MyVimrc FileType qf call s:adjust_window_height(1, 10)
function! s:adjust_window_height(minheight, maxheight)
    let l:l = 1
    let l:n_lines = 0
    let l:w_width = winwidth(0)
    while l:l <= line('$')
        " number to float for division
        let l:l_len = strlen(getline(l:l)) + 0.0
        let l:line_width = l:l_len/l:w_width
        let l:n_lines += float2nr(ceil(l:line_width))
        let l:l += 1
    endw
    exe max([min([l:n_lines, a:maxheight]), a:minheight]) . 'wincmd _'
endfunction

" errorformatの確認のための関数 {{{2
" ----------------------------------------------------------------------------
" Vim - errorformatについて(入門編) - Qiita
" <http://qiita.com/rbtnn/items/92f80d53803ce756b4b8>
function! TestErrFmt(errfmt,lines)
    let l:temp_errorfomat = &errorformat
    try
        let &errorformat = a:errfmt
        cexpr join(a:lines,"\n")
        copen
    catch
        echo v:exception
        echo v:throwpoint
    finally
        let &errorformat = l:temp_errorfomat
    endtry
endfunction

" Ip2host {{{1
" ==============================================================================
function! s:Ip2host(line1, line2)
    for l:linenum in range(a:line1, a:line2)
        let l:oldline = getline(l:linenum)
        let l:newline = substitute(l:oldline,
                    \   '\v((%(2%([0-4]\d|5[0-5])|1\d\d|[1-9]?\d)\.){3}%(2%([0-4]\d|5[0-5])|1\d\d|[1-9]?\d))',
                    \   '\=substitute(system("nslookup ".submatch(1)), "\\v.*%(name = |:    )([0-9a-z-.]+).*", "\\1","")',
                    \   '')
        call setline(l:linenum, l:newline)
    endfor
endfunction

command! -range=% Ip2host call s:Ip2host(<line1>, <line2>)

" syntax highlight, colorscheme {{{1
" ============================================================================
set t_Co=256 " 256色
syntax enable

if IsInstalled('my_molokai')
    " let g:molokai_original = 1
    " let g:rehash256 = 1
    colorscheme molokai-customized
endif
" colorscheme molokai

let g:solarized_termcolors=256
" let g:solarized_contrast = "high"
" colorscheme solarized

" 16色の色見本
" :so $VIMRUNTIME/syntax/colortest.vim 
" 新しいウィンドウを開き、全てのハイライトグループ名をそれぞれの色を使って表示
" :so $VIMRUNTIME/syntax/hitest.vim

" カーソル以下のカラースキームの情報の取得 {{{2
" ----------------------------------------------------------------------------
" http://cohama.hateblo.jp/entry/2013/08/11/020849
function! s:get_syn_id(transparent)
    let l:synid = synID(line('.'), col('.'), 1)
    if a:transparent
        return synIDtrans(l:synid)
    else
        return l:synid
    endif
endfunction
function! s:get_syn_attr(synid)
    let l:name = synIDattr(a:synid, 'name')
    let l:ctermfg = synIDattr(a:synid, 'fg', 'cterm')
    let l:ctermbg = synIDattr(a:synid, 'bg', 'cterm')
    let l:guifg = synIDattr(a:synid, 'fg', 'gui')
    let l:guibg = synIDattr(a:synid, 'bg', 'gui')
    return {
    \   'name': l:name,
    \   'ctermfg': l:ctermfg,
    \   'ctermbg': l:ctermbg,
    \   'guifg': l:guifg,
    \   'guibg': l:guibg
    \}
endfunction
function! s:get_syn_info()
    let l:baseSyn = s:get_syn_attr(s:get_syn_id(0))
    echo 'name: ' . l:baseSyn.name .
    \   ' ctermfg: ' . l:baseSyn.ctermfg .
    \   ' ctermbg: ' . l:baseSyn.ctermbg .
    \   ' guifg: '   . l:baseSyn.guifg .
    \   ' guibg: '   . l:baseSyn.guibg
    let l:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
    echo 'link to'
    echo 'name: ' . l:linkedSyn.name .
    \ ' ctermfg: ' . l:linkedSyn.ctermfg .
    \ ' ctermbg: ' . l:linkedSyn.ctermbg .
    \ ' guifg: '   . l:linkedSyn.guifg .
    \ ' guibg: '   . l:linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
" }}}
" Rgb2xterm {{{2
" ----------------------------------------------------------------------------
" true color(#FF0000など)を一番近い256色の番号に変換する
" http://d.hatena.ne.jp/y_yanbe/20080611
"" the 6 value iterations in the xterm color cube
let s:valuerange = [ 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF ]

"" 16 basic colors
let s:basic16 = [ [ 0x00, 0x00, 0x00 ], [ 0xCD, 0x00, 0x00 ], [ 0x00, 0xCD, 0x00 ], [ 0xCD, 0xCD, 0x00 ], [ 0x00, 0x00, 0xEE ], [ 0xCD, 0x00, 0xCD ], [ 0x00, 0xCD, 0xCD ], [ 0xE5, 0xE5, 0xE5 ], [ 0x7F, 0x7F, 0x7F ], [ 0xFF, 0x00, 0x00 ], [ 0x00, 0xFF, 0x00 ], [ 0xFF, 0xFF, 0x00 ], [ 0x5C, 0x5C, 0xFF ], [ 0xFF, 0x00, 0xFF ], [ 0x00, 0xFF, 0xFF ], [ 0xFF, 0xFF, 0xFF ] ]

function! s:xterm2rgb(color)
    " 16 basic colors
    let l:r=0
    let l:g=0
    let l:b=0
    if a:color<16
        let l:r = s:basic16[a:color][0]
        let l:g = s:basic16[a:color][1]
        let l:b = s:basic16[a:color][2]
    endif

    " color cube color
    if a:color>=16 && a:color<=232
        let l:color=a:color-16
        let l:r = s:valuerange[(l:color/36)%6]
        let l:g = s:valuerange[(l:color/6)%6]
        let l:b = s:valuerange[l:color%6]
    endif

    " gray tone
    if a:color>=233 && a:color<=253
        let l:r=8+(a:color-232)*0x0a
        let l:g=l:r
        let l:b=l:r
    endif
    let l:rgb=[l:r,l:g,l:b]
    return l:rgb
endfunction

" selects the nearest xterm color for a rgb value like #FF0000
function! s:rgb2xterm(color)
    let s:colortable=[]
    for l:c in range(0, 254)
        let l:color = s:xterm2rgb(l:c)
        call add(s:colortable, l:color)
    endfor

    let l:best_match=0
    let l:smallest_distance = 10000000000
    let l:r = eval('0x'.a:color[0].a:color[1])
    let l:g = eval('0x'.a:color[2].a:color[3])
    let l:b = eval('0x'.a:color[4].a:color[5])
    for l:c in range(0,254)
        let l:d = pow(s:colortable[l:c][0] - l:r, 2) + pow(s:colortable[l:c][1] - l:g, 2) + pow(s:colortable[l:c][2] - l:b, 2)
        if l:d < l:smallest_distance
            let l:smallest_distance = l:d
            let l:best_match = l:c
        endif
    endfor
    return l:best_match
endfunction
command! -nargs=1 Rgb2xterm echo s:rgb2xterm(<f-args>)
command! -nargs=1 Xterm2rgb echo s:xterm2rgb(<f-args>)

" その他の参考になりそうな変換
" [xterm - Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Xterm)
" [lightline.vimをカスタマイズする - cafegale](http://leafcage.hateblo.jp/entry/2013/10/21/lightlinevim-customize)
" .vim/bundle/lightline.vim/autoload/lightline/colorscheme.vim の変換や
" [vim-coloresque/vim-coloresque.vim at master · gorodinskiy/vim-coloresque](https://github.com/gorodinskiy/vim-coloresque/blob/master/after/syntax/css/vim-coloresque.vim)

" syntaxの遡る行数を上げる {{{2
" ----------------------------------------------------------------------------
" グローバルな設定では無いらしく、autocmd FileTypeで設定
" autocmd MyVimrc FileType html,markdown,php syntax sync minlines=500 maxlines=5000
autocmd MyVimrc FileType markdown syntax sync minlines=500 maxlines=5000
" :syntax syncでminmalとmaximalの値を確認できる
" 参考
" [Big Sky :: 意外と知られていないvimのtips(開発に便利な設定)](http://mattn.kaoriya.net/software/vim/20070821175457.htm)
" :h :syn-sync-maxlines

" :h doxygen-syntax
" let g:load_dosygen_syntax=1

" 全角スペースをハイライト （Vimテクニックバイブル1-11）{{{2
" ----------------------------------------------------------------------------
" [Vim documentation: syntax](http://vim-jp.org/vimdoc-ja/syntax.html)
augroup MyVimrc
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
    autocmd ColorScheme *
    \   highlight IdeographicSpace cterm=underline ctermfg=59 ctermbg=16 gui=underline guifg=#465457 guibg=#000000
    " \   highlight IdeographicSpace term=underline ctermbg=67 guibg=#5f87af
augroup END
doautocmd ColorScheme

" cursorlineは重いので必要なときだけ有効にする {{{2
" ----------------------------------------------------------------------------
" 'cursorline' を必要な時にだけ有効にする - 永遠に未完成
" <http://d.hatena.ne.jp/thinca/20090530/1243615055>
set updatetime=100
set noswapfile " updatetimeミリ秒ごとにswapファイルが作られないようにswapファイルの設定を消す
augroup MyVimrc
    " autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
    " autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
    autocmd CursorMoved * call s:auto_cursorline('CursorMoved')
    autocmd CursorHold  * call s:auto_cursorline('CursorHold')
    autocmd InsertEnter * call s:auto_cursorline('InsertEnter')
    autocmd WinEnter    * call s:auto_cursorline('WinEnter')
    autocmd WinLeave    * call s:auto_cursorline('WinLeave')

    let s:cursorline_lock = 0
    function! s:auto_cursorline(event)
        if &filetype ==# 'qf' || &diff
            if &cursorline
                setlocal nocursorline
                return
            else
                return
            endif
        endif
        if a:event ==# 'WinEnter'
            setlocal cursorline
            let s:cursorline_lock = 2
        elseif a:event ==# 'WinLeave'
            setlocal cursorline
        elseif a:event ==# 'CursorMoved'
            if s:cursorline_lock
                if s:cursorline_lock > 1
                    let s:cursorline_lock = 1
                else
                    setlocal nocursorline
                    let s:cursorline_lock = 0
                endif
            endif
        elseif a:event ==# 'CursorHold'
            setlocal cursorline
            let s:cursorline_lock = 1
        elseif a:event ==# 'InsertEnter'
            setlocal nocursorline
        endif
    endfunction
augroup END

" ftdetect {{{1
" ==============================================================================
autocmd MyVimrc BufRead sanrinsha*,qiita* setlocal filetype=markdown
autocmd MyVimrc BufRead,BufNewFile *.md setlocal filetype=markdown
" MySQLのEditorの設定
" http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
autocmd MyVimrc BufRead /var/tmp/sql* setlocal filetype=sql
autocmd MyVimrc BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache

" *.htmlのファイルの1行目に<?phpがあるときにfiletypeをphpにする
autocmd MyVimrc BufRead,BufNewFile *.html
\   if getline(1) =~ '<?php'
\|      setlocal filetype=php
\|  endif

autocmd MyVimrc BufRead,BufNewFile composer.json
\   setlocal filetype=composer.json
\ | nnoremap <buffer> <Leader>ri :<C-u>QuickRun -args install<CR>
\ | nnoremap <buffer> <Leader>ru :<C-u>QuickRun -args update<CR>

" filetype {{{1
" ============================================================================
nnoremap [FILETYPE] <Nop>
nmap <Leader>F [FILETYPE]

nnoremap [FILETYPE]d :<C-u>setlocal filetype=diff<CR>
nnoremap [FILETYPE]h :<C-u>setlocal filetype=html<CR>
nnoremap [FILETYPE]j :<C-u>setlocal filetype=javascript<CR>
nnoremap [FILETYPE]m :<C-u>setlocal filetype=markdown<CR>
nnoremap [FILETYPE]p :<C-u>setlocal filetype=php<CR>
nnoremap [FILETYPE]r :<C-u>setlocal filetype=r<CR>
nnoremap [FILETYPE]s :<C-u>setlocal filetype=sql<CR>
nnoremap [FILETYPE]s :<C-u>setlocal filetype=sql<CR>
nnoremap [FILETYPE]sh :<C-u>let b:sql_type_overrride = 'hive' <Bar> setlocal filetype=sql<CR>
nnoremap [FILETYPE]v :<C-u>setlocal filetype=vim<CR>
nnoremap [FILETYPE]x :<C-u>setlocal filetype=xml<CR>

" プラグインなどで変更された設定をグローバルな値に戻す
" *.txtでtextwidth=78されちゃう
" [vimrc_exampleのロードのタイミング - Google グループ](https://groups.google.com/forum/#!topic/vim_jp/Z_3NSVO57FE "vimrc_exampleのロードのタイミング - Google グループ")
" autocmd MyVimrc FileType vim,text,mkd,markdown call s:override_plugin_setting()
" autocmd MyVimrc FileType vim,text call s:override_plugin_setting()

function! s:override_plugin_setting()
    setlocal textwidth<
    setlocal textwidth=0
    setlocal formatoptions<
endfunction

" shell {{{2
" ----------------------------------------------------------------------------
autocmd MyVimrc FileType sh setlocal errorformat=%f:\ line\ %l:\ %m

" Markdown {{{2
" ----------------------------------------------------------------------------
" デフォルトで入っているプラグインでfenced code blocksのコードをハイライト {{{3
" let g:markdown_fenced_languages = [
" \  'css',
" \  'javascript',
" \  'js=javascript',
" \  'json=javascript',
" \  'php',
" \  'sql',
" \  'xml',
" \]

" plasticboy/vim-markdownでfiletypeをmkd.markdownにする {{{3
" [Use "markdown" filetype instead of "mkd" (or both)?! · Issue #64 · plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown/issues/64)
" function! MyAddToFileType(ft)
"   if index(split(&ft, '\.'), a:ft) == -1
"     let &ft .= '.'.a:ft
"   endif
" endfun
" au FileType markdown call MyAddToFileType('mkd')
" au FileType mkd      call MyAddToFileType('markdown')

" rcmdnk/vim-markdown {{{3
if IsInstalled('rcmdnk_vim-markdown')
    let g:vim_markdown_folding_disabled = 1
    " macでgxを使いたい場合
    let g:netrw_browsex_viewer= 'open'
    let g:vim_markdown_no_default_key_mappings=1
endif

" joker1007/vim-markdown-quote-syntax {{{3
let g:markdown_quote_syntax_filetypes = {
\   'css' : {
\       'start' : "\\%(css\\|scss\\)",
\   },
\   'dot' : {
\       'start' : 'dot',
\   },
\   'javascript' : {
\       'start' : 'javascript',
\   },
\   'php' : {
\       'start' : 'php',
\   },
\   'sh' : {
\       'start' : 'sh',
\   },
\}

" nelstrom/vim-markdown-folding {{{3
if IsInstalled('vim-markdown-folding')
    let g:bundle = neobundle#get('vim-markdown-folding')
    function! bundle.hooks.on_source(bundle)
        let g:markdown_fold_style = 'nested'
    endfunction
endif

" pandocでhtmlからmarkdownに変換 {{{3
autocmd MyVimrc FileType markdown,html
\   command! Pandoc :%!pandoc -f html -t markdown_phpextra --no-wrap

autocmd MyVimrc FileType markdown
\   nnoremap <buffer> <Leader>r :<C-u>PrevimOpen<CR>

" JavaScript {{{2
" ----------------------------------------------------------------------------
autocmd MyVimrc FileType javascript call s:configure_javascript()

function! s:configure_javascript()
    setlocal syntax=jquery
    " .を入れたほうがneocompleteの補完がうまくいく
    setlocal iskeyword+=.
endfunction


" [Vim (with python) で json を整形 - Qiita](http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89#comment-77832dedb32996ec7080)
command! FormatJson
\   :execute '%!python -m json.tool'
\|  :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
\|  :set ft=javascript
" }}}
" Java {{{
" ----------------------------------------------------------------------------
if isdirectory(expand('~/AppData/Local/Android/android-sdk/sources/android-17'))
    autocmd MyVimrc FileType java setlocal path+=~/AppData/Local/Android/android-sdk/sources/android-17
elseif isdirectory(expand('/Program Files (x86)/Android/android-sdk/sources/android-17'))
    autocmd MyVimrc FileType java setlocal path+=/Program\ Files\ (x86)/Android/android-sdk/sources/android-17
endif
autocmd MyVimrc FileType java
            \   setlocal foldmethod=syntax
            \|  nnoremap <buffer>  [[ [m
            \|  nnoremap <buffer>  ]] ]m
"}}}
" MySQL {{{
" ----------------------------------------------------------------------------
let g:sql_type_default = 'mysql'
" ]}, [{ の移動先
let g:ftplugin_sql_statements = 'create,alter'

" Vim {{{2
" ----------------------------------------------------------------------------
" \を打った時のindentの幅
" let g:vim_indent_cont = &sw
let g:vim_indent_cont = 0

" http://vim-users.jp/2009/09/hack74/
" .vimrcと.gvimrcの編集
nnoremap [VIM] <Nop>
nmap <Leader>v [VIM]
" executeは重いのでやめる
" vimrcの実体を開く。systemだと最後に<NL>が入ってうまくいかない
" execute 'nnoremap [VIM]e :<C-u>edit ' . substitute(system('readlink $MYVIMRC'),  "\<NL>", '', '') . '<CR>'
" execute 'nnoremap [VIM]E :<C-u>edit ' . substitute(system('readlink $MYGVIMRC'), "\<NL>", '', '') . '<CR>'
let s:src_home = '$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home'
execute 'nnoremap [VIM]e :<C-u>edit '.s:src_home.'/.vimrc<CR>'
execute 'nnoremap [VIM]E :<C-u>edit '.s:src_home.'/_gvimrc<CR>'
execute 'nnoremap [VIM]b :<C-u>edit '.s:src_home.'/.vim/rc/bundle.vim<CR>'
execute 'nnoremap [VIM]p :<C-u>edit '.s:src_home.'/.vim/rc/plugin.vim<CR>'

" Load .gvimrc after .vimrc edited at GVim.
nnoremap <silent> [VIM]r :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif \| echo 'vimrc reloaded!'<CR>
nnoremap <silent> [VIM]R :<C-u>source $MYGVIMRC<CR>

""vimrc auto update
"augroup MyAutoCmd
"  autocmd!
"  " nested: autocmdの実行中に更に別のautocmdを実行する
"  autocmd BufWritePost .vimrc nested source $MYVIMRC
"  " autocmd BufWritePost .vimrc RcbVimrc
"augroup END

" autocmd MyVimrc BufWritePost *.vim
"     \   if filereadable(expand('%'))
"     \|       source %
"     \|  endif

" カーソル下のキーワードを:helpで開く (:help K)
autocmd MyVimrc FileType vim
\   setlocal keywordprg=:help
\|  setlocal path&
\|  setlocal path+=$VIMDIR/bundle
\|  setlocal comments=:\"

" vimperator {{{2
" ----------------------------------------------------------------------------
autocmd MyVimrc FileType vimperator
\   setlocal comments=:\"
" help {{{2
" ----------------------------------------------------------------------------
" set helplang=en,ja
autocmd MyVimrc FileType help call s:setting_help()

function! s:setting_help()
    nnoremap <buffer><silent> q :q<CR>
    nnoremap <buffer> ]]     /<Bar>.*<Bar><CR>
    nnoremap <buffer> ]<Bar> /<Bar>.*<Bar><CR>
    nnoremap <buffer> [[     ?<Bar>.*<Bar><CR>
    nnoremap <buffer> [<Bar> ?<Bar>.*<Bar><CR>
    nnoremap <buffer> ]' /'.*'<CR>
    nnoremap <buffer> [' /'.*'<CR> |
    " デフォルトは!-~,^*,^|,^",192-255だが()を外したい。
    " -=()が効かない?
    setlocal iskeyword=!-39,42-~,^*,^\|,^\",192-255
endfunction

" Git {{{2
" ----------------------------------------------------------------------------
" コミットメッセージは72文字で折り返す
" http://keijinsonyaban.blogspot.jp/2011/01/git.html
" 72列目に線を引く
" Insert modeで始める
autocmd MyVimrc BufRead */.git/COMMIT_EDITMSG
    \   setlocal colorcolumn=+1
    \|  startinsert
" ftpluginによって、自動で折り返す設定になるので、自分のvimrcで設定したglobalな値に戻す
autocmd MyVimrc FileType gitcommit
    \  setlocal formatoptions<

" tsv {{{2
" ----------------------------------------------------------------------------
autocmd MyVimrc BufRead,BufNewFile *.tsv setlocal noexpandtab
"}}}
if !has('gui_running')
    call SourceRc('cui.vim')
endif
call SourceRc('plugin.vim')
call SourceRc('local.vim')
