" neobundle.vim {{{
" ============================================================================
if filereadable(expand($VIMDIR.'/bundle/neobundle.vim/autoload/neobundle.vim'))
    \   && (v:version >= 703 || v:version == 702 && has('patch051'))
    if has('vim_starting')
      set runtimepath+=$VIMDIR/bundle/neobundle.vim/
    endif
    call neobundle#rc(expand('~/.vim/bundle/'))
    let g:neobundle#types#git#default_protocol = "git"
    let g:neobundle#install_process_timeout = 2000

    " すでにvimが起動しているときは、そちらで開く
    if has('clientserver')
        NeoBundle 'thinca/vim-singleton'
        if neobundle#is_installed('vim-singleton') && has('gui_running')
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
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/neomru.vim'
    NeoBundleLazy 'Shougo/unite-outline'
    NeoBundleLazy 'tacroe/unite-mark'
    NeoBundleLazy 'tsukkee/unite-tag'
    NeoBundleLazy 'Shougo/unite-ssh'
    NeoBundle 'ujihisa/vimshell-ssh'
    "NeoBundle 'Shougo/unite-sudo'
    " }}}

    " http://archiva.jp/web/tool/vim_grep2.html
    NeoBundle 'thinca/vim-qfreplace'

    NeoBundle 'Shougo/vimfiler'
    "" shell {{{
    NeoBundleLazy 'Shougo/vimshell', {
                \   'autoload' : { 'commands' : [ 'VimShell', "VimShellBufferDir", "VimShellInteractive", "VimShellPop" ] },
                \   'depends' : 'Shougo/vim-vcs'
                \}
    NeoBundleLazy 'http://conque.googlecode.com/svn/trunk/', {'name': 'Conque-Shell'}
    " }}}
    "" 補完・入力補助 {{{
    """ 自動補完 {{{
    if has('lua') && MyHasPatch('patch-7.3.825')
        NeoBundleLazy "Shougo/neocomplete", {"autoload": {"insert": 1}}
    else
        NeoBundleLazy "Shougo/neocomplcache", {"autoload": {"insert": 1}}
    endif
    " if has('python') && (v:version >= 704 || v:version == 703 && has('patch584'))
    "     NeoBundle "Valloric/YouCompleteMe"
    " endif
    " NeoBundleLazy 'm2mdas/phpcomplete-extended', {
    "     \   'depends': ['Shougo/vimproc', 'Shougo/unite.vim'],
    "     \   'autoload': {'filetypes': 'php'}
    "     \}
    NeoBundleLazy 'shawncplus/phpcomplete.vim', {'autoload': {'filetypes': 'php'}}
    """ }}}
    """ スニペット補完 {{{
    NeoBundleLazy 'Shougo/neosnippet', {"autoload": {"insert": 1}}
    NeoBundleLazy 'Shougo/neosnippet-snippets', {"autoload": {"insert": 1}}
    """ }}}
    " NeoBundleLazy "kana/vim-smartinput", {"autoload": {"insert": 1}}
    "" }}}
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
    NeoBundleLazy "kana/vim-operator-user"
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
        \   'autoload' : { 'mappings' : '<plug>(operator-surround-' }
        \}
    NeoBundleLazy "tyru/operator-camelize.vim", {
        \   'depends': 'kana/vim-operator-user',
        \   'autoload' : { 'mappings' : '<Plug>(operator-camelize-' }
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
    NeoBundle 'osyo-manga/vim-textobj-multiblock'
    " }}}
    " dでキー待ちが発生してしまう
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'tpope/vim-repeat'
    NeoBundleLazy 'kana/vim-smartword', {
                \   'autoload' : { 'mappings' : '<Plug>(smartword-' }
                \}
    NeoBundleLazy 'thinca/vim-visualstar', {
                \   'autoload' : { 'mappings' : '<Plug>(visualstar-' }
                \}

    " Vimperatorのクイックヒント風にカーソル移動
    NeoBundleLazy 'Lokaltog/vim-easymotion'
    NeoBundle 'terryma/vim-multiple-cursors'

    " 部分的に編集
    NeoBundle 'thinca/vim-partedit'

    " 整形
    if v:version >= 701
        NeoBundle 'h1mesuke/vim-alignta'
    else
        NeoBundle 'Align'
    endif


    " sudo権限でファイルを開く・保存
    NeoBundle 'sudo.vim'
    " NeoBundle 'gmarik/sudo-gui.vim'

    " NeoBundle 'YankRing.vim'
    NeoBundleLazy 'LeafCage/yankround.vim'

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
    " ファイルを保存時にシンタックスのチェック
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'osyo-manga/vim-watchdogs', {
        \   'depends': [
        \       'thinca/vim-quickrun',
        \       'Shougo/vimproc',
        \       'osyo-manga/shabadou.vim'
        \   ]
        \}
    " debug
    NeoBundle 'joonty/vdebug'
    " caw.vim {{{
    " -------
    " コメント操作
    NeoBundle "tyru/caw.vim"
    " NeoBundle "tpope/vim-commentary"
    " }}}

    " eclipseと連携
    if executable('ant')
        NeoBundleLazy 'ervandew/eclim', {
                    \   'build' : {
                    \       'windows' : 'ant -Declipse.home='.escape(expand('~/eclipse'), '\')
                    \                     .' -Dvim.files='.escape(expand('~/.vim/bundle/eclim'), '\'),
                    \       'mac'     : 'ant -Declipse.home='.escape(expand('~/eclipse'), '\')
                    \                     .' -Dvim.files='.escape(expand('~/.vim/bundle/eclim'), '\'),
                    \   },
                    \   'autoload': {'filetypes': ['java', 'xml']}
                    \}
    endif

    NeoBundleLazy 'StanAngeloff/php.vim', {'autoload': {'filetypes': ['php']}}
    NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html', 'php']}}
    " JavaScript, CSS, HTMLの整形
    if executable('node')
        NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload': {'filetypes': ['javascript', 'css', 'html']}}
    endif

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
    NeoBundleLazy 'rbtnn/vimconsole.vim', {'autoload': {'commands': 'VimConsoleToggle'}}
    NeoBundleLazy 'syngan/vim-vimlint'
    NeoBundleLazy 'ynkdir/vim-vimlparser', {'autoload': {'filetypes': 'vim'}}

    " colorscheme
    NeoBundle 'tomasr/molokai'
    NeoBundle 'w0ng/vim-hybrid'
    NeoBundle 'vim-scripts/wombat256.vim'
    NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'chriskempson/vim-tomorrow-theme'
    NeoBundle 'vim-scripts/rdark'
    NeoBundle 'vim-scripts/rdark-terminal'
    NeoBundle 'jonathanfilip/vim-lucius'

    " ステータスラインをカスタマイズ
    NeoBundle 'Lokaltog/vim-powerline'

    NeoBundle 'luochen1990/rainbow'
    let g:rainbow_active = 1

    " CSS
    " #000000とかの色付け
    NeoBundleLazy 'skammer/vim-css-color'
    " rgb()に対応したやつ
    " http://hail2u.net/blog/software/add-support-for-rgb-func-syntax-to-css-color-preview.html
    " NeoBundle 'gist:hail2u/228147', {'name': 'css.vim', 'script_type': 'plugin'}

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
        NeoBundleLazy 'https://bitbucket.org/pentie/vimrepress'
    endif
    NeoBundleLazy 'vimwiki/vimwiki'
    NeoBundleLazy 'glidenote/memolist.vim'
    " NeoBundle 'fuenor/qfixhowm'
    " NeoBundle "osyo-manga/unite-qfixhowm"
    " NeoBundle 'jceb/vim-orgmode'

    " http://d.hatena.ne.jp/itchyny/20140108/1389164688
    NeoBundleLazy 'itchyny/calendar.vim', {
                \   'autoload' : { 'commands' : [
                \       'Calendar'
                \   ]}
                \}

    " 自分のリポジトリ
    NeoBundle 'tmsanrinsha/molokai', {'name': 'my_molokai'}
    " NeoBundle 'tmsanrinsha/vim-colors-solarized'
    NeoBundle 'tmsanrinsha/vim'
    NeoBundle 'tmsanrinsha/vim-emacscommandline'

    " vim以外のリポジトリ
    NeoBundleFetch 'mla/ip2host', {'base' : '~/.vim/fetchBundle'}

    call SourceRc('neobunde_local.vim')

    call neobundle#end()

    filetype plugin indent on     " Required!un

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
                \   'syntastic', 'molokai', 'vim-smartword'
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
" sudo.vim {{{
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if HasPlugin('sudo')
    if HasPlugin('bclose')
        nmap <Leader>E :e sudo:%<CR><C-^><Plug>Kwbd
    else
        nnoremap <Leader>E :e sudo:%<CR><C-^>:bd<CR>
    endif
    nnoremap <Leader>W :w sudo:%<CR>
endif
"}}}
" minibufexpl.vim {{{
" ==============================================================================
if HasPlugin('minibufexpl')
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
if HasPlugin('bclose')
    nmap <Leader>bd <Plug>Kwbd
endif
" }}}
" vim-powerline{{{
if HasPlugin('Powerline')
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
if IsInstalled('my_molokai')
    set background=dark
    colorscheme molokai-customized
elseif IsInstalled('molokai')
    " let g:molokai_original = 1
    " let g:rehash256 = 1
    set background=dark
    colorscheme molokai
elseif HasPlugin('solarized')
    set background=dark
    let g:solarized_termcolors=256
    colorscheme solarized
    let g:solarized_contrast = "high"
else
    colorscheme default
endif

"}}}
" vim-smartword {{{
" ==============================================================================
if IsInstalled("vim-smartword")
    map w <Plug>(smartword-w)
    map b <Plug>(smartword-b)
    map e <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)
endif
"}}}
" Shougo/unite.vim {{{
" ============================================================================
if IsInstalled('unite.vim')
    let g:unite_data_directory = $VIMDIR.'/.unite'
    let g:unite_enable_start_insert = 1
    let g:unite_split_rule = "botright"
    let g:unite_winheight = "15"
    " let g:unite_source_find_max_candidates = 1000

    nnoremap [unite] <Nop>
    nmap , [unite]

    " bundle以下のファイル
    " call unite#custom#source('file_rec','ignore_patten','.*\.neobundle/.*')
    " カレントディレクトリ以下のディレクトリ
    nnoremap <silent> [unite]d<CR> :<C-u>Unite directory<CR>
    execute 'nnoremap <silent> [unite]dv :<C-u>Unite directory:' . $VIMDIR . '/bundle<CR>'
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

    " file_rec {{{
    " カレントディレクトリ以下のファイル
    nnoremap [unite]fc :<C-u>Unite file_rec/async<CR>

    " カレントバッファのディレクトリ以下のファイル
    nnoremap [unite]fb :<C-u>call <SID>unite_file_buffer()<CR>
    function! s:unite_file_buffer()
        let dir = expand('%:p:h')
        " windowsでドライブのC:をC\:に変更する必要がある
        execute 'Unite file_rec/async:' . escape(dir, ':')
    endfunction

    " プロジェクトディレクトリ以下のファイル
    " nnoremap [unite]fp :<C-u>Unite file_rec:!<CR>
    nnoremap [unite]fp :<C-u>call <SID>unite_file_project('-start-insert')<CR>
    function! s:unite_file_project(...)
        let opts = (a:0 ? join(a:000, ' ') : '')
        let dir = unite#util#path2project_directory(expand('%'))
        " windowsでドライブのC:をC\:に変更する必要がある
        execute 'Unite' opts 'file_rec/async:' . escape(dir, ':')
    endfunction
    " }}}

    " grep {{{
    if executable('ag')
        " Use ag in unite grep source.
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts =
            \   '--line-numbers --nocolor --nogroup --hidden ' .
            \   '--ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
        let g:unite_source_grep_recursive_opt = ''
    elseif executable('grep')
        let g:unite_source_grep_command = 'grep'
        let g:unite_source_grep_default_opts = '-inH'
        let g:unite_source_grep_recursive_opt = '-r'
    endif

    let g:unite_source_grep_max_candidates = 1000
    " Set "-no-quit" automatically in grep unite source.
    call unite#custom#profile('source/grep', 'context',
        \ {'no_quit' : 1})

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
    nnoremap <silent> [unite]j :<C-u>Unite jump<CR>

    " vimfilerがどんどん増えちゃう
    call unite#custom_default_action('directory' , 'vimfiler')
    " vimfiler上ではvimfilerを増やさず、移動するだけ
    autocmd MyVimrc FileType vimfiler
        \   call unite#custom_default_action('directory', 'lcd')

    " dでファイルの削除
    call unite#custom#alias('file', 'delete', 'vimfiler__delete')
endif
"}}}
" h1mesuke/unite-outline {{{
" =========================================================================
if IsInstalled('unite-outline')
    nnoremap [unite]o :<C-u>Unite outline<CR>
    let s:hooks = neobundle#get_hooks("unite-outline")
    function! s:hooks.on_source(bundle)
        call unite#sources#outline#alias('tmux', 'conf')
    endfunction
    unlet s:hooks
endif
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

let g:vimfiler_data_directory = $VIMDIR.'/.vimfiler'

nnoremap [VIMFILER] <Nop>
nmap <Leader>f [VIMFILER]
nnoremap <silent> [VIMFILER]f :VimFiler<CR>
nnoremap <silent> [VIMFILER]b    :VimFilerBufferDir<CR>
nnoremap <silent> [VIMFILER]c    :VimFilerCurrentDir<CR>

autocmd MyVimrc FileType vimfiler
    \   nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)
"}}}
" vimshell {{{
" ============================================================================
if IsInstalled('vimshell')
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

        let g:vimshell_data_directory = $VIMDIR.'/.vimshell'

        let g:vimshell_max_command_history = 3000


        autocmd MyVimrc FileType vimshell
            \   setlocal nonumber
            \|  setlocal nocursorline
            \|  nmap <buffer> q <Plug>(vimshell_hide)<C-w>=
            \|  imap <buffer> <M-n> <Plug>(vimshell_history_neocomplete)
            \|  imap <buffer> <C-k> <Plug>(vimshell_zsh_complete)
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
" Conque-Shell {{{
" ============================================================================
if IsInstalled('Conque-Shell')
call neobundle#config('Conque-Shell', {
    \   'autoload': {
    \       'commands': ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit']
    \   }
    \})

    noremap <Leader>C :ConqueTerm zsh<CR>

    let s:bundle = neobundle#get("Conque-Shell")
    function! s:bundle.hooks.on_source(bundle)
        let g:ConqueTerm_ReadUnfocused = 1
        let g:ConqueTerm_CloseOnEnd = 1
        let g:ConqueTerm_StartMessages = 0
        let g:ConqueTerm_CWInsert = 0
        let g:ConqueTerm_EscKey = '<C-j>'
    endfunction
    unlet s:bundle
