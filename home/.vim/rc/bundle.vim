scriptencoding utf-8
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

" neobundleが使えない環境用
if !(isdirectory($VIMDIR . '/bundle/neobundle.vim/') && MyHasPatch('patch-7.2.051'))
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
        if isdirectory($VIMDIR . '/bundle/' . s:plugin)
            let &runtimepath = &runtimepath . ',' . $VIMDIR . '/bundle/' . s:plugin
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

let g:neobundle#types#git#default_protocol = 'git'
let g:neobundle#install_process_timeout = 2000

if has('win32') && has('kaoriya')
    " kaoriya版Vim同梱のvimprocを使う
    set runtimepath+=$VIM/plugins/vimproc
endif

" Required:
call neobundle#begin(expand($VIMDIR.'/bundle/'))

" キャッシュを使うとUnite.vimの調子が悪いのでやめる
" if neobundle#has_fresh_cache(expand($VIMDIR.'/rc/plugin.vim'))
"     NeoBundleLoadCache
" else
" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim'

" 非同期処理 vimproc {{{2
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

" vital {{{2
NeoBundleLazy 'vim-jp/vital.vim'
NeoBundle 'osyo-manga/vital-coaster', {
\   'autoload': {
\       'mappings': ['<C-a>', '<C-x>']
\   },
\   'depends': ['vim-jp/vital.vim']
\}

" unite {{{2
" --------------------------------------------------------------------
" unite.vimはlazyがうまくいかない
" NeoBundleLazy 'Shougo/unite.vim', {
" \   'autoload': {
" \       'commands': ['Unite']
" \   }
" \}
NeoBundle 'Shougo/unite.vim'
NeoBundleLazy 'Shougo/neomru.vim', {
\   'autoload': {
\       'unite_sources': ['file_mru', 'directory_mru']
\   }
\}
NeoBundleLazy 'Shougo/neossh.vim', {
\   'autoload': {
\       'unite_sources': ['ssh']
\   }
\}
" unite-で始まるプラグインは自動的にunite_sourcesがセットされる
NeoBundleLazy 'Shougo/unite-outline'
NeoBundleLazy 'tacroe/unite-mark'
NeoBundleLazy 'tsukkee/unite-tag'
NeoBundleLazy 'thinca/vim-unite-history', {
\   'autoload': {
\       'unite_sources': ['history/command', 'history/search']
\   }
\}
NeoBundleLazy 'tmsanrinsha/unite-ghq'
NeoBundleLazy 'rhysd/unite-zsh-cdr.vim', {
\   'autoload': {
\       'unite_sources': ['zsh-cdr']
\   }
\}
" NeoBundle 'Shougo/unite-sudo'

" http://archiva.jp/web/tool/vim_grep2.html
NeoBundle 'thinca/vim-qfreplace'

" shell, filer {{{2
" --------------------------------------------------------------------
NeoBundleLazy 'Shougo/vimshell.vim', {
\   'autoload' : { 'commands' : [ 'VimShell', "VimShellBufferDir", "VimShellInteractive", "VimShellPop" ] },
\   'depends' : ['Shougo/vim-vcs', 'Shougo/unite.vim']
\}
NeoBundle 'ujihisa/vimshell-ssh'
" if executable('svn')
"     NeoBundleLazy 'http://conque.googlecode.com/svn/trunk/', {'name': 'Conque-Shell'}
" else
NeoBundleLazy 'oplatek/Conque-Shell', {
\   'autoload': {
\       'commands': ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit']
\   }
\}
" endif
NeoBundle 'Shougo/vimfiler.vim'

