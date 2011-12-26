set nocompatible "vi互換にしない

"-------------------------------------------------------------------------------
" 表示
"-------------------------------------------------------------------------------
set showmode "現在のモードを表示
set showcmd "コマンドを表示
set number
set ruler

"-------------------------------------------------------------------------------
" ステータスライン 
"-------------------------------------------------------------------------------

" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"               0: 全く表示しない
"               1: ウィンドウの数が2以上のときのみ表示
"               2: 常に表示
set laststatus=2

set statusline=%f%=%m%r[%{(&fenc!=''?&fenc:&enc)}][%{&ff}][%Y][%v,%l]\ %P

"256色
set t_Co=256

"http://www.vim.org/scripts/script.php?script_id=2340
colorscheme molokai
syntax enable
"set background=dark
"colorscheme solarized
filetype plugin indent on
 
"https://github.com/tpope/vim-pathogen
"call pathogen#infect()

"タブページの設定
" いつタブページのラベルを表示するかを指定する。
"                0: 表示しない
"                1: 2個以上のタブページがあるときのみ表示
"                2: 常に表示
" set showtabline=1


"-------------------------------------------------------------------------------
" コマンドモード
"-------------------------------------------------------------------------------
"set wildmenu "コマンド入力時にTabを押すと補完メニューを表示する

"コマンドモードの補完をシェルコマンドの補完のようにする
"http://vim-jp.org/vimdoc-ja/options.html#%27wildmode%27
set wildmode=list:longest
"前方一致をCtrl+PとCtrl+Nで
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>


"-------------------------------------------------------------------------------
" バッファ
"-------------------------------------------------------------------------------
" <S-Tab>はTera Termのデフォルトの設定では使えない
" 設定方法はこちら
" http://sanrinsha.lolipop.jp/blog/2011/10/tera-term.html
" 面倒な場合は下の<C-n><C-p>の方法をとるべし
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
"nnoremap <C-n> :bn<CR>
"nnoremap <C-p> :bp<CR>

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
"-------------------------------------------------------------------------------
" ウィンドウ
"-------------------------------------------------------------------------------
nnoremap <C-w>; <C-w>+
"縦分割されたウィンドウのスクロールを同期させる
"同期させたいウィンドウ上で<F10>を押せばおｋ
"解除はもう一度<F10>を押す
"横スクロールも同期させたい場合はこちら
"http://ogawa.s18.xrea.com/fswiki/wiki.cgi?page=Vim%A4%CE%A5%E1%A5%E2
nnoremap <F10> :set scrollbind!<CR>
 
"-------------------------------------------------------------------------------
" タブ・インデント
"-------------------------------------------------------------------------------
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


"-------------------------------------------------------------------------------
" paste
"-------------------------------------------------------------------------------
"pasteモードのトグル。autoindentをonにしてペーストすると
"インデントが入った文章が階段状になってしまう。
"pasteモードではautoindentが解除されそのままペーストできる
set pastetoggle=<F11>  