endif
"}}}
" neocomplcache & neocomplete {{{
" ============================================================================
if IsInstalled('neocomplcache') || IsInstalled('neocomplete')
    if IsInstalled("neocomplete")
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
        execute 'let g:'.s:neocom_.'enable_auto_select = 0'
        " Use smartcase.
        execute 'let g:'.s:neocom_.'enable_smart_case = 1'
        execute 'let g:'.s:neocom_.'enable_ignore_case = 1'
        " Use camel case completion.
        let g:neocomplcache_enable_camel_case_completion = 1
        " Use underbar completion.
        let g:neocomplcache_enable_underbar_completion = 1 " Deleted
        " Set minimum syntax keyword length.
        if IsInstalled('neocomplete')
            let g:neocomplete#sources#syntax#min_syntax_length = 3
        else
            let g:neocomplcache_min_syntax_length = 3
        endif
        execute 'let g:'.s:neocom_.'lock_buffer_name_pattern = "\\*ku\\*"'

        " 補完候補取得に時間がかかっても補完をskipしない
        " execute 'let g:'.s:neocom_.'skip_auto_completion_time = ""'
        " 候補の数を増やす
        " execute 'let g:'.s:neocom_.'max_list = 3000'

        " execute 'let g:'.s:neocom_.'force_overwrite_completefunc = 1'

        execute 'let g:'.s:neocom_.'enable_auto_close_preview=0'
        " autocmd MyVimrc InsertLeave *.* pclose

        let g:neocomplcache_enable_auto_delimiter = 0

        " 使用する補完の種類を減らす
        " http://alpaca-tc.github.io/blog/vim/neocomplete-vs-youcompleteme.html
        " 現在のSourceの取得は `:echo
        " keys(neocomplete#variables#get_sources())`
        " " デフォルト: ['file', 'tag', 'neosnippet', 'vim', 'dictionary',
        " 'omni', 'member', 'syntax', 'include', 'buffer', 'file/include']

        if !exists('g:neocomplete#sources')
          let g:neocomplete#sources = {}
        endif
        " shawncplus/phpcomplete.vimで補完されるため、syntaxはいらない
        let g:neocomplete#sources.php  = ['tag', 'neosnippet', 'dictionary', 'omni', 'member', 'include', 'buffer', 'file', 'file/include']

        if !exists('g:neocomplcache_sources_list')
          let g:neocomplcache_sources_list = {}
        endif
        " shawncplus/phpcomplete.vimで補完されるため、syntaxはいらない
        let g:neocomplcache_sources_list.php  = ['tags_complete', 'snippets_complete', 'dictionary_complete', 'omni_complete', 'member_complete', 'include_complete', 'buffer_complete', 'filename_complete', 'filename_include']

        " 補完候補の順番
        if neobundle#is_installed("neocomplete")
            " defaultの値は ~/.vim/bundle/neocomplete/autoload/neocomplete/sources/ 以下で確認
            call neocomplete#custom#source('file'        , 'rank', 400)
            call neocomplete#custom#source('file/include', 'rank', 400)
            call neocomplete#custom#source('member'      , 'rank', 100)
        endif


        if IsInstalled('neocomplete')
            let g:neocomplete#data_directory = $VIMDIR . '/.neocomplete'
        else
            let g:neocomplcache_temporary_dir = $VIMDIR . '/.neocomplcache'
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
        " let g:neocomplete#sources#omni#functions.sql =
        " \ 'sqlcomplete#Complete'

        if executable('uname') && (system('uname -a') =~ 'FreeBSD 4' || system('uname -a') =~ 'FreeBSD 6')
            " スペックが低いマシーンでは有効にしない
        else
            " Enable heavy omni completion.
            if !exists('g:neocomplcache_omni_patterns')
                let g:neocomplcache_omni_patterns = {}
            endif

            let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.php  = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
            let g:neocomplcache_omni_patterns.c    = '\%(\.\|->\)\h\w*'
            let g:neocomplcache_omni_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
            "let g:neocomplcache_omni_patterns.java  = '.*'

            " Enable heavy omni completion.
            if !exists('g:neocomplete#sources#omni#input_patterns')
                let g:neocomplete#sources#omni#input_patterns = {}
            endif
            let g:neocomplete#sources#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
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

        " key mappings {{{
        execute 'inoremap <expr><C-g>  pumvisible() ? '.s:neocom.'#undo_completion() : "\<C-g>"'
        execute 'inoremap <expr><C-l>  pumvisible() ? '.s:neocom.'#complete_common_string() : '.s:neocom.'#start_manual_complete()'
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        execute 'inoremap <expr><C-e>  pumvisible() ? '.s:neocom.'#cancel_popup() : "\<End>"'
        " <C-u>, <C-w>した文字列をアンドゥできるようにする
        " http://vim-users.jp/2009/10/hack81/
        " C-uでポップアップを消したいがうまくいかない
        execute 'inoremap <expr><C-u>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-u>" : "\<C-g>u<C-u>"'
        execute 'inoremap <expr><C-w>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-w>" : "\<C-g>u<C-w>"'

        " [Vim - smartinput の <BS> や <CR> の汎用性を高める - Qiita](http://qiita.com/todashuta@github/items/bdad8e28843bfb3cd8bf)
        if neobundle#is_installed('vim-smartinput')
            call smartinput#map_to_trigger('i', '<Plug>(smartinput_BS)',
                  \                        '<BS>',
                  \                        '<BS>')
            call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)',
                  \                        '<BS>',
                  \                        '<C-h>')
            call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)',
                  \                        '<Enter>',
                  \                        '<Enter>')

            " <BS> でポップアップを閉じて文字を削除
            execute 'imap <expr> <BS> '
                \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_BS)"'

            " <C-h> でポップアップを閉じて文字を削除
            execute 'imap <expr> <C-h> '
                \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_C-h)"'


            " <CR> でポップアップ中の候補を選択し改行する
            execute 'imap <expr> <CR> '
                \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_CR)"'
            " <CR> でポップアップ中の候補を選択するだけで、改行はしないバージョン
            " ポップアップがないときには改行する
            " imap <expr> <CR> pumvisible() ?
            "     \ neocomplcache#close_popup() : "\<Plug>(smartinput_CR)"
        else
            execute 'inoremap <expr><BS> ' . s:neocom . '#smart_close_popup()."\<C-h>"'

            " <C-h> でポップアップを閉じて文字を削除
            execute 'inoremap <expr><C-h> ' . s:neocom . '#smart_close_popup()."\<C-h>"'

            " <CR> でポップアップ中の候補を選択し改行する
            execute 'inoremap <expr><CR> ' . s:neocom . '#smart_close_popup()."\<CR>"'
            " 補完候補が表示されている場合は確定。そうでない場合は改行
            " execute 'inoremap <expr><CR>  pumvisible() ? ' . s:neocom . '#close_popup() : "<CR>"'
        endif
        " }}}
    endfunction