" 補完・入力補助 {{{2
" --------------------------------------------------------------------
"" 自動補完 {{{3
NeoBundleLazy "Shougo/neocomplete.vim", {
\   "autoload": {"insert": 1},
\   'depends' : [
\       'Shougo/context_filetype.vim',
\       'Shougo/neoinclude.vim',
\       'Shougo/neco-syntax',
\       'Shougo/neosnippet',
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

"" スニペット補完 {{{3

" 閉じ括弧などの対応するものの補完 {{{3
" NeoBundleLazy "kana/vim-smartinput", {"autoload": {"insert": 1}}
" NeoBundleLazy "cohama/lexima.vim", {"autoload": {"insert": 1}}

" quickrun {{{2
" --------------------------------------------------------------------
" NeoBundle 'thinca/vim-quickrun'
NeoBundleLazy 'thinca/vim-quickrun', {
\   'autoload': {
\       'commands': [{
\           'name': 'QuickRun',
\           'complete': 'customlist,quickrun#complete',
\       }]
\   },
\   'depends': [
\       'osyo-manga/shabadou.vim',
\       'cohama/vim-hier',
\       'dannyob/quickfixstatus',
\       'KazuakiM/vim-qfsigns',
\       'KazuakiM/vim-qfstatusline'
\   ]
\}

" syntax check, quickfix {{{2
" -------------------------------------------------------------------
" ファイルを保存時にシンタックスのチェック
" 同期処理なのでwatchldogsを使う
" NeoBundleLazy 'scrooloose/syntastic'

" dependsでquickrunを設定するとhookがうまくいかない
NeoBundleLazy 'osyo-manga/vim-watchdogs', {
\   'depends': [
\       'osyo-manga/shabadou.vim',
\       'cohama/vim-hier',
\       'dannyob/quickfixstatus',
\       'KazuakiM/vim-qfsigns',
\       'KazuakiM/vim-qfstatusline'
\   ]
\}


" 現在のカーソル位置から見て次/前のquickfix/location listに飛ぶ
" http://www.vim.org/scripts/script.php?script_id=4449
NeoBundle 'QuickFixCurrentNumber', {
\   'depends': 'ingo-library'
\}

" operator {{{2
" --------------------------------------------------------------------
NeoBundleLazy "kana/vim-operator-user"
NeoBundleLazy 'kana/vim-operator-replace', {
\   'depends': 'kana/vim-operator-user',
\   'autoload' : { 'mappings' : '<Plug>(operator-replace)' }
\}
NeoBundleLazy "osyo-manga/vim-operator-search", {
\   'depends': 'kana/vim-operator-user',
\   'autoload' : { 'mappings' : '<Plug>(operator-search)' }
\}
NeoBundle 'tpope/vim-surround'
NeoBundleLazy "rhysd/vim-operator-surround", {
\   'depends': 'kana/vim-operator-user',
\   'autoload' : { 'mappings' : '<plug>(operator-surround-' }
\}
NeoBundleLazy "tyru/operator-camelize.vim", {
\   'depends': 'kana/vim-operator-user',
\   'autoload' : { 'mappings' : '<Plug>(operator-camelize-' }
\}
" clipboardが使えない、もしくはsshで接続している時にvim-fakeclipを使う。
if !has('clipboard') || $SSH_CLIENT != ''
    NeoBundle 'tmsanrinsha/vim-fakeclip'
endif

" textobj {{{2
" --------------------------------------------------------------------
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kentaro/vim-textobj-function-php'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'sgur/vim-textobj-parameter'
" NeoBundle 'thinca/vim-textobj-comment'
NeoBundleLazy 'glts/vim-textobj-comment', {
\   'autoload': {'mappings': '<Plug>(textobj-comment-'}
\}
NeoBundleLazy 'osyo-manga/vim-textobj-context', {
\   'autoload': {'mappings': '<Plug>(textobj-context-'}
\}
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundleLazy 'kana/vim-textobj-lastpat', {
\   'autoload' : { 'mappings' : '<Plug>(textobj-lastpat-' },
\   'disabled' : MyHasPatch('patch-7.3.610')
\}
" Gitでコンフリクトしている部分
" lazyはうまくいかない
" NeoBundleLazy 'rhysd/vim-textobj-conflict', {'autoload': {'mappings': '<Plug>(textobj-conflict'}}
NeoBundle 'rhysd/vim-textobj-conflict'
" バッファ全体
NeoBundleLazy 'kana/vim-textobj-entire', {'autoload': {'mappings': '<Plug>(textobj-entire'}}
" }}}

NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'kana/vim-smartword', {
\   'autoload' : { 'mappings' : '<Plug>(smartword-' }
\}
" NeoBundleLazy 'thinca/vim-visualstar', {
" \   'autoload' : { 'mappings' : '<Plug>(visualstar-' }
" \}
NeoBundleLazy 'haya14busa/vim-asterisk', {
\   'autoload' : {
\     'mappings' : ['<Plug>(asterisk-']
\   }
\ }


NeoBundle 'rhysd/clever-f.vim'

" Vimperatorのクイックヒント風にカーソル移動
NeoBundleLazy 'Lokaltog/vim-easymotion'

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
if v:version >= 701
    NeoBundle 'h1mesuke/vim-alignta'
else
    NeoBundle 'Align'
endif

" コメント操作
" NeoBundle "tyru/caw.vim"
" NeoBundle "tpope/vim-commentary"
" NeoBundle "tomtom/tcomment_vim"
NeoBundleLazy "tomtom/tcomment_vim", {
\   'autoload': {
\       'mappings': ['<Plug>TComment_', 'gc'],
\   }
\}

" NeoBundle 'YankRing.vim'
NeoBundleLazy 'LeafCage/yankround.vim', {
\   'autoload': {
\       'mappings': '<Plug>(yankround-',
\       'unite_sources' : 'yankround'
\   },
\   'vim_version': '7.3'
\}

" open, gf {{{2
" --------------------------------------------------------------------
" すでにvimが起動しているときは、そちらで開く
NeoBundle 'thinca/vim-singleton', {
\ 'disabled': !has('clientserver'),
\ }
" vim path/to/file.ext:12:3 こういうに行と列を指定して開く
" NeoBundle 'kopischke/vim-fetch'
NeoBundle 'kana/vim-gf-user' 
NeoBundle 'kana/vim-gf-diff'
" lazyにするとGitvでの挙動がおかしくなる
" NeoBundleLazy 'kana/vim-gf-diff', {
" \   'depends': 'kana/vim-gf-user',
" \   'autoload': {
" \       'mappings': '<Plug>(gf-user-',
" \   }
" \}
" }}}

" 一時バッファの制御
" if v:version >= 704 || (v:version == 703 && has('patch462'))
"     NeoBundle 'osyo-manga/vim-automatic', {
"                 \   'depends': 'osyo-manga/vim-gift',
"                 \}
" endif

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

" diff {{{2
" --------------------------------------------------------------------
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

" eclipseと連携 {{{2
" --------------------------------------------------------------------
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

" PHP {{{2
" --------------------------------------------------------------------
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
NeoBundleLazy 'joonty/vdebug', {
\   'autoload': {
\       'filetypes': ['php']
\   }
\}

" HTML {{{2
" --------------------------------------------------------------------
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html', 'php']}}

" JavaScript {{{2
" --------------
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'nono/jquery.vim'
" JavaScript, CSS, HTMLの整形
NeoBundleLazy 'maksimr/vim-jsbeautify', {
\   'autoload': {'filetypes': ['javascript', 'css', 'html']},
\   'external_commands': 'node',
\}

" Python {{{2
" ----------
NeoBundleLazy 'davidhalter/jedi-vim', {
\   'autoload': {'filetypes': ['python']}
\}
" NeoBundleLazy 'klen/python-mode', {
" \   'autoload': {'filetypes': ['python']}
" \}
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
\   'autoload': {'filetypes': ['python']}
\}
" C, C++ {{{2
" ----------
NeoBundleLazy 'osyo-manga/vim-marching', {
\   'autoload': {'filetypes': ['c', 'cpp']}
\}
NeoBundleLazy 'quark-zju/vim-cpp-auto-include', {
\   'external_commands': 'ruby',
\   'autoload': {'filetypes': ['c', 'cpp']}
\}

" R lang {{{2
" --------------------------------------------------------------------
NeoBundleLazy 'jcfaria/Vim-R-plugin', {
\   'autoload': {'filetypes': 'r'}
\}

" SQL {{{2
" --------------------------------------------------------------------
" NeoBundleLazy 'vim-scripts/dbext.vim', {
"     \   'autoload': {'filetypes': ['sql']}
"     \}
NeoBundleLazy 'autowitch/hive.vim', {
\   'autoload': {'filetypes': ['sql']}
\}

" Markdown {{{2
" ------------
" NeoBundleLazy 'tpope/vim-markdown', {
" \   'autoload' : { 'filetypes' : 'markdown' }
" \}
" fenced code blockで色がつかない
" ファイルタイプmkdなのがやだ
" インデントがおかしい
" [Auto-indentation for lists · Issue #126 · plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown/issues/126)
" NeoBundleLazy 'plasticboy/vim-markdown', {
" \   'name': 'plasticboy_vim-markdown',
" \   'autoload': {'filetypes': ['mkd']},
" \}
" NeoBundle 'plasticboy/vim-markdown', {
" \   'name': 'plasticboy_vim-markdown',
" \}

" [VimでのMarkdown環境を整える - rcmdnk's blog](http://rcmdnk.github.io/blog/2013/11/17/computer-vim/#rcmdnkvim-markdown)
" forked from plasticboy/vim-markdown
" 下のプラグインと組み合わせると色がつく
NeoBundleLazy 'rcmdnk/vim-markdown', {
\   'name': 'rcmdnk_vim-markdown',
\   'rev': 'mod',
\   'autoload': {'filetypes': ['markdown']},
\   'depends': [
\       'godlygeek/tabular',
\       'joker1007/vim-markdown-quote-syntax',
\   ]
\}

NeoBundleLazy 'nelstrom/vim-markdown-folding', {
\   'autoload': {'filetypes': ['markdown']}
\}

" preview {{{3
NeoBundleLazy 'tmsanrinsha/previm', {
\   'autoload': {'commands': ['PrevimOpen']},
\   'depends': 'tyru/open-browser.vim'
\}
" NeoBundleLazy 'teramako/instant-markdown-vim'
" if executable('node') && executable('ruby')
"     NeoBundle 'suan/vim-instant-markdown'
" endif

" sh {{{2
" indentの改善
NeoBundleLazy 'sh.vim--Cla', {
\   'autoload': {'filetypes': 'sh'}
\}
" tmux {{{2
" tmuxのシンタックスファイル
NeoBundleLazy 'zaiste/tmux.vim', {
\   'autoload' : { 'filetypes' : ['tmux'] }
\ }

" Vim {{{2
" --------------------------------------------------------------------
" http://qiita.com/rbtnn/items/89c78baf3556e33c880f
NeoBundleLazy 'rbtnn/vimconsole.vim', {'autoload': {'commands': 'VimConsoleToggle'}}
NeoBundleLazy 'syngan/vim-vimlint'
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

" vimperator {{{2
" vimperatorのシンタックスファイル
NeoBundleLazy 'http://vimperator-labs.googlecode.com/hg/vimperator/contrib/vim/syntax/vimperator.vim', {
\   'type'        : 'raw',
\   'autoload'    : { 'filetypes' : ['vimperator'] },
\   'script_type' : 'syntax'
\}

" confluence {{{2
" confluenceのシンタックスファイル
NeoBundleLazy 'confluencewiki.vim', {
\   'autoload' : { 'filetypes' : ['confluencewiki'] }
\ }

" mql4 {{{2
NeoBundleLazy 'vobornik/vim-mql4', {
\   'autoload' : { 'filetypes' : ['mql4'] }
\ }

" yaml {{{2
" NeoBundleLazy 'tmsanrinsha/yaml.vim', {
"             \   'autoload' : { 'filetypes' : 'yaml' }
"             \}

" Git {{{2
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
NeoBundleLazy 'tyru/open-browser.vim', {
\   'autoload': {
\       'mappings': '<Plug>(openbrowser-',
\       'functions': 'openbrowser#search'
\   }
\}


" colorscheme
" NeoBundle 'tomasr/molokai'
NeoBundle 'tmsanrinsha/molokai', {'name': 'my_molokai'}
NeoBundle 'w0ng/vim-hybrid'
" NeoBundle 'vim-scripts/wombat256.vim'
" NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'chriskempson/vim-tomorrow-theme'
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
" NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'itchyny/lightline.vim', {
\   'depends': [
\       'tpope/vim-fugitive',
\       'majutsushi/tagbar',
\       'osyo-manga/vim-anzu',
\   ]
\}

" NeoBundle 'luochen1990/rainbow'
NeoBundleLazy 't9md/vim-quickhl', {
\   'autoload': {'mappings': '<Plug>(quickhl-'}
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

" [Vimエディタで線を描画する — 名無しのvim使い](http://nanasi.jp/articles/howto/editing/drawline.html#id4)
NeoBundleLazy 'DrawIt', {
\   'autoload': {
\       'commands': 'DrawIt'
\   }
\}

" NeoBundleLazy 'vimwiki/vimwiki', {
" \   'autoload': {
" \       'mappings': '<Plug>Vimwiki'
" \   },
" \   'filetypes': ['vimwiki']
" \}

NeoBundleLazy 'Shougo/junkfile.vim', {
\   'autoload': {
\       'commands': ['Junkfile', 'JunkfileFiletype'],
\       'unite_sources': 'junkfile',
\   }
\}
" NeoBundleLazy 'glidenote/memolist.vim'
" NeoBundleLazy 'fuenor/qfixhowm'
" NeoBundle "osyo-manga/unite-qfixhowm"
" NeoBundle 'jceb/vim-orgmode', {
" \   'depends': [
" \       'utl.vim', 'tpope/vim-repeat', 'tpope/vim-speeddating', 'chrisbra/NrrwRgn',
" \       'calendar.vim', 'SyntaxRange'
" \   ]
" \}
" let g:org_agenda_files = ['~/org/*.org']
" NeoBundle 'neilagabriel/vim-geeknote'
" if executable('hg') " external_commandsの設定だけだと毎回チェックがかかる
"     NeoBundleLazy 'https://bitbucket.org/pentie/vimrepress'
" endif

" http://d.hatena.ne.jp/itchyny/20140108/1389164688
" NeoBundleLazy 'itchyny/calendar.vim', {
"             \   'autoload' : { 'commands' : [
"             \       'Calendar'
"             \   ]}
"             \}

" 自分のリポジトリ
" NeoBundle 'tmsanrinsha/vim-colors-solarized'
" NeoBundle 'tmsanrinsha/vim'
NeoBundle 'tmsanrinsha/vim-emacscommandline'

" vim以外のリポジトリ
NeoBundleFetch 'mla/ip2host', {'base' : '~/.vim/fetchBundle'}

call SourceRc('bundle_local.vim')

"     NeoBundleSaveCache
" endif

call neobundle#end()

filetype plugin indent on     " Required!

" Installation check.
NeoBundleCheck