" {{{
scriptencoding utf-8 "vimrcの設定でマルチバイト文字を使うときに必要
set encoding=utf-8 "vimrcのエラーメッセージが文字化けしないように早めに設定
let $VIMFILES = expand('~/.vim')

if has('win32')
    set runtimepath&
    set runtimepath^=$HOME/.vim
    set runtimepath+=$HOME/.vim/after
    cd ~
endif
" }}}
" neobundle.vim {{{
" ==============================================================================
if filereadable(expand($VIMFILES.'/bundle/neobundle.vim/autoload/neobundle.vim'))
    \   && (v:version >= 703 || v:version == 702 && has('patch051'))
    if has('vim_starting')
      set runtimepath+=$VIMFILES/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    let g:neobundle#types#git#default_protocol = "git"
    let g:neobundle#install_process_timeout = 2000

    " すでにvimが起動しているときは、そちらで開く
    if has('clientserver')
        NeoBundle 'thinca/vim-singleton'
        if neobundle#is_installed('vim-singleton')
            call singleton#enable()
        endif
    endif

    " Let neobundle manage neobundle
    NeoBundleFetch 'Shougo/neobundle.vim'

    " recommended to install
    if has('win32') && has('kaoriya')
        " kaoriya版Vim同梱のvimprocを使う
        set runtimepath+=$VIM/plugins/vimproc
    else
        NeoBundle 'Shougo/vimproc', {
                    \   'build' : {
                    \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
                    \     'cygwin'  : 'make -f make_cygwin.mak',
                    \     'mac'     : 'make -f make_mac.mak',
                    \     'unix'    : 'make -f make_unix.mak',
                    \   },
                    \ }
    endif

    " unite {{{
    " ==========================================================================
    NeoBundle 'Shougo/unite.vim'

    NeoBundleLazy 'Shougo/unite-outline', {
                \   'autoload' : { 'unite_sources' : ['outline'] }
                \ }

    NeoBundleLazy 'tacroe/unite-mark', {
                \   'autoload' : { 'unite_sources' : ['mark'] }
                \ }

    NeoBundleLazy 'tsukkee/unite-tag', {
                \   'autoload' : { 'unite_sources' : ['tag'] }
                \ }

    NeoBundle 'Shougo/unite-ssh'
    NeoBundle 'ujihisa/vimshell-ssh'
    "NeoBundle 'Shougo/unite-sudo'
    " }}}

    " http://archiva.jp/web/tool/vim_grep2.html
    NeoBundle 'thinca/vim-qfreplace'

    NeoBundle 'Shougo/vimfiler'
    NeoBundleLazy 'Shougo/vimshell', {
                \   'autoload' : { 'commands' : [ 'VimShell', "VimShellBufferDir", "VimShellInteractive", "VimShellPop" ] },
                \   'depends' : 'Shougo/vim-vcs'
                \}

    " 補完 {{{
    " ==========================================================================
    " 補完候補の自動表示
    if has('lua') && (v:version >= 704 || v:version == 703 && has('patch825'))
        NeoBundleLazy "Shougo/neocomplete", {
            \   "autoload": {
            \       "insert": 1,
            \   }
            \}
    else
        NeoBundleLazy "Shougo/neocomplcache", {
            \   "autoload": {
            \        "insert": 1,
            \   }
            \}
    endif

    " Valloric/Youcompleteme {{{
    " if has('gui_running') && has('python') && (v:version >= 704 || v:version == 703 && has('patch584'))
    " if has('python') && (v:version >= 704 || v:version == 703 && has('patch584'))
    "     NeoBundle "Valloric/YouCompleteMe"
    " endif
    " }}}

    " スニペット補完
    NeoBundleLazy 'Shougo/neosnippet', {
                \   "autoload" : {
                \       "insert" : 1,
                \   }
                \}
    NeoBundleLazy 'Shougo/neosnippet-snippets', {
                \   "autoload" : {
                \       "insert" : 1,
                \   }
                \}
    NeoBundleLazy 'honza/vim-snippets', {
                \   "autoload" : {
                \       "insert" : 1,
                \   }
                \}
    " }}}
    " quickrun {{{
    NeoBundleLazy 'thinca/vim-quickrun', {
                \   'autoload' : { 'commands' : [ 'QuickRun' ] }
                \}
    " NeoBundleLazy 'rhysd/quickrun-unite-quickfix-outputter', {
    "             \   'autoload' : { 'commands' : 'QuickRun' },
    "             \   'depends'  : [ 'thinca/vim-quickrun', 'osyo-manga/unite-quickfix' ]
    "             \}
    NeoBundle 'rhysd/quickrun-unite-quickfix-outputter', {
                \   'depends'  : [ 'thinca/vim-quickrun', 'osyo-manga/unite-quickfix' ]
                \}
    " }}}
    " operator {{{
    NeoBundle "kana/vim-operator-user"
    NeoBundleLazy 'kana/vim-operator-replace', {
        \   'depends': 'kana/vim-operator-user',
        \   'autoload' : { 'mappings' : '<Plug>(operator-replace)' }
        \}
    NeoBundleLazy "osyo-manga/vim-operator-search", {
        \   'depends': 'kana/vim-operator-user',
        \   'autoload' : { 'mappings' : '<Plug>(operator-search)' }
        \}
    NeoBundleLazy "rhysd/vim-operator-surround", {
        \   'depends': 'kana/vim-operator-user',
        \   'autoload' : { 'mappings' : '<Plug>(operator-surround-' }
        \}
    NeoBundleLazy "tyru/operator-camelize.vim", {
        \   'depends': 'kana/vim-operator-user',
        \   'autoload' : { 'mappings' : '<Plug>(operator-camelize-toggle)' }
        \}
    " }}}
    " textobj {{{
    NeoBundle 'kana/vim-textobj-user'
    NeoBundle 'kana/vim-textobj-entire'
    NeoBundle 'kana/vim-textobj-function'
    NeoBundle 'kentaro/vim-textobj-function-php'
    NeoBundle 'kana/vim-textobj-indent'
    NeoBundle 'sgur/vim-textobj-parameter'
    NeoBundle 'thinca/vim-textobj-comment'
    if (v:version == 703 && !has('patch610')) || v:version == 702
        NeoBundleLazy 'kana/vim-textobj-lastpat', {
            \   'depends': 'kana/vim-textobj-user',
            \   'autoload' : { 'mappings' : '<Plug>(textobj-lastpat-' }
            \}
    endif
    " }}}
    " dでキー待ちが発生してしまう
    " NeoBundle 'tpope/vim-surround'
    NeoBundleLazy 'kana/vim-smartword', {
                \   'autoload' : { 'mappings' : '<Plug>(smartword-' }
                \}
    NeoBundleLazy 'thinca/vim-visualstar', {
                \   'autoload' : { 'mappings' : '<Plug>(visualstar-' }
                \}

    " Vimperatorのクイックヒント風にカーソル移動
    NeoBundle 'Lokaltog/vim-easymotion'

    " terryma/vim-multiple-cursors {{{
    " ==========================================================================
    " NeoBundle 'terryma/vim-multiple-cursors'
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='"'
    let g:multi_cursor_prev_key="'"
    let g:multi_cursor_skip_key='&'
    let g:multi_cursor_quit_key='<Esc>'
    " }}}

    " 部分的に編集
    NeoBundle 'thinca/vim-partedit'

    " 整形
    if v:version >= 701
        NeoBundle 'h1mesuke/vim-alignta'
    else
        NeoBundle 'Align'
    endif


    " sudo権限でファイルを開く・保存
    " http://www.vim.org/scripts/script.php?script_id=729
    NeoBundle 'vim-scripts/sudo.vim'

    NeoBundle 'vim-scripts/YankRing.vim'
    " NeoBundle 'LeafCage/yankround.vim'

    NeoBundleLazy 'thinca/vim-ft-help_fold', {
                \   'autoload' : { 'filetypes' : 'help' }
                \ }
    NeoBundleLazy 'kannokanno/vim-helpnew', {
                \   'autoload' : { 'commands' : 'HelpNew' }
                \ }

    " ミニバッファにバッファ一覧を表示
    " NeoBundle 'fholgado/minibufexpl.vim'

    " バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
    NeoBundle 'rgarver/Kwbd.vim'

    " 一時バッファの制御
    if v:version >= 704 || (v:version == 703 && has('patch462'))
        NeoBundle 'osyo-manga/vim-automatic', {
                    \   'depends': 'osyo-manga/vim-gift',
                    \}
    endif

    " ステータスラインをカスタマイズ
    " https://github.com/Lokaltog/vim-powerline
    NeoBundle 'Lokaltog/vim-powerline'

    NeoBundle 'LeafCage/foldCC'
    " gundo.vim {{{
    " グラフィカルにundo履歴を見れる
    NeoBundleLazy 'sjl/gundo.vim', {
        \   'autoload' : {
        \       'commands' : 'GundoToggle'
        \   }
        \}
    " }}}
    " savevers.vim {{{
    " バックアップ
    NeoBundle 'savevers.vim'
    " }}}
    " syntastic {{{
    " ---------
    " ファイルを保存時にシンタックスのチェック
    NeoBundle 'scrooloose/syntastic'
    " }}}
    " vim-jsbeautify {{{
    " --------------
    " JavaScript, CSS, HTMLの整形
    NeoBundleLazy 'maksimr/vim-jsbeautify', {
        \   'autoload' : {
        \       'filetypes': ['javascript', 'css', 'html']
        \   }
        \}
    " }}}
    " caw.vim {{{
    " -------
    " コメント操作
    NeoBundle "tyru/caw.vim"
    " NeoBundle "tpope/vim-commentary"
    " }}}

    " eclipseと連携
    if executable('ant')
        NeoBundle 'ervandew/eclim', {
                    \   'build' : {
                    \       'windows' : 'ant -Declipse.home='.escape(expand('~/eclipse'), '\')
                    \                     .' -Dvim.files='.escape(expand('~/.vim/bundle/eclim'), '\'),
                    \       'mac'     : 'ant -Declipse.home='.escape(expand('~/eclipse'), '\')
                    \                     .' -Dvim.files='.escape(expand('~/.vim/bundle/eclim'), '\'),
                    \   },
                    \   'autoload': {'filetypes': ['java', 'xml']}
                    \}
    endif

    NeoBundle 'mattn/emmet-vim'

    " CSS
    " #000000とかの色付け
    " http://hail2u.net/blog/software/add-support-for-rgb-func-syntax-to-css-color-preview.html
    " NeoBundle 'gist:hail2u/228147', {
    "             \ 'name': 'css.vim',
    "             \ 'script_type': 'plugin'}

    " JavaScript {{{
    " --------------
    NeoBundle 'pangloss/vim-javascript'
    NeoBundle 'jelera/vim-javascript-syntax'
    NeoBundle 'nono/jquery.vim'
    " }}}
    " SQL {{{
    NeoBundleLazy 'vim-scripts/dbext.vim', {
        \   'autoload': {'filetypes': 'sql'}
        \}
    " }}}
    " Markdown {{{
    " ------------
    " NeoBundleLazy 'tpope/vim-markdown', {
    "             \   'autoload' : { 'filetypes' : 'markdown' }
    "             \}
    " NeoBundle 'tpope/vim-markdown'
    " NeoBundle 'plasticboy/vim-markdown'
    NeoBundle 'tmsanrinsha/vim-markdown'
    " NeoBundle 'nelstrom/vim-markdown-folding'
    " NeoBundleLazy 'teramako/instant-markdown-vim'
    if executable('node') && executable('ruby')
        NeoBundle 'suan/vim-instant-markdown'
    endif
    " }}}
    " yaml {{{
    " NeoBundleLazy 'tmsanrinsha/yaml.vim', {
    "             \   'autoload' : { 'filetypes' : 'yaml' }
    "             \}
    " }}}
    " tmux {{{
    " tmuxのシンタックスファイル
    NeoBundleLazy 'zaiste/tmux.vim', {
                \   'autoload' : { 'filetypes' : 'tmux' }
                \ }
    " }}}
    " vimperator {{{
    " vimperatorのシンタックスファイル
    NeoBundleLazy 'http://vimperator-labs.googlecode.com/hg/vimperator/contrib/vim/syntax/vimperator.vim', {
                \   'type'        : 'raw',
                \   'autoload'    : { 'filetypes' : 'vimperator' },
                \   'script_type' : 'syntax'
                \}
    " }}}
    " confluence {{{
    " confluenceのシンタックスファイル
    NeoBundleLazy 'confluencewiki.vim', {
                \   'autoload' : { 'filetypes' : 'confluencewiki' }
                \ }
    " }}}

    NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive'}
    NeoBundleLazy 'gregsexton/gitv', {
                \   'autoload': {'commands' : ['Gitv']}
                \}


    NeoBundleLazy 'mattn/gist-vim', {
                \   'autoload' : { 'commands' : [ 'Gist' ] },
                \   'depends'  : 'mattn/webapi-vim'
                \}

    NeoBundleLazy 'vim-scripts/DirDiff.vim', {
                \   'autoload' : {
                \       'commands' : {
                \           'name' : 'DirDiff',
                \           'complete' : 'dir'
                \       }
                \   }
                \}

    NeoBundleLazy 'tyru/open-browser.vim', {
                \   'autoload':{
                \       'mappings':[
                \            '<Plug>(openbrowser-'
                \        ]
                \   }
                \}

    " http://qiita.com/rbtnn/items/89c78baf3556e33c880f
    NeoBundleLazy 'rbtnn/vimconsole.vim', {
                \   'autoload' : {
                \       'commands' : 'VimConsoleToggle'
                \   }
                \}


    " colorscheme
    " NeoBundle 'tomasr/molokai'
    NeoBundle 'w0ng/vim-hybrid'
    NeoBundle 'vim-scripts/wombat256.vim'
    NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'chriskempson/vim-tomorrow-theme'
    NeoBundle 'vim-scripts/rdark'
    NeoBundle 'vim-scripts/rdark-terminal'
    NeoBundle 'jonathanfilip/vim-lucius'

    " カラースキームの色見本
    " http://cocopon.me/blog/?p=3522
    NeoBundleLazy 'cocopon/colorswatch.vim', {
                \   'autoload': { 'commands' : [ 'ColorSwatchGenerate' ] }
                \}
    NeoBundleLazy 'LeafCage/unite-gvimrgb', {
        \ 'autoload' : {
        \   'unite_sources' : 'gvimrgb'
        \ }}

    " HttpStatus コマンドで、HTTP のステータスコードをすばやくしらべる!
    " http://mattn.kaoriya.net/software/vim/20130221123856.htm
    NeoBundleLazy 'mattn/httpstatus-vim', {
                \   'autoload' : { 'commands' : 'HttpStatus' }
                \ }

    " NeoBundle 'thinca/vim-ref', {'type' : 'nosync', 'rev' : '91fb1b' }

    if executable('hg') " external_commandsの設定だけだと毎回チェックがかかる
        NeoBundleLazy 'https://bitbucket.org/pentie/vimrepress', {
                    \   'autoload' : {
                    \       'commands' : [
                    \           'BlogList', 'BlogNew', 'BlogSave', 'BlogPreview'
                    \       ]
                    \   },
                    \   'external_commands' : 'hg'
                    \}
    endif

    " glidenote/memolist.vim {{{
    NeoBundleLazy 'glidenote/memolist.vim', {
                \   'autoload' : { 'commands' : [
                \       'MemoNew', 'MemoList', 'MemoGrep'
                \   ]}
                \}
    " }}}
    " fuenor/qfixhowm {{{
    NeoBundle 'fuenor/qfixhowm'
    " }}}
    " osyo-manga/unite-qfixhowm {{{
    NeoBundle "osyo-manga/unite-qfixhowm"
    " }}}
    " NeoBundle 'jceb/vim-orgmode'

    " http://d.hatena.ne.jp/itchyny/20140108/1389164688
    NeoBundleLazy 'itchyny/calendar.vim', {
                \   'autoload' : { 'commands' : [
                \       'Calendar'
                \   ]}
                \}

    " vim以外のリポジトリ
    NeoBundleFetch 'mla/ip2host', {'base' : '~/.vim/fetchBundle'}

    " 自分のリポジトリ
    " if (hostname() =~ 'sakura' || hostname() =~ 'VAIO' || $USER == 'tmsanrinsha')
    "     let g:neobundle#types#git#default_protocol = "ssh"
    " endif
    NeoBundle 'tmsanrinsha/molokai'
    " NeoBundle 'tmsanrinsha/vim-colors-solarized'
    NeoBundle 'tmsanrinsha/vim'
    NeoBundle 'tmsanrinsha/vim-emacscommandline'

    " Brief help
    " :NeoBundleList          - list configured bundles
    " :NeoBundleInstall(!)    - install(update) bundles
    " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles
    " :Unite neobundle/install:!
    " :Unite neobundle/install:neocomplcache
    " :Unite neobundle/install:neocomplcache:unite.vim

    filetype plugin indent on     " Required!

     " Installation check.
     NeoBundleCheck

    if !has('vim_starting')
      " Call on_source hook when reloading .vimrc.
      call neobundle#call_hook('on_source')
    endif
else
    " neobundleが使えない場合
    " bundle以下にあるpluginをいくつかruntimepathへ追加する
    let s:load_plugin_list = [
                \   'sudo.vim', 'yankround.vim', 'minibufexpl.vim', 'Kwbd.vim',
                \   'vim-powerline', 'syntastic', 'molokai', 'vim-smartword'
                \]
    for path in split(glob($HOME.'/.vim/bundle/*'), '\n')
        let s:plugin_name = matchstr(path, '[^/]\+$')
        if isdirectory(path) && index(s:load_plugin_list, s:plugin_name) >= 0
            let &runtimepath = &runtimepath.','.path
        end
    endfor

    filetype plugin indent on
endif

"}}}
" Pluginの有無をチェック {{{
" runtimepathにあるか
" http://yomi322.hateblo.jp/entry/2012/06/20/225559
function! g:has_plugin(plugin)
  return !empty(globpath(&runtimepath, 'plugin/'   . a:plugin . '.vim'))
  \   || !empty(globpath(&runtimepath, 'autoload/' . a:plugin . '.vim'))
  \   || !empty(globpath(&runtimepath, 'colors/'   . a:plugin . '.vim'))
endfunction
" NeoBundleLazyを使うと最初はruntimepathに含まれないため、
" neobundle#is_installedを使う
" 直接使うとneobundleがない場合にエラーが出るので確認
function! s:is_installed(plugin)
    if g:has_plugin('neobundle') && (v:version >= 703 || v:version == 702 && has('patch051'))
        return neobundle#is_installed(a:plugin)
    else
        return 0
    endif
endfunction
" }}}
" 基本設定 {{{
" ==============================================================================
" vimrc全体で使うaugroup {{{
" ------------------------------------------------------------------------------
" http://rhysd.hatenablog.com/entry/2012/12/19/001145
" autocmd!の回数を減らすことでVimの起動を早くする
" ネームスペースを別にしたい場合は別途augroupを作る
augroup MyVimrc
    autocmd!
augroup END
" }}}
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set cmdheight=2 "コマンドラインの高さを2行にする
set number
set ruler
set cursorline
set t_Co=256 " 256色

" 不可視文字 {{{
set list listchars=tab:>-,trail:_ "タブと行末の空白の表示

" 全角スペースをハイライト （Vimテクニックバイブル1-11）
syntax enable
scriptencoding utf-8
augroup colerscheme
    autocmd!
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
    autocmd ColorScheme * highlight IdeographicSpace term=underline ctermbg=67 guibg=#5f87af
augroup END
" }}}

" set textwidth=0

set formatoptions&
" r : Insert modeで<Enter>を押したら、comment leaderを挿入する
" M : マルチバイト文字の連結(J)でスペースを挿入しない
set formatoptions+=rM
if v:version >= 704 || v:version == 703 && has('patch541') && has('patch550')
    " j : コメント行の連結でcomment leaderを取り除く
    set formatoptions+=j
endif
" t : textwidthを使って自動的に折り返す
" c : textwidthを使って、コマントを自動的に折り返しcomment leaderを挿入する
" o : Normal modeでoまたOを押したら、comment leaderを挿入する
set formatoptions-=tco

" CTRL-AやCTRL-Xを使った時の文字の増減の設定
" 10進法と16進数を増減させる。
" 0で始まる数字列を8進数とみなさず、10進数として増減させる。
" アルファベットは増減させない
set nrformats=hex

set foldmethod=marker

set shellslash

" macに最初から入っているvimはセキュリティの問題からシステムのvimrcでmodelinesを0にしている。
" http://unix.stackexchange.com/questions/19875/setting-vim-filetype-with-modeline-not-working-as-expected
" この問題は7.0.234と7.0.235のパッチで修正された
" https://bugzilla.redhat.com/show_bug.cgi?id=cve-2007-2438
if v:version >= 701 || v:version == 700 && has('patch234') && has('patch235')
    set modelines&
else
    set modelines=0
endif

" pasteモードのトグル。autoindentをonにしてペーストすると
" インデントが入った文章が階段状になってしまう。
" pasteモードではautoindentが解除されそのままペーストできる
set pastetoggle=<F11>
" key mappingに対しては3000ミリ秒待ち、key codeに対しては10ミリ秒待つ
set mouse=a

if has('path_extra')
    set tags=./tags;~,~/**2/tags
endif
set helplang=en,ja
"}}}
" 文字コード・改行コード {{{
" ==============================================================================
" 文字コード
set encoding=utf-8
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
    set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" endif

" エンコーディングを指定して開き直す
command! EncCp932     edit ++enc=cp932
command! EncEucjp     edit ++enc=euc-jp
command! EncIso2022jp edit ++enc=iso-2022-jp
command! EncUtf8      edit ++enc=uff-8
" alias
command! EncJis  EncIso2022jp
command! EncSjis EncCp932

" 改行
set fileformats=unix,dos,mac
" 改行コードを指定して開き直すには
"  :e ++ff=dos
" などとする

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
"}}}
" mapping {{{
" ------------------------------------------------------------------------------
" :h map-modes
" gvimにAltのmappingをしたい場合は先にset encoding=...をしておく

set timeout timeoutlen=3000 ttimeoutlen=10
if exists('+macmeta')
   " MacVimでMETAキーを使えるようにする
   set macmeta
endif
" let mapleader = "\<space>"

" prefix
" http://blog.bouzuya.net/2012/03/26/prefixedmap-vim/
" [Space]でmapするようにするとVimFilerのスペースキーでキー待ちが発生しなくなる
noremap [Space]   <Nop>
map <Space> [Space]

noremap ; :
noremap : ;

inoremap jj <ESC>
"cnoremap jj <ESC>
nnoremap Y y$

"挿入モードのキーバインドをemacs風に
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
"inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-n> <Down>
inoremap <C-p> <Up>
"inoremap <C-e> <End>  neocomplcacheにて設定
"inoremap <C-k> <C-o>D neosnippetにて設定

" inoremap <expr> <C-d> "\<C-g>u".(col('.') == col('$') ? '<Esc>^y$A<Space>=<Space><C-r>=<C-r>"<CR>' : '<Del>')
inoremap <Leader>= <Esc>^y$A<Space>=<Space><C-r>=<C-r>"<CR>

inoremap <C-r>[ <C-r>=expand('%:p:h')<CR>/
cnoremap <C-r>[ <C-r>=expand('%:p:h')<CR>/
" expand file (not ext)
inoremap <C-r>] <C-r>=expand('%:p:r')<CR>
cnoremap <C-r>] <C-r>=expand('%:p:r')<CR>
" }}}
" swap, backup, undo {{{
" ==============================================================================
" デフォルトの設定にある~/tmpを入れておくと、swpファイルが自分のホームディレクトリ以下に生成されてしまい、他の人が編集中か判断できなくなるので除く
set directory&
set directory-=~/tmp
" 他の人が編集する可能性がない場合はswapファイルを作成しない
if has('win32') || has('mac')
    set noswapfile
endif

" 富豪的バックアップ
" http://d.hatena.ne.jp/viver/20090723/p1
" http://synpey.net/?p=127
" savevers.vimが場合はそちらを使う
if g:has_plugin('savevers')
    set backup
    set backupdir=$VIMFILES/.bak

    augroup backup
        autocmd!
        autocmd BufWritePre,FileWritePre,FileAppendPre * call UpdateBackupFile()
        function! UpdateBackupFile()
            let basedir = expand("$VIMFILES/.bak")
            let dir = strftime(basedir."/%Y%m/%d", localtime()).substitute(expand("%:p:h"), '\v\c^([a-z]):', '/\1/' , '')
            if !isdirectory(dir)
                call mkdir(dir, "p")
            endif

            let dir = escape(dir, ' ')
            exe "set backupdir=".dir
            let time = strftime("%H-%M", localtime())

            exe "set backupext=.".time
        endfunction
    augroup END
endif

" アンドゥの履歴をファイルに保存し、Vim を一度終了したとしてもアンドゥやリドゥを行えるようにする
" 開いた時に前回保存時と内容が違う場合はリセットされる
if has('persistent_undo')
    set undofile
    if !isdirectory($VIMFILES.'/.vimundo')
        call mkdir($VIMFILES.'/.vimundo')
    endif
    set undodir=$VIMFILES/.vimundo
endif

" Always Jump to the Last Known Cursor Position
autocmd MyVimrc BufReadPost *
            \ if line("`\"") > 1 && line("`\"") <= line("$") |
            \   execute "normal! g`\"" |
            \ endif

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

"}}}
" window {{{
" ==============================================================================
"nnoremap <M-h> <C-w>h
"nnoremap <M-j> <C-w>j
"nnoremap <M-k> <C-w>k
"nnoremap <M-l> <C-w>l
nnoremap <M--> <C-w>-
nnoremap <M-;> <C-w>+
nnoremap <M-,> <C-w><
nnoremap <M-.> <C-w>>
nnoremap <M-0> <C-w>=
nnoremap <C-w>; <C-w>p

set splitbelow
set splitright

"  常にカーソル行を真ん中に
"set scrolloff=999

"縦分割されたウィンドウのスクロールを同期させる
"同期させたいウィンドウ上で<F12>を押せばおｋ
"解除はもう一度<F12>を押す
"横スクロールも同期させたい場合はこちら
"http://ogawa.s18.xrea.com/fswiki/wiki.cgi?page=Vim%A4%CE%A5%E1%A5%E2
"nnoremap <F12> :set scrollbind!<CR>
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

nnoremap [TAB]n :tabn<CR>
nnoremap [TAB]p :tabp<CR>

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
" コマンドラインモード {{{
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
" コマンドラインウィンドウを開きたいときは<Leader><C-F>にする
cnoremap <Leader><C-F> <C-F>

set history=100000 "保存する履歴の数

" 外部コマンド実行でエイリアスを使うための設定
" http://sanrinsha.lolipop.jp/blog/2013/09/vim-alias.html
" bashスクリプトをquickrunで実行した時にエイリアス展開されてしまうのでコメント
" アウト
" let $BASH_ENV=expand('~/.bashenv')
" let $ZDOTDIR=expand('~/.vim/')
" 検索・置換 {{{
" ------------------------------------------------------------------------------
set incsearch
set ignorecase "検索パターンの大文字小文字を区別しない
set smartcase  "検索パターンに大文字を含んでいたら大文字小文字を区別する
set nohlsearch "検索結果をハイライトしない

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

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
cnoremap <expr> \/ getcmdtype() == '/' ? '/'  : '\/'
cnoremap <expr> \? getcmdtype() == '?' ? '?'  : '\?'

"ヴィビュアルモードで選択した範囲だけ検索
vnoremap <Leader>/ <ESC>/\%V
vnoremap <Leader>? <ESC>?\%V

nnoremap <Leader>ss :%s///
xnoremap <Leader>ss :s///
" }}}
" }}}
" コマンドラインウィンドウ {{{
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
  inoremap <buffer><expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
  inoremap <buffer><expr><BS> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  startinsert!
endfunction
" }}}
" ビジュアルモード {{{
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
"}}}
"}}}
" ディレクトリ・パス {{{
" ==============================================================================
"augroup CD
"    autocmd!
"    autocmd BufEnter * execute ":lcd " . expand("%:p:h")
"augroup END
" 現在編集中のファイルのディレクトリをカレントディレクトリにする
nnoremap <silent><Leader>gc :cd %:h<CR>

" %%でアクティブなバッファのパスを展開
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" }}}
" カーソル {{{
" ==============================================================================
" set virtualedit=block       " 矩形選択でカーソル位置の制限を解除

"カーソルを表示行で移動する。
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

" backspaceキーの挙動を設定する
" " indent        : 行頭の空白の削除を許す
" " eol           : 改行の削除を許す
" " start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

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
set diffopt=filler
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
" printing {{{
set printoptions=wrap:y,number:y,header:0
set printfont=Andale\ Mono:h12:cUTF8
"}}}
" Quickfix {{{
" ==============================================================================
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ
noremap [quickfix] <Nop>
nmap <Leader>q [quickfix]
noremap [quickfix]o :copen<CR>
noremap [quickfix]c :cclose<CR>
nmap <Leader>l [location]
noremap [location]o :lopen<CR>
noremap [location]c :lclose<CR>

" show quickfix automatically
" これをやるとneocomlcacheの補完時にquickfix winodow（中身はtags）が開くのでコメントアウト
" autocmd MyVimrc QuickfixCmdPost * if !empty(getqflist()) | cwindow | lwindow | endif
"}}}
" Ip2host {{{
" ==============================================================================
function! s:Ip2host(line1, line2)
    for linenum in range(a:line1, a:line2)
        let oldline = getline(linenum)
        let newline = substitute(oldline,
                    \   '\v((%(2%([0-4]\d|5[0-5])|1\d\d|[1-9]?\d)\.){3}%(2%([0-4]\d|5[0-5])|1\d\d|[1-9]?\d))',
                    \   '\=substitute(system("nslookup ".submatch(1)), "\\v.*%(name = |:    )([0-9a-z-.]+).*", "\\1","")',
                    \   '')
        call setline(linenum, newline)
    endfor
endfunction

command! -range=% Ip2host :call s:Ip2host(<line1>, <line2>)
" }}}
" カーソル以下のカラースキームの情報の取得 {{{
" ==============================================================================
" http://cohama.hateblo.jp/entry/2013/08/11/020849
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
" }}}
" ftdetect {{{
" ==============================================================================
autocmd MyVimrc BufRead sanrinsha*
            \   setlocal filetype=markdown
            \|  setlocal textwidth=0
" autocmd MyVimrc BufRead,BufNewFile *.md setlocal filetype=markdown
" MySQLのEditorの設定
" http://lists.ccs.neu.edu/pipermail/tipz/2003q2/000030.html
autocmd MyVimrc BufRead /var/tmp/sql* setlocal filetype=sql
autocmd MyVimrc BufRead,BufNewFile *apache*/*.conf setlocal filetype=apache
" }}}
" ==== filetype ==== {{{
nnoremap <Leader>fh :<C-u>setlocal filetype=html<CR>
nnoremap <Leader>fj :<C-u>setlocal filetype=javascript<CR>
nnoremap <Leader>fm :<C-u>setlocal filetype=markdown<CR>
nnoremap <Leader>fp :<C-u>setlocal filetype=php<CR>
nnoremap <Leader>fs :<C-u>setlocal filetype=sql<CR>
nnoremap <Leader>fv :<C-u>setlocal filetype=vim<CR>
nnoremap <Leader>fx :<C-u>setlocal filetype=xml<CR>

" shell {{{
" ==============================================================================
augroup sh
    autocmd!
    autocmd FileType sh setlocal errorformat=%f:\ line\ %l:\ %m
augroup END
"}}}
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
" gf(goto file)の設定 {{{
" ------------------------------------------------------------------------------
" http://sanrinsha.lolipop.jp/blog/2012/01/vim%E3%81%AEgf%E3%82%92%E6%94%B9%E8%89%AF%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B.html
autocmd MyVimrc FileType html
    \   setlocal includeexpr=substitute(v:fname,'^\\/','','')
    \|  setlocal path&
    \|  setlocal path+=./;/
" }}}
" }}}
" XML {{{
" ==============================================================================
nnoremap <Leader>= :%s/></>\r</g<CR>:setlocal ft=xml<CR>gg=G
" }}}
" JavaScript {{{
" ==============
autocmd MyVimrc FileType javascript setlocal syntax=jquery
" }}}
" PHP {{{
" ==============================================================================
let php_sql_query=1 " 文字列中のSQLをハイライトする
let php_htmlInStrings=1 " 文字列中のHTMLをハイライトする
let php_noShortTags = 1 " ショートタグ (<?を無効にする→ハイライト除外にする)
let g:PHP_vintage_case_default_indent = 1 " switch文でcaseをインデントする
"let php_folding = 0 " クラスと関数の折りたたみ(folding)を有効にする (重い)
" augroup php
"     autocmd!
"     au Syntax php set foldmethod=syntax
" augroup END
" " Vimテクニックバイブル1-13
" " PHPプログラムの構文チェック
" " http://d.hatena.ne.jp/i_ogi/20070321/1174495931
" autocmd FileType php setlocal makeprg=php\ -l\ % | setlocal errorformat=%m\ in\ %f\ on\ line\ %l
autocmd MyVimrc FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
" autocmd BufWrite *.php w | make
" "http://d.hatena.ne.jp/Cside/20110805/p1に構文チェックを非同期にやる方法が書いてある
"}}}
" Java {{{
" ==============================================================================
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
" ]}, [{ の移動先
let g:sql_type_default = 'mysql'
let g:ftplugin_sql_statements = 'create,alter'
" }}}
" yaml {{{
" ==============================================================================
" autocmd MyVimrc FileType yaml setlocal foldmethod=syntax
autocmd MyVimrc FileType yaml setlocal foldmethod=indent
" }}}
" vim {{{
" ==============================================================================
autocmd MyVimrc FileType vim
    \   nnoremap <buffer> <C-]> :<C-u>help<Space><C-r><C-w><Enter>
    \|  setlocal path&
    \|  setlocal path+=$VIMFILES/bundle
let g:vim_indent_cont = &sw
" }}}
" help {{{
" ==============================================================================
autocmd MyVimrc FileType help nnoremap <buffer><silent> q :q<CR>
" }}}
" Git {{{
" ==============================================================================
" コミットメッセージは72文字で折り返す
" http://keijinsonyaban.blogspot.jp/2011/01/git.html
autocmd MyVimrc BufRead */.git/COMMIT_EDITMSG
    \   setlocal textwidth=72
    \|  setlocal colorcolumn=+1
    \|  startinsert
" }}}
" crontab {{{
" ==============================================================================
autocmd MyVimrc FileType crontab setlocal backupcopy=yes
"}}}
" tsv {{{
" ==============================================================================
autocmd MyVimrc BufRead,BufNewFile *.tsv setlocal noexpandtab
" }}}
" ==== filetype ==== }}}
" ==== Plugin ==== {{{
" sudo.vim {{{
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if g:has_plugin('sudo')
    if g:has_plugin('bclose')
        nmap <Leader>E :e sudo:%<CR><C-^><Plug>Kwbd
    else
        nnoremap <Leader>E :e sudo:%<CR><C-^>:bd<CR>
    endif
    nnoremap <Leader>W :w sudo:%<CR>
endif
"}}}
" LeafCage/yankround.vim {{{
" ==============================================================================
if g:has_plugin('yankround')
    let g:yankround_dir = $VIMFILES.'/.yankround'

    nmap p <Plug>(yankround-p)
    nmap P <Plug>(yankround-P)
    nmap gp <Plug>(yankround-gp)
    nmap gP <Plug>(yankround-gP)
    nmap <expr><C-p> yankround#is_active() ? "\<Plug>(yankround-prev)"  : "gT"
    nmap <expr><C-n> yankround#is_active() ? "\<Plug>(yankround-next))" : "gt"
else
    nnoremap <C-p> gT
    nnoremap <C-n> gt
endif

"}}}
" minibufexpl.vim {{{
" ==============================================================================
if g:has_plugin('minibufexpl')
    " Put new window below current or on the right for vertical split
    let g:miniBufExplSplitBelow=0
    "hi MBEVisibleActive guifg=#A6DB29 guibg=fg
    "hi MBEVisibleChangedActive guifg=#F1266F guibg=fg
    " hi MBEVisibleActive ctermfg=252 ctermbg=125
    " hi MBEVisibleChangedActive ctermfg=16 ctermbg=125
    "hi MBEVisibleChanged guifg=#F1266F guibg=fg
    "hi MBEVisibleNormal guifg=#5DC2D6 guibg=fg
    "hi MBEChanged guifg=#CD5907 guibg=fg
    "hi MBENormal guifg=#808080 guibg=fg
    "hi MBENormal guifg=#CD5907 guibg=fg
    hi MBENormal ctermfg=252

    "function! Md()
    "    return expand("%:p")
    "    "echo "a"
    "    "set paste
    "endfunction
    ""let g:statusLineText = "-MiniBufExplorer-" . Md()
    "let g:statusLineText = Md()
endif
"}}}
" bclose.vim {{{
" ==============================================================================
" バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
" https://github.com/rgarver/Kwbd.vim
if g:has_plugin('bclose')
    nmap <Leader>bd <Plug>Kwbd
endif
" }}}
" vim-powerline{{{
if g:has_plugin('Powerline')
    let g:Powerline_dividers_override = ['>>', '>', '<<', '<']
    "let g:Powerline_theme = 'skwp'
    "let g:Powerline_colorscheme = 'skwp'
    "let g:Powerline_colorscheme = 'default_customized'
    let g:Powerline_stl_path_style = 'short'
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
" colorscheme {{{
" ------------------------------------------------------------------------------
if s:is_installed('molokai')
    "let g:rehash256 = 1
    set background=dark
    colorscheme molokai
" if g:has_plugin('solarized')
"     set background=dark
"     colorscheme solarized
"     let g:solarized_termcolors=256
"     " let g:solarized_contrast = "high"
"     " set background=light
else
    colorscheme default
endif
"set background=light
"let g:solarized_termcolors=256
"colorscheme solarized
" let g:lucius_contrast_bg = 'high'
"}}}
" vim-smartword {{{
" ==============================================================================
if s:is_installed("vim-smartword")
    map w <Plug>(smartword-w)
    map b <Plug>(smartword-b)
    map e <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)
endif
"}}}
if g:has_plugin('neobundle') && (v:version >= 703 || v:version == 702 && has('patch051'))
" Shougo/unite.vim {{{
" ==========================================================================
if s:is_installed('unite.vim')
    let g:unite_data_directory = $VIMFILES.'/.unite'
    let g:unite_enable_start_insert = 1
    let g:unite_split_rule = "botright"
    let g:unite_winheight = "15"
    nnoremap [unite] <Nop>
    nmap , [unite]

    " カレントディレクトリ以下のファイル
    nnoremap [unite]fc :<C-u>Unite file_rec<CR>
    " プロジェクトディレクトリ以下のファイル
    " nnoremap [unite]fp :<C-u>Unite file_rec:!<CR>
    nnoremap [unite]fp :<C-u>call <SID>unite_file_project('-start-insert')<CR>
    function! s:unite_file_project(...)
        let opts = (a:0 ? join(a:000, ' ') : '')
        let dir = unite#util#path2project_directory(expand('%'))
        " windowsでドライブのC:をC\:に変更する必要がある
        execute 'Unite' opts 'file_rec:' . escape(dir, ':')
    endfunction
    " bundle以下のファイル
    " call unite#custom#source('file_rec','ignore_patten','.*\.neobundle/.*')
    " カレントディレクトリ以下のディレクトリ
    nnoremap <silent> [unite]d<CR> :<C-u>Unite directory<CR>
    execute 'nnoremap <silent> [unite]dv :<C-u>Unite directory:' . $VIMFILES . '/bundle<CR>'
    call unite#custom_default_action('source/directory/directory' , 'vimfiler')
    " バッファ
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
    "最近使用したファイル一覧
    nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
    "最近使用したディレクトリ一覧
    nnoremap <silent> [unite]M :<C-u>Unite directory_mru<CR>
    call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')

    " ファイル内検索結果
    nnoremap <silent> [unite]l :<C-u>Unite line<CR>

    " Unite grep {{{
    " -------------------------------------------------------------------------
    if executable('grep')
        let g:unite_source_grep_command = 'grep'
        let g:unite_source_grep_default_opts = '-inH'
        let g:unite_source_grep_recursive_opt = '-r'
    endif

    let g:unite_source_grep_max_candidates = 1000

    " カレントディレクトリに対してgrep
    nnoremap [unite]gc :<C-u>Unite grep:.<CR>
    " 全バッファに対してgrep
    nnoremap [unite]gb :<C-u>Unite grep:$buffers<CR>
    " プロジェクト内のファイルに対してgrep
    nnoremap [unite]gp :<C-u>call <SID>unite_grep_project('-start-insert')<CR>
    function! s:unite_grep_project(...)
        let opts = (a:0 ? join(a:000, ' ') : '')
        let dir = unite#util#path2project_directory(expand('%'))
        " windowsでドライブのC:をC\:に変更する必要がある
        execute 'Unite' opts 'grep:' . escape(dir, ':')
    endfunction
    "}}}

    "レジスタ一覧
    nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
    " ヤンク履歴
    let g:unite_source_history_yank_enable = 1  "history/yankの有効化
    nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
    " ブックマーク
    nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>
    "call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

    " vimfilerがどんどん増えちゃう
    call unite#custom_default_action('directory' , 'vimfiler')
    " vimfiler上ではvimfilerを増やさず、移動するだけ
    autocmd MyVimrc FileType vimfiler
        \   call unite#custom_default_action('directory', 'lcd')

    let g:unite_source_find_max_candidates = 1000
endif
"}}}
" h1mesuke/unite-outline {{{
" =========================================================================
nnoremap [unite]o :<C-u>Unite outline<CR>
" }}}
" tacroe/unite-mark {{{
" =========================================================================
nnoremap [unite]` :<C-u>Unite mark<CR>
" }}}
" tsukkee/unite-tag {{{
" =========================================================================
nnoremap [unite]t :<C-u>Unite tag<CR>

augroup unite-tag
    autocmd!
    autocmd BufEnter *
                \ if empty(&buftype) && &filetype != 'vim'
                \| nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
                \| endif
augroup END
" }}}
" vimfiler {{{
" ==============================================================================
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0

let g:vimfiler_data_directory = $VIMFILES.'/.vimfiler'

nnoremap [VIMFILER] <Nop>
nmap <Leader>f [VIMFILER]
nnoremap <silent> [VIMFILER]f :VimFiler<CR>
nnoremap <silent> [VIMFILER]b    :VimFilerBufferDir<CR>
nnoremap <silent> [VIMFILER]c    :VimFilerCurrentDir<CR>

autocmd MyVimrc FileType vimfiler
    \   nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)
"}}}
" vimshell {{{
" ==============================================================================
if s:is_installed('vimshell')
    nmap <leader>H [VIMSHELL]
    nnoremap [VIMSHELL]H  :VimShellPop<CR>
    nnoremap [VIMSHELL]b  :VimShellBufferDir -popup<CR>
    nnoremap [VIMSHELL]c  :VimShellCurrentDir -popup<CR>
    nnoremap [VIMSHELL]i  :VimShellInteractive<Space>
    nnoremap [VIMSHELL]py :VimShellInteractive python<CR>
    nnoremap [VIMSHELL]ph :VimShellInteractive php<CR>
    nnoremap [VIMSHELL]rb :VimShellInteractive irb<CR>
    nnoremap [VIMSHELL]s  :VimShellSendString<CR>

    let s:hooks = neobundle#get_hooks("vimshell")
    function! s:hooks.on_source(bundle)
        nnoremap [VIMSHELL] <Nop>
        " <Leader>ss: 非同期で開いたインタプリタに現在の行を評価させる
        "vmap <silent> <Leader>ss :VimShellSendString<CR>
        "" 選択中に<Leader>ss: 非同期で開いたインタプリタに選択行を評価させる
        "nnoremap <silent> <Leader>ss <S-v>:VimShellSendString<CR>

        if has('mac')
            call vimshell#set_execute_file('html', 'gexe open -a /Applications/Firefox.app/Contents/MacOS/firefox')
            call vimshell#set_execute_file('avi,mp4,mpg,ogm,mkv,wmv,mov', 'gexe open -a /Applications/MPlayerX.app/Contents/MacOS/MPlayerX')
        endif

        let g:vimshell_prompt = hostname() . "> "
        let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
        let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b] ", "(%s)-[%b|%a] ")' " Shougo/vim-vcs is required

        let g:vimshell_temporary_directory = $VIMFILES.'/.vimshell'

        let g:vimshell_max_command_history = 3000


        autocmd MyVimrc FileType vimshell
            \   setlocal nonumber
            \|  setlocal nocursorline
            \|  nmap <buffer> q <Plug>(vimshell_hide)<C-w>=
            \|  imap <expr> <buffer> <C-n> pumvisible() ? "\<C-n>" : "\<Plug>(vimshell_history_neocomplete)"
            \|  imap <buffer><C-k> <Plug>(vimshell_zsh_complete)
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
    endfunction
endif
" }}}
" neocomplcache & neocomplete {{{
" ==============================================================================
if s:is_installed('neocomplcache') || s:is_installed('neocomplete')
    if s:is_installed("neocomplete")
        let s:hooks = neobundle#get_hooks("neocomplete")
        let s:neocom = 'neocomplete'
        let s:neocom_ = 'neocomplete#'
    else
        let s:hooks = neobundle#get_hooks("neocomplcache")
        let s:neocom = 'neocomplcache'
        let s:neocom_ = 'neocomplcache_'
    endif

    function! s:hooks.on_source(bundle)
        " Disable AutoComplPop.
        let g:acp_enableAtStartup = 0
        " Use neocomplcache.
        execute 'let g:'.s:neocom_.'enable_at_startup = 1'
        " Use smartcase.
        execute 'let g:'.s:neocom_.'enable_smart_case = 1'
        execute 'let g:'.s:neocom_.'enable_ignore_case = 1'
        " Use camel case completion.
        let g:neocomplcache_enable_camel_case_completion = 1
        " Use underbar completion.
        let g:neocomplcache_enable_underbar_completion = 1 " Deleted
        " Set minimum syntax keyword length.
        if s:is_installed('neocomplete')
            let g:neocomplete#sources#syntax#min_syntax_length = 3
        else
            let g:neocomplcache_min_syntax_length = 3
        endif
        execute 'let g:'.s:neocom_.'lock_buffer_name_pattern = "\\*ku\\*"'

        " 補完候補取得に時間がかかっても補完をskipしない
        execute 'let g:'.s:neocom_.'skip_auto_completion_time = ""'
        " 候補の数を増やす
        execute 'let g:'.s:neocom_.'max_list = 3000'

        " execute 'let g:'.s:neocom_.'force_overwrite_completefunc = 1'

        execute 'let g:'.s:neocom_.'enable_auto_close_preview=0'
        autocmd MyVimrc InsertLeave * if pumvisible() == 0 | pclose | endif

        let g:neocomplcache_enable_auto_delimiter = 0

        " 使用する補完の種類を減らす
        " http://alpaca-tc.github.io/blog/vim/neocomplete-vs-youcompleteme.html
        " 現在のSourceの取得は `:echo
        " keys(neocomplete#variables#get_sources())`
        " " デフォルト: ['file', 'tag', 'neosnippet', 'vim', 'dictionary',
        " 'omni', 'member', 'syntax', 'include', 'buffer', 'file/include']
        " let g:neocomplete#sources = {
        "   \ '_' : ['vim', 'omni', 'include', 'buffer', 'file/include']
        "     \ }

        if s:is_installed('neocomplete')
            let g:neocomplete#data_directory = $VIMFILES . '/.neocomplete'
        else
            let g:neocomplcache_temporary_dir = $VIMFILES . '/.neocomplcache'
        endif
        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
                    \ 'default'  : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme'   : $HOME.'/.gosh_completions'
                    \ }

        let g:neocomplcache_ignore_composite_filetype_lists = {
                    \ 'php.phpunit': 'php',
                    \}

        " Define keyword.
        if !exists('g:neocomplcache_keyword_patterns')
            let g:neocomplcache_keyword_patterns = {}
        endif
        let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

        if neobundle#is_installed("neocomplete")
            call neocomplete#custom#source('member', 'rank', 110)
        endif

        " Enable omni completion.
        augroup MyVimrc
            autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType php           setlocal omnifunc=phpcomplete#CompletePHP
            autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
            autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        augroup END

        if executable('uname') && (system('uname -a') =~ 'FreeBSD 4' || system('uname -a') =~ 'FreeBSD 6')
            " スペックが低いマシーンでは有効にしない
        else
            " Enable heavy omni completion.
            if !exists('g:neocomplcache_omni_patterns')
                let g:neocomplcache_omni_patterns = {}
            endif

            let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.c    = '\%(\.\|->\)\h\w*'
            let g:neocomplcache_omni_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
            "let g:neocomplcache_omni_patterns.java  = '.*'
        endif

        " include補完
        "インクルードパスの指定
        " let g:neocomplcache_include_paths = {
        "             \ 'cpp' : '.,/opt/local/include/gcc46/c++,/opt/local/include,/usr/include',
        "             \ 'c' : '.,/usr/include',
        "             \ 'ruby' : '.,$HOME/.rvm/rubies/**/lib/ruby/1.8/',
        "             \ 'java' : '.,$HOME/AppData/Local/Android/android-sdk/sources/',
        "             \ }
        "\ 'perl' : '$HOME/perl5/lib/perl5/cygwin-thread-multi-64int,$HOME/perl5/lib/perl5/cygwin-thread-multi-64int,$HOME/perl5/lib/perl5,$HOME/perl5/lib/perl5/cygwin-thread-multi-64int,$HOME/perl5/lib/perl5,/usr/lib/perl5/site_perl/5.14/i686-cygwin-threads-64int,/usr/lib/perl5/site_perl/5.14,/usr/lib/perl5/vendor_perl/5.14/i686-cygwin-threads-64int,/usr/lib/perl5/vendor_perl/5.14,/usr/lib/perl5/5.14/i686-cygwin-threads-64int,/usr/lib/perl5/5.14,/usr/lib/perl5/site_perl/5.10,/usr/lib/perl5/vendor_perl/5.10,/usr/lib/perl5/site_perl/5.8,,',
        "インクルード文のパターンを指定
        " let g:neocomplcache_include_patterns = {
        "             \ 'cpp' : '^\s*#\s*include',
        "             \ 'ruby' : '^\s*require',
        "             \ }
        "             "\ 'perl' : '^\s*use',
        " "インクルード先のファイル名の解析パターン
        " let g:neocomplcache_include_exprs = {
        "             \ 'ruby' : substitute(v:fname,'::','/','g'),
        "             \ }
        "             "\ 'perl' : substitute(substitute(v:fname,'::','/','g'),'$','.pm','')
        " " ファイルを探す際に、この値を末尾に追加したファイルも探す。
        " let g:neocomplcache_include_suffixes = {
        "             \ 'ruby' : '.rb',
        "             \ 'haskell' : '.hs'
        "             \ }
        "let g:neocomplcache_include_max_processes = 1000

        " key mappings
        execute 'inoremap <expr><C-g>  pumvisible() ? '.s:neocom.'#undo_completion() : \<C-g>'
        execute 'inoremap <expr><C-l>  pumvisible() ? '.s:neocom.'#complete_common_string() : '.s:neocom.'#start_manual_complete()'
        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        execute 'inoremap <expr><CR>  '.s:neocom.'#smart_close_popup() . "\<CR>"'
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " <C-h>, <BS>: close popup and delete backword char.
        execute 'inoremap <expr><C-h>  '.s:neocom.'#smart_close_popup()."\<C-h>"'
        execute 'inoremap <expr><BS>   '.s:neocom.'#smart_close_popup()."\<C-h>"'
        " execute 'inoremap <expr><C-y>  '.s:neocom.'#close_popup()'
        " 補完候補が表示されている場合は確定。そうでない場合は改行
        " execute 'inoremap <expr><CR>  pumvisible() ? ' . s:neocom.'#close_popup() : "<CR>"'
        execute 'inoremap <expr><C-e>  pumvisible() ? '.s:neocom.'#cancel_popup() : "\<End>"'
        " <C-u>, <C-w>した文字列をアンドゥできるようにする
        " http://vim-users.jp/2009/10/hack81/
        " C-uでポップアップを消したいがうまくいかない
        execute 'inoremap <expr><C-u>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-u>" : "\<C-g>u<C-u>"'
        execute 'inoremap <expr><C-w>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-w>" : "\<C-g>u<C-w>"'
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
    endfunction
endif
"}}}
" Valloric/Youcompleteme {{{
" ==============================================================================
let g:ycm_filetype_whitelist = { 'java': 1 }
" }}}
" neosnippet {{{
" ==============================================================================
if s:is_installed('neosnippet')
    let s:hooks = neobundle#get_hooks("neosnippet")

    function! s:hooks.on_source(bundle)
        " Plugin key-mappings.
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " Enable snipMate compatibility feature.
        let g:neosnippet#enable_snipmate_compatibility = 1

        " Tell Neosnippet about the other snippets
        if filereadable(expand('~/.vim/bundle/vim-snippets/snippets'))
            let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
        endif
    endfunction
endif
" }}}
" vim-quickrun {{{
" ==============================================================================
if s:is_installed('vim-quickrun')
    noremap <Leader>r :QuickRun<CR>
    noremap <Leader>r :QuickRun<CR>
    " let g:quickrun_no_default_key_mappings = 1
    " map <Leader>r <Plug>(quickrun)
    " <C-c> で実行を強制終了させる
    " quickrun.vim が実行していない場合には <C-c> を呼び出す
    nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

    let g:quickrun_config = {}
    let g:quickrun_config['_'] = {
                \   'runner'                    : 'vimproc',
                \   'runner/vimproc/updatetime' : 100,
                \   'outputter'                 : 'multi:buffer:quickfix',
                \   'outputter/buffer/split'    : ''
                \}

    " \   'outputter/multi/targets'   : [ 'buffer', 'quickfix' ],
    " \   'outputter' : 'my_outputter',
    " \   'outputter'                 : 'unite_quickfix',

    " :QuickRun -outputter my_outputter {{{
    " プロセスの実行中は、buffer に出力し、
    " プロセスが終了したら、quickfix へ出力を行う

    " 既存の outputter をコピーして拡張
    let my_outputter = quickrun#outputter#multi#new()
    let my_outputter.config.targets = ["buffer", "quickfix"]

    function! my_outputter.init(session)
        " quickfix を閉じる
        :cclose
        " 元の処理を呼び出す
        call call(quickrun#outputter#multi#new().init, [a:session], self)
    endfunction

    function! my_outputter.finish(session)
        call call(quickrun#outputter#multi#new().finish, [a:session], self)
        " 出力バッファの削除
        bwipeout [quickrun
        " vim-hier を使用している場合は、ハイライトを更新したりとか
        " :HierUpdate
    endfunction

    " quickrun に outputter を登録
    call quickrun#register_outputter("my_outputter", my_outputter)
" }}}

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

" Android Dev {{{
" --------------------------------------------------------------------------
function! s:QuickRunAndroidProject()
    let l:project_dir = unite#util#path2project_directory(expand('%'))

    for l:line in readfile(l:project_dir.'/AndroidManifest.xml')
        " package名の取得
        " ex) com.sample.helloworld
        if !empty(matchstr(l:line, 'package="\zs.*\ze"'))
            let l:package = matchstr(l:line, 'package="\zs.*\ze"')
            continue
        endif

        " android:nameの取得
        " ex) com.sample.helloworld.HelloWorldActivity
        if !empty(matchstr(l:line, 'android:name="\zs.*\ze"'))
            let l:android_name = matchstr(l:line, 'android:name="\zs.*\ze"')
            break
        endif
    endfor

    if empty(l:package)
        echo 'package名が見つかりません'
        return -1
    elseif empty(l:android_name)
        echo 'android:nameが見つかりません'
        return -1
    endif

    let l:apk_file = l:project_dir.'/bin/'.matchstr(l:android_name, '[^.]\+$').'-debug.apk'
    " ex) com.sample.helloworld/.HelloWorldActivity
    let l:component = substitute(l:android_name, '\zs\.\ze[^.]*$', '/.', '')

    let g:quickrun_config['androidProject'] = {
                \   'hook/cd/directory'           : l:project_dir,
                \   'hook/output_encode/encoding' : 'sjis',
                \   'exec'                        : [
                \       'android update project --path .',
                \       'ant debug',
                \       'adb -d install -r '.l:apk_file,
                \       'adb shell am start -a android.intent.action.MAIN -n '.l:package.'/'.l:android_name
                \   ]
                \}

    QuickRun androidProject
endfunction

command! QuickRunAndroidProject :call s:QuickRunAndroidProject()
autocmd MyVimrc BufRead,BufNewFile */workspace/* nnoremap <buffer> <Leader>r :QuickRunAndroidProject<CR>
"}}}

" let g:quickrun_config['node'] = {
"             \   'runner/vimproc/updatetime' : 1000,
"             \   'command'                : 'tail',
"             \   'cmdopt'                 : '',
"             \   'exec'                   : '%c %o ~/git/jidaraku_schedular/log',
"             \   'outputter/multi'   : [ 'buffer', 'quickfix' , 'message'],
"             \}
" "
" set errorformat=debug:\%s
endif
"}}}
" operator {{{
" ==============================================================================
if s:is_installed("vim-operator-user")
    " clipboard copyのoperator
    " http://www.infiniteloop.co.jp/blog/2011/11/vim-operator/
    function! OperatorYankClipboard(motion_wiseness)
        let visual_commnad =
            \ operator#user#visual_command_from_wise_name(a:motion_wiseness)
        execute 'normal!' '`['.visual_commnad.'`]"+y'
    endfunction

    call operator#user#define('yank-clipboard', 'OperatorYankClipboard')
    map [Space]y <Plug>(operator-yank-clipboard)

    if neobundle#is_installed("operator-camelize.vim")
        map [Space]c <Plug>(operator-camelize-toggle)
    endif
    if neobundle#is_installed("vim-operator-replace")
        map [Space]p <Plug>(operator-replace)
        map [Space]P "+<Plug>(operator-replace)
    endif
    if neobundle#is_installed("vim-operator-search")
        map [Space]/ <Plug>(operator-search)
    endif
    if neobundle#is_installed("vim-operator-surround")
        map sa <Plug>(operator-surround-append)
        map sd <Plug>(operator-surround-delete)
        map sr <Plug>(operator-surround-replace)
    endif
endif
" }}}
" textobj {{{
if neobundle#is_installed("vim-textobj-lastpat")
    nmap gn <Plug>(textobj-lastpat-n)
    nmap gN <Plug>(textobj-lastpat-N)
endif
" }}}
" vim-easymotion {{{
" ==============================================================================
if s:is_installed('vim-easymotion')
    let g:EasyMotion_leader_key = '<Leader>/'
    let g:EasyMotion_keys = 'asdfgghjkl;:qwertyuiop@zxcvbnm,./1234567890-'
    " let g:EasyMotion_mapping_f = '+'
    " let g:EasyMotion_mapping_F = '-'
endif
"}}}
" vim-partedit {{{
" =============================================================================
if s:is_installed('vim-partedit')
    let g:partedit#auto_prefix = 0
endif
"}}}
" vim-visualstar {{{
" ==============================================================================
if s:is_installed('vim-visualstar')
    map * <Plug>(visualstar-*)N
    map # <Plug>(visualstar-g*)N
endif "}}}
" vim-alignta {{{
" ==============================================================================
if s:is_installed('vim-alignta')
    xnoremap [ALIGNTA] <Nop>
    xmap <Leader>a [ALIGNTA]
    xnoremap [ALIGNTA]s :Alignta \S\+<CR>
    xnoremap [ALIGNTA]= :Alignta =<CR>
    xnoremap [ALIGNTA]> :Alignta =><CR>
    xnoremap [ALIGNTA]: :Alignta :<CR>
endif
" }}}
" caw {{{
" ==============================================================================
" http://d.hatena.ne.jp/osyo-manga/20120106/1325815224
if s:is_installed('caw.vim')
    " コメントアウトのトグル
    nmap <Leader>cc <Plug>(caw:i:toggle)
    xmap <Leader>cc <Plug>(caw:i:toggle)
    " http://d.hatena.ne.jp/osyo-manga/20120303/1330731434
    " 現在の行をコメントアウトして下にコピー
    nmap <Leader>cy yyPgcij
    xmap <Leader>cy ygvgcigv<C-c>p
endif
"}}}
" vim-jsbeautify {{{
" ==============================================================================
if s:is_installed('vim-jsbeautify')
    autocmd MyVimrc FileType javascript
        \   setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType css
        \   setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType html
        \   setlocal formatexpr=JsBeautify()
endif
"}}}
" automatic {{{
" ==============================================================================
" http://d.hatena.ne.jp/osyo-manga/20130812/1376314945
" http://blog.supermomonga.com/articles/vim/automatic.html
let g:automatic_default_set_config = {
            \   'height' : '20%',
            \   'move' : 'bottom',
            \ }
let g:automatic_config = [
            \   {
            \       'match' : {'bufname' : 'vimshell'}
            \   }
            \]
" }}}
" foldCC {{{
" ------------------------------------------------------------------------------
" http://leafcage.hateblo.jp/entry/2013/04/24/053113
if neobundle#is_installed('foldCC')
    set foldtext=foldCC#foldtext()
    set foldcolumn=1
    set fillchars=vert:\|
    let g:foldCCtext_head = '"+ " . v:folddashes . " "'
    let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'
    nnoremap <Leader><C-g> :echo foldCC#navi()<CR>
    nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'
endif
" 現在のカーソルの位置以外の折りたたみを閉じる
nnoremap z- zMzv
" }}}
" savevers.vim {{{
" ---------------
set backup
set patchmode=.clean

let g:versdiff_no_resize = 0

autocmd MyVimrc BufEnter * call UpdateSaveversDir()
function! UpdateSaveversDir()
    if filereadable(expand('%'))
        let s:basedir = $VIMFILES . "/.savevers"
        " ドライブ名を変更して、連結する (e.g. C: -> /C/)
        let s:dir = s:basedir . substitute(expand("%:p:h"), '\v\c^([a-z]):', '/\1/' , '')
        if !isdirectory(s:dir)
            call mkdir(s:dir, "p")
        endif

        let g:savevers_dirs = s:dir
    endif
endfunction
" }}}
" eclim {{{
" -----
if s:is_installed('eclim')
    let s:hooks = neobundle#get_hooks("eclim")

    function! s:hooks.on_source(bundle)
        " neocomplcacheで補完するため
        let g:EclimCompletionMethod = 'omnifunc'
        autocmd MyVimrc FileType java
                    \   setlocal omnifunc=eclim#java#complete#CodeComplete
                    \|  setlocal completeopt-=preview " neocomplete使用時にpreviewが重いので
        nnoremap [eclim] <Nop>
        nmap <Leader>e [eclim]
        nnoremap [eclim]pi :ProjectInfo<CR>
        nnoremap [eclim]pp :ProjectProblems!<CR>
        nnoremap [eclim]c :OpenUrl http://eclim.org/cheatsheet.html<CR>
        nnoremap [eclim]jc :JavaCorrect<CR>
        nnoremap [eclim]ji :JavaImportOrganize<CR>

    endfunction
endif
" }}}
" console.vim {{{
" ==============================================================================
if s:is_installed('vimconsole.vim')
    let g:vimconsole#auto_redraw = 1
    augroup MyVimrc
        autocmd FileType vim,vimconsole
                    \    nnoremap <buffer> <F12> :VimConsoleToggle<CR>
                    \ |  nnoremap <buffer> <C-l> :VimConsoleClear<CR>
    augroup END
endif
" }}}
" instant-markdown-vim {{{
" ==============================================================================
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0
autocmd MyVimrc FileType markdown nnoremap <buffer> <Leader>r :InstantMarkdownPreview<CR>
" }}}
" vim-fugitive {{{
" ------------
if s:is_installed('vim-fugitive')
    let s:hooks = neobundle#get_hooks("vim-fugitive")

    function! s:hooks.on_source(bundle)
        nnoremap [fugitive] <Nop>
        nmap <Leader>g [fugitive]
        noremap [fugitive]d :Gdiff<CR>
        noremap [fugitive]s :Gstatus<CR>
        noremap [fugitive]l :Glog<CR>
        noremap [fugitive]p :Git pull --rebase origin master<CR>
    endfunction
endif
" }}}
" gitv {{{
" --------
let s:hooks = neobundle#get_hooks('gitv')

function! s:hooks.on_source(bundle)
    function! GitvGetCurrentHash()
        return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
    endfunction

    autocmd MyVimrc FileType gitv
        \   setlocal iskeyword+=/,-,.
        \|  nnoremap <buffer> C :<C-u>Git checkout <C-r><C-w><CR>
        \|  nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
        \|  nnoremap <buffer> <Space>rv :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
        \|  nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
        \|  nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
endfunction
" }}}
" open-browser.vim {{{
" ==============================================================================
if s:is_installed("open-browser.vim")
    let g:netrw_nogx = 1 " disable netrw's gx mapping.
    let g:openbrowser_open_filepath_in_vim = 0 " Vimで開かずに関連付けされたプログラムで開く
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)
    nmap <C-LeftMouse> <Plug>(openbrowser-smart-search)
    vmap <C-LeftMouse> <Plug>(openbrowser-smart-search)
    " nmap gx <Plug>(openbrowser-open)
    " vmap gx <Plug>(openbrowser-open)
    " nmap <2-LeftMouse> <Plug>(openbrowser-open)
    " vmap <2-LeftMouse> <Plug>(openbrowser-open)
endif
" }}}
" glidenote/memoliset.vim {{{
" ==============================================================================
if s:is_installed('memolist.vim')
    nnoremap <Leader>mn  :MemoNew<CR>
    nnoremap <Leader>ml  :MemoList<CR>
    nnoremap <Leader>mg  :MemoGrep<CR>

    let g:memolist_path = expand('~/Dropbox/memo')
    let g:memolist_memo_suffix = "md"
    let g:memolist_unite = 1
endif
" }}}
" fuenor/qfixhowm {{{
" ==============================================================================
" QFixHowm互換を切る
let QFixHowm_Convert = 0
" デフォルトの保存先
let qfixmemo_dir = $HOME . '/Dropbox/qfixmemo'
" ファイルタイプをmarkdownにする
let QFixHowm_FileType = 'markdown'
" タイトル記号を # に変更する
let QFixHowm_Title = '#'
" }}}
endif
" ==== Plugin ==== }}}
if !has('gui_running') && filereadable(expand('~/.cvimrc'))
    source ~/.cvimrc
endif

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