endif
"}}}
" Valloric/Youcompleteme {{{
" ==============================================================================
let g:ycm_filetype_whitelist = { 'java': 1 }
" }}}
" neosnippet {{{
" ==============================================================================
if IsInstalled('neosnippet')
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
if IsInstalled('vim-quickrun')
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

command! QuickRunAndroidProject call s:QuickRunAndroidProject()
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
" ============================================================================
if IsInstalled("vim-operator-user")
    call neobundle#config('vim-operator-user', {
        \   'autoload': {
        \       'mappings': '<Plug>(operator-'
        \   }
        \})

    map [Space]c <Plug>(operator-camelize-toggle)
    map [Space]p <Plug>(operator-replace)
    map [Space]P "+<Plug>(operator-replace)
    map [Space]/ <Plug>(operator-search)
    map sa <Plug>(operator-surround-append)
    map sd <Plug>(operator-surround-delete)
    map sr <Plug>(operator-surround-replace)
    nmap sdb <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap srb <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

    let s:hooks = neobundle#get_hooks("vim-operator-user")
    function! s:hooks.on_source(bundle)
        " clipboard copyのoperator
        " http://www.infiniteloop.co.jp/blog/2011/11/vim-operator/
        function! OperatorYankClipboard(motion_wiseness)
            let visual_commnad =
                \ operator#user#visual_command_from_wise_name(a:motion_wiseness)
            execute 'normal!' '`['.visual_commnad.'`]"+y'
        endfunction

        call operator#user#define('yank-clipboard', 'OperatorYankClipboard')
    endfunction
    unlet s:hooks
    map [Space]y <Plug>(operator-yank-clipboard)