"Tera TermなどのBracketed Paste Modeをサポートした端末では
"以下の設定で、貼り付けるとき自動的にpasteモードに切り替えてくれる。
"http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html
if &term =~ "xterm" && v:version > 603
    "for screen
    " .screenrcでterm xterm-256colorとしている場合 
    if &term == "xterm-256color"
        let &t_SI = &t_SI . "\eP\e[?2004h\e\\"
        let &t_EI = "\eP\e[?2004l\e\\" . &t_EI
        let &pastetoggle = "\e[201~"
    elseif &term == "xterm" 
        let &t_SI .= &t_SI . "\e[?2004h"  
        let &t_EI .= "\e[?2004l" . &t_EI
        let &pastetoggle = "\e[201~" 
    endif

    function XTermPasteBegin(ret) 
        set paste 
        return a:ret 
    endfunction 

    imap <special> <expr> <Esc>[200~ XTermPasteBegin("") 
endif

"-------------------------------------------------------------------------------
" マウス
"-------------------------------------------------------------------------------
" Enable mouse support.
" Ctrlを押しながらマウスをを使うとmouse=aをセットしてないときの挙動になる
set mouse=a 
 
" For screen. 
" .screenrcでterm xterm-256colorとしている場合 
if &term == "xterm-256color" 
    augroup MyAutoCmd 
        autocmd VimLeave * :set mouse= 
    augroup END 
 
    " screenでマウスを使用するとフリーズするのでその対策 
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

"-------------------------------------------------------------------------------
" 検索
"-------------------------------------------------------------------------------
set incsearch
"set ignorecase "検索パターンに大文字を含まなければ大文字小文字を区別しない
set smartcase "検索パターンに大文字を含んでいたら大文字小文字を区別する
set nohlsearch "検索結果をハイライトしない


" ESCキー2度押しでハイライトのトグル
nnoremap <Esc><Esc> :<C-u>set nohlsearch!<CR>

"set hlsearch  " highlight search
"nnoremap <Esc><Esc> :<C-u>set nohlsearch<Return>
"nnoremap / :<C-u>set hlsearch<Return>/
"nnoremap ? :<C-u>set hlsearch<Return>?
"nnoremap * :<C-u>set hlsearch<Return>*
"nnoremap # :<C-u>set hlsearch<Return>#

"ヴィビュアルモードで選択した範囲だけ検索
vnoremap /v <ESC>/\%V
vnoremap ?v <ESC>?\%V

 
 
"-------------------------------------------------------------------------------
" カーソル
"-------------------------------------------------------------------------------
"カーソルを表示行で移動する。
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
vnoremap j gj
vnoremap k gk
vnoremap <down> gj
vnoremap <up> gk
 
" backspaceキーの挙動を設定する
" " indent        : 行頭の空白の削除を許す
" " eol           : 改行の削除を許す
" " start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

"カーソルの形状の変化
"http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html

if &term == "xterm-256color" && v:version > 603
    "let &t_SI .= "\eP\e[3 q\e\\"
    let &t_SI .= "\eP\e[?25h\e[5 q\e\\"
    let &t_EI .= "\eP\e[1 q\e\\"
elseif &term == "xterm" && v:version > 603
    "let &t_SI .= "\e[3 q"
    let &t_SI .= "\e[?25h\e[5 q"
    let &t_EI .= "\e[1 q"
endif

"set notimeout      " マッピングについてタイムアウトしない
"set ttimeout       " 端末のキーコードについてタイムアウトする
set timeoutlen=300 " ミリ秒後にタイムアウトする


" カッコ・タグの対応
"-------------------------------------------------------------------------------
set showmatch matchtime=1 "括弧の対応
source $VIMRUNTIME/macros/matchit.vim "HTML tag match


"-------------------------------------------------------------------------------
" マップ
"-------------------------------------------------------------------------------
inoremap jj <ESC>


"-------------------------------------------------------------------------------
" 文字コード
"-------------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8

" ファイルのエンコードの判定を前から順番にする
" ファイルを読み込むときに 'fileencodings' が "ucs-bom" で始まるならば、
" BOM が存在するかどうかが調べられ、その結果に従って 'bomb' が設定される。
" http://vim-jp.org/vimdoc-ja/options.html#%27fileencoding%27
" Vimテクニックバイブル
" 2-7ファイルの文字コードを変換するに書いてあるfileencodingsを変更して
" ucs-bomを最初にした
" また、2つあるeuc-jpの2番目を消した
set fileencodings=ucs-bom,iso-2222-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,eucjp-ms,cp932

"□や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
  

"-------------------------------------------------------------------------------
" Manual
"-------------------------------------------------------------------------------
":Man <man>でマニュアルを開く
runtime ftplugin/man.vim
nmap K <Leader>K
"コマンドラインでmanを使ったとき、vimの:Manで見るようにするための設定
"http://vim.wikia.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
".zshrc .bashrc等にも記述が必要
let $PAGER=''

"-------------------------------------------------------------------------------
" gVim
"-------------------------------------------------------------------------------
"Windowsのgvimのメニューの文字化け対応
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"-------------------------------------------------------------------------------
" neocomplcache
"-------------------------------------------------------------------------------
" setting examples:
if v:version >= 702
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    "let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_enable_smart_case = 0
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

    "" Recommended key-mappings.
    "" <CR>: close popup and save indent.
    "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
    "" <TAB>: completion.
    "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    "" <C-h>, <BS>: close popup and delete backword char.
    "inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    "inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    "inoremap <expr><C-y>  neocomplcache#close_popup()
    "inoremap <expr><C-e>  neocomplcache#cancel_popup()

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
    imap <expr><TAB>  pumvisible() ? "\<C-l>" : "\<TAB>"
    inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"


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
endif

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif
