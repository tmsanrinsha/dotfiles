scriptencoding utf-8

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('mac') && has('kaoriya')
    set runtimepath-=$VIM/plugins/vimproc
endif

" neobundle.vim がなければgit clone
let s:neobundle_repo_dir = expand('~/.vim/bundle/neobundle.vim')

if !isdirectory(s:neobundle_repo_dir)
    echo 'git clone https://github.com/Shougo/neobundle.vim '.s:neobundle_repo_dir
    call system('git clone https://github.com/Shougo/neobundle.vim '.s:neobundle_repo_dir)
endif

" neobundleが使えない環境用
if !MyHasPatch('patch-7.2.051')
    " neobundleが使えない場合
    " bundle以下にあるpluginをいくつかruntimepathへ追加する
    let s:load_plugin_list = [
    \   'sudo.vim', 'my_molokai', 'vim-smartword'
    \]
    " for path in split(glob($HOME.'/.vim/bundle/*'), '\n')
    "     let s:plugin_name = matchstr(path, '[^/]\+$')
    "     if isdirectory(path) && index(s:load_plugin_list, s:plugin_name) >= 0
    "         let &runtimepath = &runtimepath.','.path
    "     end
    " endfor
    for s:plugin in s:load_plugin_list
        if isdirectory($HOME.'/.vim/bundle/'.s:plugin)
            let &runtimepath = &runtimepath.','.$HOME.'/.vim/bundle/'.s:plugin
        endif
    endfor

    filetype plugin indent on
    finish
endif


if has('vim_starting')
    if &compatible
        set nocompatible               " Be iMproved
    endif

    " Required:
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

let g:neobundle#install_process_timeout = 2000

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" キャッシュを使うとUnite.vimの調子が悪い気がしたが、オッケーそうなので使う
" if neobundle#load_cache(
" \  expand('~/.vim/rc/bundle.vim'),
" \  expand('~/.vim/rc/bundle_local.vim')
" \)

" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim'

" 非同期処理 vimproc {{{1
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ 'disabled': has('win32') && has('kaoriya'),
\ }
" NeoBundle 'tpope/vim-dispatch'

" vital {{{1
NeoBundle 'vim-jp/vital.vim'
NeoBundle 'osyo-manga/vital-coaster'
" NeoBundleLazy 'osyo-manga/vital-coaster', {
" \   'on_map': ['<Plug>(my-increment)', '<Plug>(my-decriment)'],
" \   'depends': ['vim-jp/vital.vim']
" \}

" unite {{{1
" ============================================================================
if v:version > 702
    " vimfiler.vimをon_sourceしないと、$ vim .で起動するときにエラーが出る
    NeoBundleLazy 'Shougo/unite.vim', {
    \   'on_cmd': 'Unite',
    \}

    " Why on_unite feature has been deleted? · Issue #495 · Shougo/neobundle.vim
    " https://github.com/Shougo/neobundle.vim/issues/495
    NeoBundleLazy 'Shougo/neomru.vim', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'Shougo/neossh.vim', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'Shougo/unite-outline', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'tacroe/unite-mark', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'tsukkee/unite-tag', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'ujihisa/unite-locate', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'basyura/unite-mdfind', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'Shougo/neoyank.vim', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'thinca/vim-unite-history', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'tmsanrinsha/unite-ghq', {
    \   'on_source': 'unite.vim'
    \}
    NeoBundleLazy 'rhysd/unite-zsh-cdr.vim', {
    \   'on_source': 'unite.vim'
    \}
    " NeoBundle 'Shougo/unite-sudo'
endif

" qfreplace {{{1
" ============================================================================
" http://archiva.jp/web/tool/vim_grep2.html
NeoBundleLazy 'thinca/vim-qfreplace', {
\   'on_source': 'unite.vim'
\}

" shell, filer {{{1
" ============================================================================
NeoBundleLazy 'Shougo/vimshell.vim', {
\   'on_cmd' : [ 'VimShell', "VimShellBufferDir", "VimShellInteractive", "VimShellPop" ],
\   'depends' : ['Shougo/vim-vcs', 'Shougo/unite.vim']
\}
NeoBundleLazy 'ujihisa/vimshell-ssh', {
\   'on_source': ['unite.vim', 'vimshell.vim']
\}
NeoBundleLazy 'oplatek/Conque-Shell', {
\   'on_cmd': ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit']
\}
" $ vim .でVimFilerが開かないので下でNeoBundleSourceしている
if v:version > 702
    NeoBundleLazy 'Shougo/vimfiler.vim', {
    \   'depends': 'unite.vim'
    \}
endif

" 補完・入力補助 {{{1
" ============================================================================
"" 自動補完 {{{2
NeoBundleLazy "Shougo/neocomplete.vim", {
\   'on_i': 1,
\   'depends' : [
\       'Shougo/context_filetype.vim',
\       'Shougo/neoinclude.vim',
\       'Shougo/neco-syntax',
\       'Shougo/neosnippet.vim',
\       'Shougo/neosnippet-snippets',
\       'honza/vim-snippets',
\   ],
\   "disabled": !has('lua'),
\   "vim_version": '7.3.825',
\}
" \       'SirVer/ultisnips',
NeoBundleLazy "Shougo/neco-vim", {
\   'autoload': {'filetypes': 'vim'},
\   "disabled": !has('lua'),
\   "vim_version": '7.3.825',
\}
NeoBundleLazy "ujihisa/neco-look", {
\   "autoload": {"insert": 1},
\   'external_commands': 'look',
\   "disabled": !has('lua'),
\   "vim_version": '7.3.825',
\}
NeoBundleLazy "Shougo/neocomplcache.vim", {
\   "autoload": {"insert": 1},
\   "disabled": has('lua'),
\}
" if has('python') && (v:version >= 704 || v:version == 703 && has('patch584'))
"     NeoBundle "Valloric/YouCompleteMe"
" endif

" 閉じ括弧などの対応するものの補完 {{{2
" NeoBundleLazy "kana/vim-smartinput", {"autoload": {"insert": 1}}
NeoBundleLazy "cohama/lexima.vim", {"autoload": {"insert": 1}}

" templete {{{1
" ============================================================================
NeoBundle 'thinca/vim-template'
" quickrun {{{1
" ============================================================================
" NeoBundleLazy 'thinca/vim-quickrun', {
" \   'autoload': {
" \       'commands': [{
" \           'name': 'QuickRun',
" \           'complete': 'customlist,quickrun#complete',
" \       }]
" \   },
" \   'depends': [
" \       'osyo-manga/shabadou.vim',
" \       'cohama/vim-hier',
" \       'dannyob/quickfixstatus',
" \       'KazuakiM/vim-qfsigns',
" \       'KazuakiM/vim-qfstatusline'
" \   ]
" \}
NeoBundle 'thinca/vim-quickrun', {
\   'depends': [
\       'osyo-manga/shabadou.vim',
\       'cohama/vim-hier',
\       'dannyob/quickfixstatus',
\       'KazuakiM/vim-qfsigns',
\   ]
\}
" \       'KazuakiM/vim-qfstatusline'

" syntax check, quickfix {{{1
" ============================================================================
" ファイルを保存時にシンタックスのチェック
" 同期処理なのでwatchldogsを使う
" NeoBundleLazy 'scrooloose/syntastic'

" dependsでquickrunを設定するとhookがうまくいかない
NeoBundleLazy 'osyo-manga/vim-watchdogs', {
\   'depends': [
\       'thinca/vim-quickrun',
\       'osyo-manga/shabadou.vim',
\       'cohama/vim-hier',
\       'dannyob/quickfixstatus',
\       'KazuakiM/vim-qfsigns',
\   ]
\}
" \       'KazuakiM/vim-qfstatusline'

" 現在のカーソル位置から見て次/前のquickfix/location listに飛ぶ
" http://www.vim.org/scripts/script.php?script_id=4449
NeoBundle 'QuickFixCurrentNumber', {
\   'depends': 'ingo-library'
\}

" operator {{{1
" ============================================================================
NeoBundleLazy "kana/vim-operator-user", {
\   'on_map': '<Plug>(operator-'
\}

NeoBundleLazy 'kana/vim-operator-replace', {
\   'depends': 'kana/vim-operator-user',
\   'on_map': '<Plug>(operator-replace)'
\}
NeoBundleLazy "osyo-manga/vim-operator-search", {
\   'depends': 'kana/vim-operator-user',
\   'on_map': '<Plug>(operator-search)'
\}
NeoBundle 'tpope/vim-surround'
NeoBundleLazy "rhysd/vim-operator-surround", {
\   'depends': 'kana/vim-operator-user',
\   'on_map': '<plug>(operator-surround-'
\}
NeoBundleLazy "tyru/operator-camelize.vim", {
\   'depends': 'kana/vim-operator-user',
\   'on_map': '<Plug>(operator-camelize-'
\}
" clipboardが使えない、もしくはsshで接続している時にvim-fakeclipを使う。
NeoBundle 'tmsanrinsha/vim-fakeclip', {
\   'disable': has('clipboard') && $SSH_CLIENT == ''
\}

" textobj {{{1
" ============================================================================
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kentaro/vim-textobj-function-php'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundleLazy 'glts/vim-textobj-comment', {
\   'on_map': '<Plug>(textobj-comment-'
\}
NeoBundleLazy 'osyo-manga/vim-textobj-context', {
\   'on_map': '<Plug>(textobj-context-'
\}
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundleLazy 'kana/vim-textobj-lastpat', {
\   'on_map': '<Plug>(textobj-lastpat-',
\   'disabled' : MyHasPatch('patch-7.3.610')
\}
" Gitでコンフリクトしている部分
" lazyはうまくいかない
" NeoBundleLazy 'rhysd/vim-textobj-conflict', {'on_map': '<Plug>(textobj-conflict'}
NeoBundle 'rhysd/vim-textobj-conflict'
" バッファ全体
NeoBundleLazy 'kana/vim-textobj-entire', {'on_map': '<Plug>(textobj-entire'}

NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'kana/vim-smartword', {
\   'on_map' : '<Plug>(smartword-'
\}
NeoBundleLazy 'haya14busa/vim-asterisk', {
\   'on_map': '<Plug>(asterisk-'
\ }
NeoBundle 'rhysd/clever-f.vim'

" Vimperatorのクイックヒント風にカーソル移動
NeoBundleLazy 'Lokaltog/vim-easymotion', {
\   'on_map': '<Plug>(easymotion-'
\}

" https://github.com/dahu/Severalections
NeoBundle 'terryma/vim-multiple-cursors'

NeoBundleLazy 'thinca/vim-ref', {
\   'autoload': {'commands': ['Ref', 'Man']}
\}

" カーソル位置のfiletypeを文脈から判断
NeoBundle 'Shougo/context_filetype.vim'
" 部分的に編集
NeoBundleLazy 'thinca/vim-partedit', {
\   'autoload': {'commands': 'Partedit'}
\}

" 整形
NeoBundle 'h1mesuke/vim-alignta'

" コメント操作
" NeoBundle "tyru/caw.vim"
" NeoBundle "tpope/vim-commentary"
NeoBundleLazy "tomtom/tcomment_vim", {
\   'on_map': ['<Plug>TComment_', 'gc'],
\}

NeoBundleLazy 'LeafCage/yankround.vim', {
\   'on_map': '<Plug>(yankround-',
\   'on_sources' : 'unite.vim',
\   'vim_version': '7.3'
\}

" open, gf {{{1
" ============================================================================
" すでにvimが起動しているときは、そちらで開く
NeoBundle 'thinca/vim-singleton', {
\ 'disabled': !has('clientserver'),
\ }
" vim path/to/file.ext:12:3 こういうに行と列を指定して開く
NeoBundle 'kopischke/vim-fetch'
NeoBundle 'kana/vim-gf-user' 
" lazyにするとGitvでの挙動がおかしくなる
NeoBundle 'kana/vim-gf-diff'
" }}}

" 一時バッファの制御
" NeoBundle 'osyo-manga/vim-automatic', {
" \   'depends': 'osyo-manga/vim-gift',
" \   'disable': !MyHasPatch('patch-7.3.462')
" \}

NeoBundle 'LeafCage/foldCC'
NeoBundleLazy 'thinca/vim-ft-help_fold', {
\   'autoload' : { 'filetypes' : ['help'] }
\ }

" sudo権限でファイルを開く・保存
NeoBundle 'sudo.vim'
" バッファを閉じた時、ウィンドウのレイアウトが崩れないようにする
" 保存してないバッファを閉じちゃうのでコメントアウト
" NeoBundle 'rgarver/Kwbd.vim'
" gundo.vim {{{
" undo履歴をtreeで見る
NeoBundleLazy 'sjl/gundo.vim', {
\   'autoload' : {
\       'commands' : 'GundoToggle'
\   }
\}
" }}}
" backup
NeoBundle 'savevers.vim'

" https://github.com/zenbro/mirror.vim

" noeol, eolを保ったまま保存
NeoBundle 'PreserveNoEOL', {
\   'disabled': exists('&fixeol'),
\}

" ファイルのインデントがスペースかタブか、インデント幅はいくつかを自動検出 :space:tab:indent
" [tpope/vim-sleuth](https://github.com/tpope/vim-sleuth) こっちも似たようなもの
NeoBundle 'ciaranm/detectindent'

" diff {{{1
" ============================================================================
NeoBundleLazy 'tmsanrinsha/DirDiff.vim', {
\   'autoload' : {
\       'commands' : {
\           'name' : 'DirDiff',
\           'complete' : 'dir'
\       }
\   }
\}
NeoBundle 'tmsanrinsha/diffchar.vim'
" NeoBundle 'chrisbra/vim-diff-enhanced'

" eclipseと連携 {{{1
" ============================================================================
" if ! exists('g:eclipse_home')
"     if has('win32') && isdirectory(expand('~/eclipse'))
"         let g:eclipse_home = escape(expand('~/eclipse'), '\')
"     elseif has('mac') && isdirectory(expand('~/Applications/Eclipse.app'))
"         " caskでインストールした場合、設定するディレクトリはEclipse.appの実体の一つ上のディレクトリ
"         let g:eclipse_home = resolve(expand('~/Applications/Eclipse.app/..'))
"     else
"         let g:eclipse_home = ''
"     endif
" endif

" NeoBundleLazy 'ervandew/eclim', {
"     \   'build' : {
"     \       'windows': 'ant -Declipse.home=' . g:eclipse_home
"     \                     .' -Dvim.files=' . escape(expand('~/.vim/bundle/eclim'), '\'),
"     \       'mac':     'ant -Declipse.home=' . g:eclipse_home
"     \                     .' -Dvim.files=' . expand('~/.vim/bundle/eclim'),
"     \   },
"     \   'autoload': {
"     \       'filetypes': ['java'],
"     \   },
"     \   'external_commands': 'ant',
"     \   'disabled': !exists(g:eclipse_home),
"     \}

" arduino
" ============================================================================
NeoBundleLazy '4Evergreen4/vim-hardy', {
\   'autoload': {
\       'filetypes': ['arduino']
\   },
\}

" PHP {{{1
" ============================================================================
NeoBundleLazy 'shawncplus/phpcomplete.vim', {
\   'autoload': {
\       'filetypes': ['php']
\   },
\}
" Composerプロジェクトのルートディレクトリでvimを開く必要があり
" NeoBundleLazy 'm2mdas/phpcomplete-extended', {
"     \   'depends': ['Shougo/vimproc.vim', 'Shougo/unite.vim'],
"     \   'autoload': {'filetypes': 'php'}
"     \}
NeoBundleLazy 'StanAngeloff/php.vim', {'autoload': {'filetypes': ['php']}}
NeoBundleLazy 'stephpy/vim-php-cs-fixer', {
\   'autoload': {
\       'functions': ['PhpCsFixerFixDirectory', 'PhpCsFixerFixFile']
\   }
\}
NeoBundleLazy 'joonty/vdebug', {
\   'autoload': {
\       'filetypes': ['php']
\   }
\}

" HTML {{{1
" ============================================================================
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html', 'php']}}

" JavaScript {{{1
" ============================================================================
NeoBundleLazy 'pangloss/vim-javascript', {
\   'autoload': {
\       'filetypes': ['javascript', 'html', 'php']
\   }
\}
NeoBundleLazy 'jelera/vim-javascript-syntax', {
\   'autoload': {
\       'filetypes': ['javascript', 'html', 'php']
\   }
\}
NeoBundleLazy 'nono/jquery.vim', {
\   'autoload': {
\       'filetypes': ['javascript', 'html', 'php']
\   }
\}
" JavaScript, CSS, HTMLの整形
NeoBundleLazy 'maksimr/vim-jsbeautify', {
\   'autoload': {'filetypes': ['javascript', 'css', 'html']},
\   'external_commands': 'node',
\}
NeoBundleLazy 'elzr/vim-json', {
\   'autoload': {'filetypes': ['json']}
\}
" Python {{{1
" ============================================================================
NeoBundleLazy 'davidhalter/jedi-vim', {
\   'autoload': {'filetypes': ['python']}
\}
" NeoBundleLazy 'klen/python-mode', {
" \   'autoload': {'filetypes': ['python']}
" \}
" Do not load vim-pyenv until *.py is opened and
" make sure that it is loaded after jedi-vim is loaded.
NeoBundleLazy 'lambdalisue/vim-pyenv', {
\   'depends': ['davidhalter/jedi-vim'],
\   'autoload': {
\     'filetypes': ['python', 'python3'],
\   }
\}

NeoBundleLazy 'hynek/vim-python-pep8-indent', {
\   'autoload': {'filetypes': ['python']}
\}
" C, C++ {{{1
" ============================================================================
NeoBundleLazy 'osyo-manga/vim-marching', {
\   'autoload': {'filetypes': ['c', 'cpp']}
\}
NeoBundleLazy 'quark-zju/vim-cpp-auto-include', {
\   'external_commands': 'ruby',
\   'autoload': {'filetypes': ['c', 'cpp']}
\}

" R lang {{{1
" ============================================================================
NeoBundleLazy 'jcfaria/Vim-R-plugin', {
\   'autoload': {'filetypes': 'r'}
\}

" SQL {{{1
" ============================================================================
" NeoBundleLazy 'vim-scripts/dbext.vim', {
"     \   'autoload': {'filetypes': ['sql']}
"     \}
NeoBundleLazy 'autowitch/hive.vim', {
\   'autoload': {'filetypes': ['sql']}
\}

" Markdown {{{1
" ============================================================================
" fenced code blockで色がつかない
" インデントがおかしい
NeoBundleLazy 'plasticboy/vim-markdown', {
\   'on_ft': 'markdown',
\}

" [VimでのMarkdown環境を整える - rcmdnk's blog](http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#rcmdnkvim-markdown)
" forked from plasticboy/vim-markdown
" vim-markdown-quote-syntaxを使うと色がつく
" rmdでも使いたいのでautoloadに設定する
" NeoBundleLazy 'rcmdnk/vim-markdown', {
" \   'name': 'rcmdnk_vim-markdown',
" \   'autoload': {'filetypes': ['markdown', 'rmd']},
" \   'depends': [
" \       'godlygeek/tabular',
" \       'joker1007/vim-markdown-quote-syntax',
" \   ]
" \}

NeoBundleLazy 'nelstrom/vim-markdown-folding', {
\   'autoload': {'filetypes': ['markdown']}
\}

" preview {{{2
NeoBundleLazy 'tmsanrinsha/previm', {
\   'autoload': {'commands': ['PrevimOpen']},
\   'depends': 'tyru/open-browser.vim'
\}
" NeoBundleLazy 'teramako/instant-markdown-vim'
" if executable('node') && executable('ruby')
"     NeoBundle 'suan/vim-instant-markdown'
" endif

" sh {{{1
" indentの改善
NeoBundleLazy 'sh.vim--Cla', {
\   'autoload': {'filetypes': 'sh'}
\}
" tmux {{{1
" tmuxのシンタックスファイル
NeoBundleLazy 'zaiste/tmux.vim', {
\   'autoload' : { 'filetypes' : ['tmux'] }
\ }

" Vim {{{1
" ============================================================================
" http://qiita.com/rbtnn/items/89c78baf3556e33c880f
NeoBundleLazy 'rbtnn/vimconsole.vim', {'autoload': {'commands': 'VimConsoleToggle'}}
NeoBundle 'thinca/vim-prettyprint'
" NeoBundleLazy 'syngan/vim-vimlint'
" NeoBundle 'dsummersl/vimunit'
NeoBundleLazy 'ynkdir/vim-vimlparser', {'autoload': {'filetypes': ['vim']}}
NeoBundleLazy 'kannokanno/vim-helpnew', {
\   'autoload' : { 'commands' : 'HelpNew' }
\ }

NeoBundleLazy 'wannesm/wmgraphviz.vim', {
\   'autoload': {
\       'filetypes': 'dot',
\   }
\}

" vimperator {{{1
" vimperatorのシンタックスファイル
NeoBundleLazy 'superbrothers/vim-vimperator', {
\   'autoload'    : { 'filetypes' : ['vimperator'] },
\}
" script_typeにsyntaxを使うとうまくいかない
" NeoBundleLazy 'https://raw.githubusercontent.com/vimperator/vimperator-labs/master/vimperator/contrib/vim/syntax/vimperator.vim', {
" \   'autoload'    : { 'filetypes' : ['vimperator'] },
" \   'script_type' : 'syntax'
" \}
" confluence {{{1
" confluenceのシンタックスファイル
NeoBundleLazy 'confluencewiki.vim', {
\   'autoload' : { 'filetypes' : ['confluencewiki'] }
\ }

" mql4 {{{1
NeoBundleLazy 'vobornik/vim-mql4', {
\   'autoload' : { 'filetypes' : ['mql4'] }
\ }

" yaml {{{1
" NeoBundleLazy 'tmsanrinsha/yaml.vim', {
"             \   'autoload' : { 'filetypes' : 'yaml' }
"             \}

" Git {{{1
NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive'}
" lazyはうまくいかない
" NeoBundleLazy 'tpope/vim-fugitive', {
" \   'augroup' : 'fugitive',
" \   'autoload': {
" \       'commands': [
" \           'Gdiff', 'Gstatus', 'Glog', 'Git'
" \       ]
" \   }
" \}

NeoBundleLazy 'gregsexton/gitv', {
\   'autoload': {'commands' : ['Gitv']}
\}

NeoBundleLazy 'mattn/gist-vim', {
\   'autoload' : { 'commands' : [ 'Gist' ] },
\   'depends'  : 'mattn/webapi-vim'
\}

" }}}
if v:version > 702
    NeoBundleLazy 'tyru/open-browser.vim', {
    \   'on_map': '<Plug>(openbrowser-',
    \   'on_func': ['openbrowser#search', 'OpenBrowser']
    \}
endif

" color {{{1
" ============================================================================
" NeoBundle 'tomasr/molokai'
NeoBundle 'tmsanrinsha/molokai', {'name': 'my_molokai'}
" NeoBundle 'w0ng/vim-hybrid'
" NeoBundle 'reedes/vim-colors-pencil'
" NeoBundle 'vim-scripts/wombat256.vim'
NeoBundle 'altercation/vim-colors-solarized'
" NeoBundle 'chriskempson/vim-tomorrow-theme'
" NeoBundle 'vim-scripts/rdark'
" NeoBundle 'vim-scripts/rdark-terminal'
" NeoBundle 'jonathanfilip/vim-lucius'

" NeoBundle 'godlygeek/csapprox'
" カラースキームの色見本
" http://cocopon.me/blog/?p=3522
" NeoBundleLazy 'cocopon/colorswatch.vim', {
"     \   'autoload': { 'commands' : [ 'ColorSwatchGenerate' ] }
"     \}

" ステータスラインをカスタマイズ
NeoBundle 'itchyny/lightline.vim', {
\   'depends': [
\       'tpope/vim-fugitive',
\       'majutsushi/tagbar',
\       'osyo-manga/vim-anzu',
\   ]
\}

" NeoBundle 'luochen1990/rainbow'
NeoBundleLazy 't9md/vim-quickhl', {
\   'on_map': '<Plug>(quickhl-'
\}

NeoBundleLazy 'vim-scripts/AnsiEsc.vim', {
\   'autoload': {
\       'commands': ['AnsiEsc']
\   }
\}

" CSS
" #000000とかの色付け
" NeoBundleLazy 'skammer/vim-css-color'
" rgb()に対応したやつ
" http://hail2u.net/blog/software/add-support-for-rgb-func-syntax-to-css-color-preview.html
" NeoBundle 'gist:hail2u/228147', {'name': 'css.vim', 'script_type': 'plugin'}

" NeoBundleLazy 'LeafCage/unite-gvimrgb', {
" \   'autoload': {
" \       'unite_sources': 'gvimrgb'
" \   }
" \}
"}}}
" [Vimエディタで線を描画する — 名無しのvim使い](http://nanasi.jp/articles/howto/editing/drawline.html#id4)
NeoBundleLazy 'DrawIt', {
\   'on_cmd': 'DrawIt',
\   'on_map': ';di',
\}

NeoBundleLazy 'Shougo/junkfile.vim', {
\   'on_cmd': ['Junkfile', 'JunkfileOpen', 'JunkfileFiletype'],
\   'on_source': 'unite.vim',
\}

NeoBundleLazy 'neilagabriel/vim-geeknote', {
\   'autoload': {
\       'commands': [
\           'Geeknote'
\       ]
\   }
\}

" NeoBundleLazy 'vimwiki/vimwiki', {
" \   'autoload': {
" \       'mappings': '<Plug>Vimwiki'
" \   },
" \   'filetypes': ['vimwiki']
" \}

NeoBundleLazy 'glidenote/memolist.vim', {
\   'on_cmd': ['MemoNew', 'MemoList', 'MemoGrep']
\}
" NeoBundleLazy 'fuenor/qfixhowm'
" NeoBundle "osyo-manga/unite-qfixhowm"
" NeoBundle 'jceb/vim-orgmode', {
" \   'depends': [
" \       'utl.vim', 'tpope/vim-repeat', 'tpope/vim-speeddating', 'chrisbra/NrrwRgn',
" \       'calendar.vim', 'SyntaxRange'
" \   ]
" \}
" let g:org_agenda_files = ['~/org/*.org']

" NeoBundle 'joker1007/vim-metarw-qiita'
" NeoBundle 'kana/vim-metarw'
NeoBundleLazy 'mattn/qiita-vim', {
\   'autoload': {
\       'commands': ['Qiita'],
\       'unite_sources': ['qiita']
\   }
\}

" if executable('hg') " external_commandsの設定だけだと毎回チェックがかかる
"     NeoBundleLazy 'https://bitbucket.org/pentie/vimrepress'
" endif

" http://d.hatena.ne.jp/itchyny/20140108/1389164688
" NeoBundleLazy 'itchyny/calendar.vim', {
"             \   'autoload' : { 'commands' : [
"             \       'Calendar'
"             \   ]}
"             \}

NeoBundle 'tmsanrinsha/vim-emacscommandline'

NeoBundleSaveCache

" endif

call SourceRc('bundle_local.vim')

call neobundle#end()

filetype plugin indent on     " Required!

" Installation check.
" NeoBundleCheck

if v:version > 702
    " NeoBundleSource unite.vim
    NeoBundleSource vimfiler.vim
endif