endif
" }}}
" textobj {{{
" ============================================================================
if IsInstalled("vim-textobj-lastpat")
    nmap gn <Plug>(textobj-lastpat-n)
    nmap gN <Plug>(textobj-lastpat-N)
endif
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
xmap ab <Plug>(textobj-multiblock-a)
xmap ib <Plug>(textobj-multiblock-i)
" }}}
" vim-easymotion {{{
" ============================================================================
if IsInstalled('vim-easymotion')
    call neobundle#config('vim-easymotion', {
        \   'autoload': {
        \       'mappings': '<Plug>(easymotion-'
        \   }
        \})

    map S <Plug>(easymotion-s2)
    map f <Plug>(easymotion-fl)
    map t <Plug>(easymotion-tl)
    map F <Plug>(easymotion-Fl)
    map T <Plug>(easymotion-Tl)


    let s:bundle = neobundle#get("vim-easymotion")
    function! s:bundle.hooks.on_source(bundle)
        let g:EasyMotion_keys = 'asdfgghjkl;:qwertyuiop@zxcvbnm,./1234567890-'
        let g:EasyMotion_do_mapping = 0
    endfunction
    unlet s:bundle
endif
"}}}
" vim-multiple-cursors {{{
" ============================================================================
if IsInstalled('vim-multiple-cursors')
    let g:multi_cursor_use_default_mapping = 0
    let g:multi_cursor_next_key='+'
    let g:multi_cursor_prev_key="-"
    let g:multi_cursor_skip_key='&'
    let g:multi_cursor_quit_key='<Esc>'
endif
" }}}
" vim-partedit {{{
" =============================================================================
if IsInstalled('vim-partedit')
    let g:partedit#auto_prefix = 0
endif
"}}}
" vim-visualstar {{{
" ==============================================================================
if IsInstalled('vim-visualstar')
    map * <Plug>(visualstar-*)N
    map # <Plug>(visualstar-g*)N
endif "}}}
" vim-alignta {{{
" ==============================================================================
if IsInstalled('vim-alignta')
    xnoremap [ALIGNTA] <Nop>
    xmap <Leader>a [ALIGNTA]
    xnoremap [ALIGNTA]s :Alignta \S\+<CR>
    xnoremap [ALIGNTA]= :Alignta =<CR>
    xnoremap [ALIGNTA]> :Alignta =><CR>
    xnoremap [ALIGNTA]: :Alignta :<CR>
endif
" }}}
" LeafCage/yankround.vim {{{
" ============================================================================
if IsInstalled('yankround.vim')
    call neobundle#config('yankround.vim', {
        \   'autoload': {
        \       'mappings': '<Plug>(yankround-',
        \       'unite_sources' : 'yankround'
        \   }
        \})

    let g:yankround_dir = $VIMDIR.'/.yankround'

    nmap p <Plug>(yankround-p)
    xmap p <Plug>(yankround-p)
    nmap P <Plug>(yankround-P)
    nmap gp <Plug>(yankround-gp)
    xmap gp <Plug>(yankround-gp)
    nmap gP <Plug>(yankround-gP)
    nmap <expr><C-p> yankround#is_active() ? "\<Plug>(yankround-prev)" : "gT"
    nmap <expr><C-n> yankround#is_active() ? "\<Plug>(yankround-next)" : "gt"
endif
"}}}
" caw {{{
" ==============================================================================
" http://d.hatena.ne.jp/osyo-manga/20120106/1325815224
if IsInstalled('caw.vim')
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
if IsInstalled('vim-jsbeautify')
    autocmd MyVimrc FileType javascript setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType css        setlocal formatexpr=CSSBeautify()
    autocmd MyVimrc FileType html       setlocal formatexpr=HtmlBeautify()
else
    autocmd MyVimrc FileType html
        \   nnoremap gq :%s/></>\r</ge<CR>gg=G
        \|  xnoremap gq  :s/></>\r</ge<CR>gg=G
endif

if executable('xmllint')
    " formatexprの方が優先されるので、消しておく必要がある
    autocmd MyVimrc FileType xml setlocal formatprg=xmllint\ --format\ - formatexpr=
else
    autocmd MyVimrc FileType xml
        \   nnoremap gq :%s/></>\r</ge<CR>gg=G
        \|  xnoremap gq  :s/></>\r</ge<CR>gg=G
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
" let g:automatic_config = [
"             \   {
"             \       'match' : {'bufname' : 'vimshell'}
"             \   }
"             \]
" }}}
" foldCC {{{
" ------------------------------------------------------------------------------
" http://leafcage.hateblo.jp/entry/2013/04/24/053113
if IsInstalled('foldCC')
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

autocmd MyVimrc BufEnter * call UpdateSaveversDirs()
function! UpdateSaveversDirs()
    let s:basedir = $VIMDIR . "/.savevers"
    " ドライブ名を変更して、連結する (e.g. C: -> /C/)
    let g:savevers_dirs = s:basedir . substitute(expand("%:p:h"), '\v\c^([a-z]):', '/\1/' , '')
endfunction

autocmd MyVimrc BufWrite * call ExistOrMakeSaveversDirs()
function! ExistOrMakeSaveversDirs()
    if !isdirectory(g:savevers_dirs)
        call mkdir(g:savevers_dirs, "p")
    endif
endfunction
" }}}
" scrooloose/syntastic {{{
" ============================================================================
if IsInstalled('syntastic')
    let g:syntastic_mode_map = {
        \   'mode': 'active',
        \   'passive_filetypes': ['vim']
        \}
    let g:syntastic_auto_loc_list = 1
endif
" }}}
" eclim {{{
" -----
if IsInstalled('eclim')
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
if IsInstalled('vimconsole.vim')
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
if IsInstalled('vim-fugitive')
    let s:hooks = neobundle#get_hooks("vim-fugitive")

    function! s:hooks.on_source(bundle)
        nnoremap [fugitive] <Nop>
        nmap <Leader>g [fugitive]
        nnoremap [fugitive]d :Gdiff<CR>
        nnoremap [fugitive]s :Gstatus<CR>
        nnoremap [fugitive]l :Glog<CR>
        nnoremap [fugitive]p :Git pull --rebase origin master<CR>

        nnoremap [fugitive]] :diffget //2 <Bar> diffupdate\<CR>
        nnoremap [fugitive][ :diffget //3 <Bar> diffupdate\<CR>

        function! s:ctags()
            if exists('b:git_dir') && executable(b:git_dir.'/hooks/ctags')
                call system('"'.b:git_dir.'/hooks/ctags" &') |
            endif
        endfunction
        command! Ctags call s:ctags()
    endfunction
endif
" }}}
" gitv {{{
" --------
if IsInstalled('gitv')
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
endif
" }}}
" open-browser.vim {{{
" ==============================================================================
if IsInstalled("open-browser.vim")
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
" vimrepress {{{
" ============================================================================
if IsInstalled('vimrepress')
    call neobundle#config('vimrepress', {
        \   'autoload' : {
        \       'commands' : [
        \           'BlogList', 'BlogNew', 'BlogSave', 'BlogPreview'
        \       ]
        \   },
        \})
endif
" }}}
" vimwiki {{{
" ============================================================================
if IsInstalled('vimwiki')
    call neobundle#config('vimwiki', {
        \   'autoload': {
        \       'mappings': '<Plug>Vimwiki'
        \   }
        \})

    nmap <Leader>ww  <Plug>VimwikiIndex

    let g:vimwiki_list = [{
        \   'path': '~/Dropbox/vimwiki/wiki/', 'path_html': '~/Dropbox/vimwiki/public_html/',
        \   'syntax': 'markdown', 'ext': '.txt'
        \   }]

    let s:bundle = neobundle#get('vimwiki')
    function! s:bundle.hooks.on_source(bundle)
    endfunction
    unlet s:bundle
endif
" }}}
" memoliset.vim {{{
" ============================================================================
if IsInstalled('memolist.vim')
    call neobundle#config('memolist.vim', {
        \   'autoload': {
        \       'commands': ['MemoNew', 'MemoList', 'MemoGrep']
        \   }
        \})

    nnoremap <Leader>mn  :MemoNew<CR>
    nnoremap <Leader>ml  :MemoList<CR>
    nnoremap <Leader>mg  :MemoGrep<CR>

    let g:memolist_path = expand('~/Dropbox/memo')

    let s:bundle = neobundle#get('memolist.vim')
    function! s:bundle.hooks.on_source(bundle)
        let g:memolist_memo_suffix = "txt"
        let g:memolist_unite = 1
    endfunction
    unlet s:bundle
endif
" }}}
" qfixhowm {{{
" ==============================================================================
if IsInstalled('qfixhowm')

    let s:bundle = neobundle#get("qfixhown")
    function! s:bundle.hooks.on_source(bundle)
        " QFixHowm互換を切る
        let g:QFixHowm_Convert = 0
        let g:qfixmemo_mapleader = '\M'
        " デフォルトの保存先
        let g:qfixmemo_dir = $HOME . '/Dropbox/memo'
        let g:qfixmemo_filename = '%Y/%m/%Y-%m-%d'
        " メモファイルの拡張子
        let g:qfixmemo_ext = 'txt'
        " ファイルタイプをmarkdownにする
        let g:qfixmemo_filetype = 'mkd'
        " 外部grep使用
        let g:mygrepprg='grep'
        " let g:QFixMRU_RootDir = qfixmemo_dir
        " let g:QFixMRU_Filename = qfixmemo_dir . '/mainmru'
        " let g:qfixmemo_timeformat = 'date: %Y-%m-%d %H:%M'
        let g:qfixmemo_template = [
            \   '%TITLE% ',
            \   '==========',
            \   '%DATE%',
            \   'tags: []',
            \   'categories: []',
            \   '- - -',
            \   ''
            \]
        let g:qfixmemo_title = 'title:'
        " let g:qfixmemo_timeformat = '^date: \d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}'
        " let g:qfixmemo_timestamp_regxp = g:qfixmemo_timeformat_regxp
        " let g:qfixmemo_template_keycmd = "2j$a"
        let g:QFixMRU_Title = {}
        let g:QFixMRU_Title['mkd'] = '^title:'
        let qfixmemo_folding = 0
        " let g:qfixmemo_title    = '#'
        " let g:QFixMRU_Title = {}
        " let g:QFixMRU_Title['mkd'] = '^# '
        " let g:QFixMRU_Title['md'] = '^# '
    endfunction
    unlet s:bundle
endif
" }}}
