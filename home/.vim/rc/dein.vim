scriptencoding utf-8

let s:dein_dir = g:dein_dir
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければgit clone
if !isdirectory(s:dein_repo_dir)
    echo 'git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir
    call system('git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir)
endif

execute 'set runtimepath^=' . s:dein_repo_dir

let g:dein#install_process_timeout = 1200

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml_files = split(glob('$VIMRC_DIR/*.toml'), "\n")
    for s:toml_file in s:toml_files
        " lazyがついているtomlファイルはlazyとして処理する。
        " pluginディレクトリがないプラグインはlazyにしても意味が無い
        " :h dein#check_lazy_plugins()
        if match(s:toml_file, 'lazy') >= 0
            call dein#load_toml(s:toml_file, {'lazy': 1})
        else
            call dein#load_toml(s:toml_file)
        endif
    endfor

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on

" vimprocは先にインストールする
if dein#check_install(['vimproc.vim'])
  call dein#install(['vimproc.vim'])
endif

if dein#check_install()
    " vimがサイレンスモード(-s)で起動した場合はデフォルトのNoが選ばれる
    " これによってcall dein#install()した後にdein#update()するという
    " 無駄な処理を行わずにすむ
    if confirm('Install bundles now?', "yes\nNo", 2) == 1
        call dein#install()
    endif
endif

" repo以下のautoloadを保存したら.dein以下にコピーする {{{1
" ============================================================================
" dein.vimは.dein以下にautoloadをコピーし、それを使うので、pluginのデバック時に
" repo以下を編集・保存したら.dein以下にコピーするようにする
let s:sync_save_dir_list = [
\    {
\      'glob' : s:dein_dir . '/repos/**/autoload/*.vim',
\      'from' : s:dein_dir . '/repos/.*/autoload',
\      'to'   : s:dein_dir . '/.dein/autoload',
\    },
\    {
\      'glob' : s:dein_dir . '/repos/**/autoload/**/*.vim',
\      'from' : s:dein_dir . '/repos/.*/autoload',
\      'to'   : s:dein_dir . '/.dein/autoload',
\    }
\]

call SetAutocmdSyncSaveDir(s:sync_save_dir_list)

" vim-singleton {{{1
" ============================================================================
if dein#tap('vim-singleton') && has('gui_running')
    call singleton#enable()
endif

" sudo.vim {{{1
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if dein#tap('sudo.vim')
    " if dein#tap('bclose')
    "     nmap <Leader>E :e sudo:%<CR><C-^><Plug>Kwbd
    " else
    "     nnoremap <Leader>E :e sudo:%<CR><C-^>:bd<CR>
    " endif
    nnoremap <Leader>W :w sudo:%<CR>
endif

" vim-smartword {{{1
" ==============================================================================
if dein#tap('vim-smartword')
    map w  <Plug>(smartword-w)
    map b  <Plug>(smartword-b)
    map e  <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)

    map [:space:]w  <Plug>(smartword-basic-w)
    map [:space:]b  <Plug>(smartword-basic-b)
    map [:space:]e  <Plug>(smartword-basic-e)
    map [:space:]ge <Plug>(smartword-basic-ge)
endif

" unite.vim {{{1
" ============================================================================
if dein#tap('unite.vim')
    let g:unite_data_directory = $VIM_CACHE_DIR.'/unite'
    let g:unite_enable_start_insert = 1
    " let g:unite_source_find_max_candidates = 1000

    nnoremap [unite] <Nop>
    nmap , [unite]

    " uniteの選択のカラーをPmenuSelにする。uniteバッファ以外もCursorLineの色がPmenuSelになってしまう
    " augroup MyVimrc
    "     autocmd Filetype unite hi! link CursorLine PmenuSel
    "     autocmd BufLeave \[unite\]* highlight! link CursorLine NONE
    " augroup END

    " uniteウィンドウを閉じる
    nmap <silent> [unite]q :UniteClose<CR>
    nnoremap <silent> <C-W>, :<C-U>call GotoWin('\[unite\]')<CR>
    " 前回のuniteの結果を表示する。このunite画面を終了後にカーソルが戻る位置も前回の起動した位置になってしまう
    nnoremap [unite], :<C-U>UniteResume<CR>

    " バッファ
    nnoremap <silent> [unite]b :<C-U>Unite buffer<CR>

    " ファイル内検索結果
    nnoremap <silent> [unite]l :<C-U>Unite line<CR>

    " Unite output {{{2
    " ------------------------------------------------------------------------
    " Unite output:map {{{3
    " unite-mappingではnormalのマッピングしか出ないので、すべてのマッピングを出力するようにする
    " http://d.hatena.ne.jp/osyo-manga/20130307/1362621589
    nnoremap <silent> [unite]m :<C-U>Unite output:map<Bar>map!<Bar>lmap -default-action=open<CR>

    " :h map-listing
    " <Space>  ノーマル、ビジュアル、選択、オペレータ待機
    "    n     ノーマル
    "    v     ビジュアル、選択
    "    s     選択
    "    x     ビジュアル
    "    o     オペレータ待機
    "    !     挿入、コマンドライン
    "    i     挿入
    "    l     挿入、コマンドライン、Lang-Argでの ":lmap" マップ
    "    c     コマンドライン

    " *   再マップされません
    " &   スクリプトローカルなマップだけが再マップされます
    " @   バッファローカルなマップです。

    " Unite output:message {{{3
    " [unite-messages をつくってみる - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20131030/1383144724)
    " :messagesの最後をunite.vimで表示する
    nnoremap [unite]Om :<C-U>Unite output:messages -log -buffer-name=messages -no-start-insert<CR>

    " Unite outputでruntimpathを出力する {{{3
    nnoremap [unite]Or :<C-U>Unite output:echo\ join(split(&runtimepath,','),\"\\n\")<CR>

    " Unite directory {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリ以下のディレクトリ
    nnoremap [unite]dc :<C-U>Unite directory<CR>
    " カレントバッファのディレクトリ以下
    nnoremap [unite]d. :<C-U>execute "Unite directory:" . GetBufferDir()<CR>
    nnoremap [unite]dp :<C-U>execute "Unite directory:" . GetProjectDir()<CR>
    nnoremap [unite]dd :<C-U>Unite directory:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    nnoremap [unite]dv :<C-U>Unite directory:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]dV :<C-U>Unite directory:$VIM<CR>
    nnoremap [unite]db :<C-U>Unite directory:$HOME/.vim/bundle<CR>
    nnoremap [unite]da :<C-U>Unite directory:/Applications directory:$HOME/Applications<CR>

    " Unite file(_rec) {{{2
    " ------------------------------------------------------------------------
    " プロジェクトディレクトリ以下のファイル
    " こちらのコマンドだと、カレントディレクトリがあるプロジェクトディレクトリ以下
    " nnoremap [unite]fp :<C-U>Unite file_rec:!<CR>
    " こちらのコマンドだと、カレントバッファのファイルがあるプロジェクトディレクトリ以下
    nnoremap [unite]fp :<C-U>call <SID>unite_file_project('-start-insert')<CR>
    function! s:unite_file_project(...)
        let l:opts = (a:0 ? join(a:000, ' ') : '')
        let l:project_dir = GetProjectDir()

        call unite#custom#source(
        \   'neomru/file', 'matchers',
        \   ['matcher_project_files', 'matcher_context'])

        if isdirectory(l:project_dir.'/.git')
            execute 'lcd '.l:project_dir
            execute 'Unite '.opts.' neomru/file file_rec/git:--cached:--others:--exclude-standard'
        else
            execute 'Unite '.opts.' neomru/file file_rec/async:'.l:project_dir
        endif

        call unite#custom#source(
        \   'neomru/file', 'matchers',
        \   ['matcher_context'])
    endfunction

    nnoremap [unite]f. :<C-U>execute "Unite file_rec/async:" . GetBufferDir()<CR>
    nnoremap [unite]fv :<C-U>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]fV :<C-U>Unite file_rec/async:$VIM<CR>
    nnoremap [unite]fd :<C-U>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    execute 'nnoremap [unite]fD :<C-U>Unite file_rec/async:' . s:dein_dir . '/github.com/tmsanrinsha/dotfiles<CR>'

    " unite grep {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリに対してgrep
    nnoremap [unite]gc :<C-U>Unite grep:.<CR>
    " カレントバッファのディレクトリ以下に対してgrep
    nnoremap [unite]g. :<C-U>execute "Unite grep:".expand('%:p:h')<CR>
    " 全バッファに対してgrep
    nnoremap [unite]gB :<C-U>Unite grep:$buffers<CR>
    " プロジェクト内のファイルに対してgrep
    nnoremap [unite]gp :<C-U>call <SID>unite_grep_project('-start-insert')<CR>
    function! s:unite_grep_project(...)
        let opts = (a:0 ? join(a:000, ' ') : '')
        let l:project_dir = GetProjectDir()
        if !executable('ag') && isdirectory(l:project_dir.'/.git')
            execute 'Unite '.opts.' grep/git:/:--untracked'
        else
            execute 'Unite '.opts.' grep:'.l:project_dir
        endif
    endfunction

    nnoremap [unite]gd :<C-U>Unite grep:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    execute 'nnoremap [unite]gD :<C-U>Unite grep:' . s:dein_dir . '<CR>'
    nnoremap [unite]gv :<C-U>Unite grep:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]gV :<C-U>Unite grep:$VIM<CR>
    nnoremap [unite]gb :<C-U>Unite grep:$HOME/.vim/bundle<CR>
    "}}}

    "レジスタ一覧
    nnoremap <silent> [unite]r :<C-U>Unite -buffer-name=register register<CR>
    " ヤンク履歴
    let g:unite_source_history_yank_enable = 1  "history/yankの有効化
    nnoremap <silent> [unite]y :<C-U>Unite history/yank<CR>
    " ブックマーク
    nnoremap <silent> [unite]B :<C-U>Unite bookmark<CR>

    nnoremap <silent> [unite]j :<C-U>Unite jump<CR>

    nnoremap [unite]fM :<C-U>Unite memo<CR>
    execute 'nnoremap [unite]gM :<C-U>Unite grep:'.g:memo_directory.'<CR>'

    nnoremap [unite]D :<C-U>Unite dein -default-action=vimfiler<CR>
endif

" neomru {{{1
" ============================================================================
if dein#tap('neomru.vim')
    "最近使用したファイル一覧
    nnoremap <silent> [unite]fm :<C-U>Unite neomru/file<CR>
    "最近使用したディレクトリ一覧
    nnoremap <silent> [unite]dm :<C-U>Unite neomru/directory<CR>

    " ファイルへの書き込みを60秒ごとにする
    let g:neomru#update_interval = 60
    " ファイルが存在するかチェックする
    let g:neomru#do_validate = 1
endif


" neossh.vim {{{1
" =========================================================================
" let g:neossh#ssh_command = 'ftp.sh -p PORT HOSTNAME'
" let g:neossh#list_command = 'ls'

" let ls -lFa',
" let g:neossh#copy_directory_command',
" let scp -P PORT -q -r $srcs $dest',
" let g:neossh#copy_file_command',
" let scp -P PORT -q $srcs $dest',
" let g:neossh#delete_file_command',
" let rm $srcs',
" let g:neossh#delete_directory_command',
" let rm -r $srcs',
" let g:neossh#move_command',
" let mv $srcs $dest',
" let g:neossh#mkdir_command',
" let mkdir $dest',
" let g:neossh#newfile_command',
" let touch $dest',

" let g:unite_source_ssh_enable_debug = 1

" unite-outline {{{1
" =========================================================================
if dein#tap('unite-outline')
    nnoremap [unite]o<CR> :<C-U>Unite outline<CR>
    nnoremap [unite]of :<C-U>Unite outline:folding<CR>
    nnoremap [unite]oo :<C-U>Unite -vertical -winwidth=40 -no-auto-resize -no-quit outline<CR>
endif

autocmd MyVimrc FileType yaml
\   nnoremap <buffer> [unite]o :<C-U>Unite outline:folding<CR>

" tacroe/unite-mark {{{1
" =========================================================================
nnoremap [unite]` :<C-U>Unite mark<CR>

" neoyank.vim {{{1
" =========================================================================
if dein#tap('neoyank.vim')
    nnoremap [unite]hy :<C-U>Unite history/yank<CR>
    let g:neoyank#file = $VIM_CACHE_DIR.'/yankring.txt'
endif

" vim-unite-history {{{1
" =========================================================================
if dein#tap('vim-unite-history')
    nnoremap [unite]hc :<C-U>Unite history/command<CR>
    nnoremap [unite]hs :<C-U>Unite history/search<CR>
    cnoremap <M-r> :<C-U>Unite history/command -start-insert -default-action=edit<CR>
    inoremap <C-X>,hc <C-O>:Unite history/command -start-insert -default-action=insert<CR>
endif

" unite-ghq {{{1
" ============================================================================
if dein#tap('unite-ghq')
    nnoremap [unite]dg :<C-U>Unite ghq<CR>
endif

" cdr *cdr* {{{1
" ============================================================================
if dein#tap('vital.vim')
    let g:recent_dirs_file = $ZDOTDIR.'/.cache/chpwd-recent-dirs'
    augroup cdr
        autocmd!
        autocmd BufEnter * call s:update_cdr(GetBufferDir())
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

" unite-zsh-cdr.vim {{{2
" ----------------------------------------------------------------------------
if dein#tap('unite-zsh-cdr.vim')
    nnoremap [unite]dr :<C-U>Unite zsh-cdr<CR>
    nnoremap <M-r> :<C-U>Unite zsh-cdr<CR>

    let g:unite_zsh_cdr_chpwd_recent_dirs = g:recent_dirs_file
endif

" vimfiler {{{1
" ==============================================================================
let g:vimfiler_as_default_explorer = 1
" セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0

let g:vimfiler_data_directory = $VIM_CACHE_DIR.'/vimfiler'

nnoremap [VIMFILER] <Nop>
nmap <Leader>f [VIMFILER]
nnoremap <silent> [VIMFILER]f :VimFiler<CR>
nnoremap <silent> [VIMFILER]b :VimFilerBufferDir<CR>
nnoremap <silent> [VIMFILER]c :VimFilerCurrentDir<CR>
nnoremap <silent> [VIMFILER]t :cd %:h<CR>:VimFilerTab<CR>
nnoremap <silent> [VIMFILER]p :execute "VimFilerExplorer ". unite#util#path2project_directory(expand('%'))<CR>

autocmd MyVimrc FileType vimfiler
    \   nmap <buffer> \\ <Plug>(vimfiler_switch_to_root_directory)
" vimfilerでvim-surroundのmapを消す。vimfilerからunite.vimを使った時エラーがでるので
" silentする
autocmd MyVimrc BufEnter vimfiler*
    \   silent! nunmap ds
    \|  silent! nunmap cs
autocmd MyVimrc BufLeave vimfiler*
    \   nmap ds <Plug>Dsurround
    \|  nmap cs <Plug>Csurround

" vimshell {{{1
" ============================================================================
if dein#tap('vimshell.vim')
    nmap <leader>H [VIMSHELL]
    xmap <leader>H [VIMSHELL]
    nnoremap [VIMSHELL]H   :VimShellPop<CR>
    nnoremap [VIMSHELL]b   :VimShellBufferDir -popup<CR>
    nnoremap [VIMSHELL]c   :VimShellCurrentDir -popup<CR>

    nnoremap [VIMSHELL]i   :VimShellInteractive
    nnoremap [VIMSHELL]ipy :VimShellInteractive python<CR>
    nnoremap [VIMSHELL]iph :VimShellInteractive php<CR>
    nnoremap [VIMSHELL]irb :VimShellInteractive irb<CR>
    nnoremap [VIMSHELL]iR  :VimShellInteractive R<CR>
    nnoremap [VIMSHELL]s   :VimShellSendString<CR>
    xnoremap [VIMSHELL]s   :VimShellSendString<CR>

    function! s:vimshell_on_source() abort
        nnoremap [VIMSHELL] <Nop>
        " <Leader>ss: 非同期で開いたインタプリタに現在の行を評価させる
        "vmap <silent> <Leader>ss :VimShellSendString<CR>
        "" 選択中に<Leader>ss: 非同期で開いたインタプリタに選択行を評価させる
        "nnoremap <silent> <Leader>ss <S-v>:VimShellSendString<CR>

        if has('mac')
            call vimshell#set_execute_file('html', 'gexe open -a /Applications/Firefox.app/Contents/MacOS/firefox')
            call vimshell#set_execute_file('avi,mp4,mpg,ogm,mkv,wmv,mov', 'gexe open -a /Applications/MPlayerX.app/Contents/MacOS/MPlayerX')
        endif

        let g:vimshell_prompt = hostname() . '> '
        let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
        let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b] ", "(%s)-[%b|%a] ")' " Shougo/vim-vcs is required

        let g:vimshell_data_directory = $VIM_CACHE_DIR.'/vimshell'

        let g:vimshell_max_command_history = 3000

        let g:vimshell_vimshrc_path = $VIMRC_DIR.'/.vimshrc'

        autocmd MyVimrc FileType vimshell
            \   setlocal nonumber
            \|  setlocal nocursorline
            \|  nmap <buffer> q <Plug>(vimshell_hide)<C-W>=
            \|  imap <buffer> <M-n> <Plug>(vimshell_history_neocomplete)
            \|  imap <buffer> <C-K> <Plug>(vimshell_zsh_complete)
            \|  call vimshell#altercmd#define('g', 'git')
            \|  call vimshell#altercmd#define('l', 'll')
            \|  call vimshell#altercmd#define('ll', 'ls -l')
            \|  call vimshell#altercmd#define('la', 'ls -a')
            \|  call vimshell#altercmd#define('lla', 'ls -la')
        "\|  call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
        "function! g:my_chpwd(args, context)
        "    call vimshell#execute('ls')
        "endfunction

        autocmd MyVimrc FileType int-*
            \   inoremap <buffer> <expr> <C-P> pumvisible() ? "\<C-P>" : "\<C-X>\<C-L>"
            " \|  execute 'setlocal filetype='.matchstr(&filetype, 'int-\zs.*')
        let g:vimshell_split_command = 'split'
    endfunction

    execute 'autocmd MyVimrc User' 'dein#source#' . g:dein#name
    \   'call s:vimshell_on_source()'
endif

" Conque-Shell {{{1
" ============================================================================
if dein#tap('Conque-Shell')
    " 現在のバッファのディレクトリでzshを立ち上げる
    noremap <Leader>C<CR> :ConqueTerm zsh<CR>
    noremap <Leader>Cb    :cd %:h <bar> ConqueTerm zsh<CR>

    let g:neocomplete#lock_buffer_name_pattern = 'zsh -'
endif

" neosnippet {{{1
" ==============================================================================
if dein#tap('neosnippet.vim')
  " disables all runtime snippets
  let g:neosnippet#disable_runtime_snippets = {
  \   '_' : 1,
  \ }

  " Tell Neosnippet about the other snippets
  " 同じ名前のスニペットがあった時、上書きはされない
  let g:neosnippet#snippets_directory = [
  \   $HOME . '/.vim/snippets',
  \   s:dein_dir . '/repos/github.com/Shougo/neosnippet-snippets/neosnippets',
  \   s:dein_dir . '/repos/github.com/honza/vim-snippets/snippets',
  \]
endif

" SirVer/ultisnips {{{1
" ==============================================================================
" let g:UltiSnipsUsePythonVersion = 2
" " let g:UltiSnipsSnippetsDir=$HOME.'/.vim/bundle/vim-snippets/UltiSnips'
" let g:UltiSnipsExpandTrigger="<c-f>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" Valloric/Youcompleteme {{{1
" ==============================================================================
let g:ycm_filetype_whitelist = { 'java': 1 }

" Shougo/context_filetype.vim {{{1
" ==============================================================================
if dein#tap('context_filetype.vim')
    let g:context_filetype#filetypes = deepcopy(context_filetype#default_filetypes())

    " markdown
    call add(g:context_filetype#filetypes.markdown, {
    \   'filetype': 'css',
    \   'start': '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
    \   'end': '</style>'
    \})

    " Rmd
    let g:context_filetype#filetypes.rmd = g:context_filetype#filetypes.markdown

endif


" thinca/vim-template {{{1
" ============================================================================
autocmd MyVimrc User plugin-template-loaded
\   if search('<+CURSOR+>')
\ |     execute 'normal! "_da>'
\ | endif

" vim-quickrun {{{1
" ============================================================================
if dein#tap('vim-quickrun')
    let g:quickrun_no_default_key_mappings = 1
    nnoremap <Leader>r<CR> :QuickRun -mode n<CR>
    xnoremap <Leader>r<CR> :QuickRun -mode v<CR>
endif

" vim-watchdogs {{{1
" ============================================================================
if dein#tap('vim-watchdogs')
    augroup WatchdogsSetting
        autocmd!
        autocmd BufWritePre *
        \   call dein#source("vim-watchdogs") |
        \   autocmd! WatchdogsSetting
    augroup END
endif

" quickfix系プラグインのアップデート {{{1
" ============================================================================
" quickfixを開いてHierUpdateなどをしたい場合は以下のようにする
autocmd MyVimrc FileType qf call s:qf_update()
function! s:qf_update()
    windo HierUpdate
    windo QfsignsUpdate
    windo QuickfixStatusEnable
endfunction

" qfsigns {{{1
" ============================================================================
" let g:qfsigns#AutoJump = 1
let g:qfsigns#Config = {'id': '5050', 'name': 'qfsign'}
sign define qfsign texthl=SignColumn text=>>

" quickfixsign_vim {{{1
" ============================================================================
" let g:quickfixsigns_classes = ['qfl']

" operator {{{1
" ============================================================================
onoremap ; t;

if dein#tap('vim-operator-user')

    map [:space:]c <Plug>(operator-camelize-toggle)
    map [:space:]p <Plug>(operator-replace)
    map [:space:]P "+<Plug>(operator-replace)
    map [:space:]/ <Plug>(operator-search)

    " surround {{{2
    " ------------------------------------------------------------------------
    map sa <Plug>(operator-surround-append)
    map sd <Plug>(operator-surround-delete)
    map sr <Plug>(operator-surround-replace)
    nmap saa <Plug>(operator-surround-append)<Plug>(textobj-multiblock-i)
    nmap saA <Plug>(operator-surround-append)<Plug>(textobj-multiblock-a)
    nmap sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
    nmap sd" <Plug>(operator-surround-delete)a"
    nmap sr" <Plug>(operator-surround-delete)a"

    let g:operator#surround#blocks = {}
    " zは全角
    let g:operator#surround#blocks['-'] = [
    \   { 'block' : ['（', '）'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['z('] },
    \   { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['z['] },
    \   { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['2z['] },
    \ ]
endif

" clipboard copy {{{1
" ============================================================================
nmap [:space:]y "*y
xmap [:space:]y "*y
nmap [:space:]yy "*yy
nmap [:space:]Y "*y$

" vim-fakeclip {{{1
" ----------------------------------------------------------------------------
if dein#tap('vim-fakeclip')
    " +clipboardでもfakeclipのキーマッピングを使う
    let g:fakeclip_provide_clipboard_key_mappings = 1
    " クリップボードコピーのコマンドにrfpbcopyを使う
    " let g:fakeclip_write_clipboard_command = 'rfpbcopy'
    let g:fakeclip_write_clipboard_command = 'paste64.mac'
endif

" textobj {{{1
" ============================================================================
if dein#tap('vim-textobj-lastpat')
    let g:textobj_lastpat_no_default_key_mappings = 1
    nmap gn <Plug>(textobj-lastpat-n)
    nmap gN <Plug>(textobj-lastpat-N)
endif

omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
xmap ab <Plug>(textobj-multiblock-a)
xmap ib <Plug>(textobj-multiblock-i)

" matchparisの括弧を追加
let g:textobj_multiblock_blocks = []
for s:val in split(&matchpairs, ',')
    let s:pair = split(s:val, ':')
    call add(g:textobj_multiblock_blocks, s:pair)
endfor

omap ic <Plug>(textobj-comment-i)
xmap ic <Plug>(textobj-comment-i)
omap ac <Plug>(textobj-comment-a)
xmap ac <Plug>(textobj-comment-a)
omap aC <Plug>(textobj-comment-big-a)
xmap aC <Plug>(textobj-comment-big-a)

omap iC <Plug>(textobj-context-i)
xmap iC <Plug>(textobj-context-i)

omap ae <Plug>(textobj-entire-a)
omap ie <Plug>(textobj-entire-i)
xmap ae <Plug>(textobj-entire-a)
xmap ie <Plug>(textobj-entire-i)

" let g:textobj_conflict_no_default_key_mappings = 1
" omap ix <Plug>(textobj-conflict-i)
" omap ax <Plug>(textobj-conflict-a)
" xmap ix <Plug>(textobj-conflict-i)
" omap ax <Plug>(textobj-conflict-a)

if IsInstalled('vim-textobj-xbrackets')
    " change surround function
    nmap csf vax(ovct(
    " delte surround function
    nmap dsf vax(ovdt(

    " これも良さそう
    " [hoge() で囲みたい症候群 - vim 初心者の作業メモ](http://d.hatena.ne.jp/syngan/20140301/1393676442)
endif

" vital-coaster, CTRL-A, CTRL-X {{{1
" ============================================================================
" - の前に空白文字以外があれば <C-X> を、それ以外は <C-A> を呼ぶ
" "Vim で特定の条件でのみ <C-A> でインクリメントしないようにする - Secret Garden(Instrumental":http://secret-garden.hatenablog.com/entry/2015/05/14/180752
" -423  ←これは <C-A> される
" d-423 ←これは <C-X> される

if dein#tap('vital-coaster')
    nmap <C-A> <Plug>(my-increment)
    nmap <C-X> <Plug>(my-decriment)

    nnoremap <expr> <Plug>(my-increment) <SID>increment('\S-\d\+', "\<C-X>")
    nnoremap <expr> <Plug>(my-decriment) <SID>decrement('\S-\d\+', "\<C-A>")
    let s:Buffer = vital#of('vital').import('Coaster.Buffer')

    function! s:count(pattern, then, else)
        let word = s:Buffer.get_text_from_pattern(a:pattern)
        if word !=# ''
            return a:then
        else
            return a:else
        endif
    endfunction

    " 第一引数に <C-A> を無視するパターンを設定
    " 第二引数に無視した場合の代替キーを設定
    function! s:increment(ignore_pattern, ...)
        let key = get(a:, 1, '')
        return s:count(a:ignore_pattern, key, "\<C-A>")
    endfunction

    function! s:decrement(ignore_pattern, ...)
        let key = get(a:, 1, '')
        return s:count(a:ignore_pattern, key, "\<C-X>")
    endfunction
endif

" vim-multiple-cursors {{{1
" ============================================================================
if dein#tap('vim-multiple-cursors')
    let g:multi_cursor_use_default_mapping = 0
    let g:multi_cursor_next_key='+'
    let g:multi_cursor_prev_key='-'
    let g:multi_cursor_skip_key='&'
    let g:multi_cursor_quit_key='<Esc>'
endif

" vim-partedit {{{1
" ============================================================================
if dein#tap('vim-partedit')
    " let g:partedit#auto_prefix = 0

    nnoremap <Leader>pe :<C-U>MyParteditContext<CR>
    xnoremap <Leader>pe :Partedit -opener split<CR>
    nnoremap <Leader>pq :<C-U>ParteditEnd<CR>
    function! s:partedit_context()
        let context = context_filetype#get()
        let startline = context['range'][0][0] ? context['range'][0][0] : 1
        let endline   = context['range'][1][0] ? context['range'][1][0] : '$'
        let filetype  = context['filetype']
        call partedit#start(startline, endline, {'filetype': filetype, 'opener': 'split'})
    endf
    command! MyParteditContext call s:partedit_context()

endif

" vim-alignta {{{1
" ==============================================================================
if dein#tap('vim-alignta')
    xnoremap [ALIGNTA] <Nop>
    xmap <Leader>a [ALIGNTA]
    xnoremap [ALIGNTA]s :Alignta \S\+<CR>
    xnoremap [ALIGNTA]= :Alignta =<CR>
    xnoremap [ALIGNTA]> :Alignta =><CR>
    xnoremap [ALIGNTA]: :Alignta :<CR>
endif

" LeafCage/yankround.vim :paste:yank: {{{1
" ============================================================================
nnoremap ]p p`[v`]=
nnoremap ]P P`[v`]=
xnoremap ]p p`[v`]=
xnoremap ]P P`[v`]=

" インデントを考慮したペースト]p,]Pとペーストしたテキストの最後に行くペーストgp,gPを合わせたようなもの
nnoremap ]gp p`[v`]=`]
nnoremap ]gP P`[v`]=`]
xnoremap ]gp p`[v`]=`]
xnoremap ]gP P`[v`]=`]

if dein#tap('yankround.vim')
    let g:yankround_dir = $VIM_CACHE_DIR.'/yankround'

    let g:yankround_use_region_hl = 1
    autocmd MyVimrc ColorScheme *
        \   highlight! YankRoundRegion ctermfg=16 ctermbg=187
    doautocmd MyVimrc ColorScheme

    nmap p  <Plug>(yankround-p)
    xmap p  <Plug>(yankround-p)
    nmap P  <Plug>(yankround-P)
    nmap gp <Plug>(yankround-gp)
    xmap gp <Plug>(yankround-gp)
    nmap gP <Plug>(yankround-gP)
endif

" gf {{{1
" ============================================================================
" =をファイル名に使われる文字から外す
set isfname-==
" spaceをファイル名に使われる文字に含める
" これをやると2つ以上のファイル・ディレクトリを引数にとるコマンドで、2つ目以降の引数の補完がうまくいかなくなる
" set isfname+=32

" vim-gf-user {{{2
" ----------------------------------------------------------------------------
if dein#tap('vim-gf-user')
    let g:gf_user_no_default_key_mappings = 1
    " ディレクトリの場合にうまくvimfilerが開かない
    " gf#user#doのtryを外すと開く。エラーではないのかcatchはできない
    " :eで開き直すとvimfilerが起動する
    nmap [:space:]gf         <Plug>(gf-user-gf)
    xmap [:space:]gf         <Plug>(gf-user-gf)
    nmap [:space:]gF         <Plug>(gf-user-gF)
    xmap [:space:]gF         <Plug>(gf-user-gF)
    nmap [:space:]<C-W>f     <Plug>(gf-user-<C-W>f)
    xmap [:space:]<C-W>f     <Plug>(gf-user-<C-W>f)
    nmap [:space:]<C-W><C-F> <Plug>(gf-user-<C-W><C-F>)
    xmap [:space:]<C-W><C-F> <Plug>(gf-user-<C-W><C-F>)
    nmap [:space:]<C-W>F     <Plug>(gf-user-<C-W>F)
    xmap [:space:]<C-W>F     <Plug>(gf-user-<C-W>F)
    nmap [:space:]<C-W>gf    <Plug>(gf-user-<C-W>gf)
    xmap [:space:]<C-W>gf    <Plug>(gf-user-<C-W>gf)
    nmap [:space:]<C-W>gF    <Plug>(gf-user-<C-W>gF)

    " カーソル下のファイル名のファイルを、現在開いているファイルと同じディレクトリに開く
    function! GfNewFile()
        let path = expand('%:p:h').'/'.expand('<cfile>')
        let line = 0
        if path =~# ':\d\+:\?$'
            let line = matchstr(path, '\d\+:\?$')
            let path = matchstr(path, '.*\ze:\d\+:\?$')
        endif
        return {
        \   'path': path,
        \   'line': line,
        \   'col': 0,
        \ }
    endfunction
    call gf#user#extend('GfNewFile', 3000)
endif


" tcomment_vim {{{1
" ============================================================================
if dein#tap('tcomment_vim')
    " コメントアウトしてコピー
    nmap <C-_>y yyP<Plug>TComment_<C-_><C-_>j
    xmap <C-_>y ygv<Plug>TComment_<C-_><C-_>gv<C-c>p

    let g:tcommentTextObjectInlineComment = ''
endif

" vim-jsbeautify {{{1
" ==============================================================================
if dein#tap('vim-jsbeautify')
    autocmd MyVimrc FileType javascript setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType css        setlocal formatexpr=CSSBeautify()
    autocmd MyVimrc FileType html       setlocal formatexpr=HtmlBeautify()

    " こう設定しないとpangloss/vim-javascriptに上書きされてしまう
    " ⇡しなくてもうまくいった
    " autocmd MyVimrc BufRead  *.js       setlocal formatexpr=JsBeautify()
else
    autocmd MyVimrc FileType html
        \   nnoremap <buffer> gq :%s/></>\r</ge<CR>gg=G
        \|  xnoremap <buffer> gq  :s/></>\r</ge<CR>gg=G
endif

" automatic {{{1
" ============================================================================
" http://d.hatena.ne.jp/osyo-manga/20130812/1376314945
" http://blog.supermomonga.com/articles/vim/automatic.html
" let g:automatic_default_set_config = {
"             \   'height' : '20%',
"             \   'move' : 'bottom',
"             \ }
" let g:automatic_config = [
"             \   {
"             \       'match' : {'bufname' : 'vimshell'}
"             \   }
"             \]

" fold {{{1
" ============================================================================
set foldmethod=marker
" foldmethod=expr が重い場合の対処法 - 永遠に未完成
" <http://d.hatena.ne.jp/thinca/20110523/1306080318>
autocmd MyVimrc InsertEnter *
    \|  if &l:foldmethod ==# 'expr'
    \|      let b:foldinfo = [&l:foldmethod, &l:foldexpr]
    \|      setlocal foldmethod=manual foldexpr=0
    \|  endif
autocmd MyVimrc InsertLeave *
    \|  if exists('b:foldinfo')
    \|      let [&l:foldmethod, &l:foldexpr] = b:foldinfo
    \|  endif

" http://leafcage.hateblo.jp/entry/2013/04/24/053113
" 現在のカーソルの位置以外の折りたたみを閉じる
nnoremap z- zMzv
nnoremap <expr>l  foldclosed('.') != -1 ? 'zo' : 'l'

if dein#tap('foldCC')
    set foldtext=FoldCCtext()
    set foldcolumn=1
    set fillchars=vert:\|
    let g:foldCCtext_head = '"+ " . v:folddashes . " "'
    " let g:foldCCtext_head = 'repeat(" ", v:foldlevel) . "+ "'
    let g:foldCCtext_tail = 'printf("[Lv%d %3d]", v:foldlevel, v:foldend-v:foldstart+1)'
    nnoremap <Leader><C-g> :echo FoldCCnavi()<CR>
endif

" Kwbd.vim {{{1
" ==============================================================================
if dein#tap('Kwbd.vim')
    nmap <Leader>bd <Plug>Kwbd
endif

" savevers.vim {{{1
" ============================================================================
set backup
set patchmode=.bak
set backupdir=$VIM_CACHE_DIR/savevers
execute 'set backupskip+=*'.&patchmode
execute 'set suffixes+='.&patchmode

let g:versdiff_no_resize = 0

autocmd MyVimrc BufEnter * call s:updateSaveversDirs()
function! s:updateSaveversDirs()
    " ドライブ名を変更して、連結する (e.g. C: -> /C/)
    let g:savevers_dirs = &backupdir . substitute(expand('%:p:h'), '\v\c^([a-z]):', '/\1/' , '')
endfunction

function! s:existOrMakeSaveversDirs()
    if !isdirectory(g:savevers_dirs)
        call mkdir(g:savevers_dirs, 'p')
    endif
endfunction

" autocmd MyVimrc BufWritePre * call s:updateSaveversDirs() | call s:existOrMakeSaveversDirs()
autocmd MyVimrc BufWritePre * call s:existOrMakeSaveversDirs()

" PreserveNoEOL {{{1
" ============================================================================
let g:PreserveNoEOL = 1

" detectindent {{{1
" ============================================================================
if dein#tap('detectindent')
    " let g:detectindent_verbosity = 0
    autocmd MyVimrc FileType yml
    \   let g:detectindent_preferred_indent = &shiftwidth
    \|  if &expandtab == 0
    \|      unlet! g:detectindent_preferred_expandtab
    \|  else
    \|      let g:detectindent_preferred_expandtab = 1
    \|  endif
    \|  DetectIndent
endif

" scrooloose/syntastic {{{1
" ============================================================================
if dein#tap('syntastic')
    autocmd MyVimrc BufWrite * NeoBundleSource syntastic
    let g:syntastic_mode_map = {
        \   'mode': 'active',
        \   'passive_filetypes': ['vim']
        \}
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_sh_checkers = ['']
endif


" phpcomplete.vim {{{1
" ============================================================================
let g:phpcomplete_enhance_jump_to_definition = 1
" let g:phpcomplete_mappings = {
"    \ 'jump_to_def': '<C-]>',
"    \ 'jump_to_def_split': '<C-W><C-]>',
"    \ 'jump_to_def_vsplit': '<C-W><C-\>',
"    \}

" stephpy/vim-php-cs-fixer {{{1
" ============================================================================
nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
let g:php_cs_fixer_dry_run = 1
let g:php_cs_fixer_verbose = 1
let g:php_cs_fixer_level = 'all'
" let g:php_cs_fixer_path = '~/sample/vendor/bin/php-cs-fixer'

" joonty/vdebug {{{1
" ============================================================================
let g:vdebug_options = {
\   'port' : 9000,
\   'server' : '',
\   'timeout' : 20,
\   'on_close' : 'detach',
\   'break_on_open' : 1,
\   'ide_key': $USER,
\   'path_maps' : {},
\   'debug_window_level' : 0,
\   'debug_file_level' : 0,
\   'debug_file' : '',
\   'watch_window_style' : 'expanded',
\   'marker_default' : '⬦',
\   'marker_closed_tree' : '▸',
\   'marker_open_tree' : '▾'
\}

autocmd MyVimrc BufWinEnter DebuggerBreakpoints
\   nnoremap <buffer> dd ^:BreakpointRemove <C-r><C-w><CR>

" vim-json {{{1
" ============================================================================
let g:vim_json_syntax_conceal = 0

" Python, jedi-vim {{{1
" ============================================================================
" pythonのsys.pathの設定 " {{{2
" ----------------------------------------------------------------------------
" [VimのPythonインターフェースのパスの問題を解消する - Qiita](http://qiita.com/tmsanrinsha/items/cfa3808b8d0cc915cd75)
" python2は$PYTHON_DLLを設定しなくてもうまくいく
" /usr/local/Frameworks/Python.framework/Python -> ../../Cellar/python/2.7.10_2/Frameworks/Python.framework/Python
" とりあえずこう設定しておく
let $PYTHON_DLL = '/usr/local/Frameworks/Python.framework/Python'
" if filereadable('/usr/local/Cellar/python/2.7.10_2/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib')
"     let $PYTHON_DLL = '/usr/local/Cellar/python/2.7.10_2/Frameworks/Python.framework/Versions/2.7/lib/libpython2.7.dylib'
" elseif filereadable('/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/Python')
"     let $PYTHON_DLL = '/usr/local/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/Python'
" elseif filereadable('/usr/local/Frameworks/Python.framework/Python')
"     let $PYTHON_DLL = '/usr/local/Frameworks/Python.framework/Python'
" endif

if filereadable('/usr/local/Frameworks/Python.framework/Versions/3.5/Python')
    let $PYTHON3_DLL = '/usr/local/Frameworks/Python.framework/Versions/3.5/Python'
endif

function! Set_python_path()
    if ! exists('g:python_path')
        let g:python_path = system('python -', 'import sys;sys.stdout.write(",".join(sys.path))')
    endif

    python <<EOT
import sys
import vim

python_paths = vim.eval('g:python_path').split(',')
for path in python_paths:
    if not path in sys.path:
        sys.path.insert(0, path)
EOT
endfunction
" call Set_python_path()
" }}}

autocmd MyVimrc FileType python
\   if ! exists('g:python_path')
\|      let g:python_path = system('python -', 'import sys;sys.stdout.write(",".join(sys.path))')
\|  endif
\|  let &l:path = g:python_path

autocmd MyVimrc Filetype c,cpp
\|  execute 'setlocal path+='.s:getCPath()
\|  setlocal suffixesadd=.h

if dein#tap('vim-cpp-auto-include')
    autocmd MyVimrc BufWritePre *.cpp :ruby CppAutoInclude::process
endif

" R lang, jcfaria/Vim-R-plugin {{{1
" ============================================================================
" _で->などのマッピングをしない
let vimrplugin_assign = 0

autocmd MyVimrc FileType r
\   nmap <buffer> <Leader>r<CR> <Plug>RSendFile
\ | nmap <buffer> <LocalLeader>re <Plug>RESendFile
\ | nmap <buffer> <LocalLeader>ss <Plug>RSendLine
\ |  vmap <buffer> <LocalLeader>ss <Plug>RESendSelection<Esc>
\ |  imap <M-CR> <Esc><Plug>RSendLineo


" result <- fun(
"               par1 = "abc",
"               par2 = "def",
"               par3 = 3
"               )
" を
" result <- fun(
"     par1 = "abc",
"     par2 = "def",
"     par3 = 3
"     )
" にする。最後の括弧がにならない
" let r_indent_align_args = 0


" autowitch/hive.vim {{{1
" ============================================================================
autocmd MyVimrc BufNewFile,BufRead *.hql,*.q
\   let b:sql_type_overrride = 'hive'
\|  setlocal filetype=sql

" Markdown {{{1
" ============================================================================
" デフォルトで入っているプラグインでfenced code blocksのコードをハイライト {{{2
" let g:markdown_fenced_languages = [
" \  'css',
" \  'javascript',
" \  'js=javascript',
" \  'json=javascript',
" \  'php',
" \  'sql',
" \  'xml',
" \]

" vim-markdown {{{2
" ----------------------------------------------------------------------------
if dein#tap('vim-markdown')
    let g:vim_markdown_folding_disabled = 0
    " macでgxを使いたい場合
    let g:netrw_browsex_viewer= 'open'
    let g:vim_markdown_no_default_key_mappings = 0
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_conceal = 1

    " plasticboy/vim-markdownでfiletypeをmkd.markdownにする {{{3
    " [Use "markdown" filetype instead of "mkd" (or both)?! · Issue #64 · plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown/issues/64)
    " function! MyAddToFileType(ft)
    "   if index(split(&ft, '\.'), a:ft) == -1
    "     let &ft .= '.'.a:ft
    "   endif
    " endfun
    " au FileType markdown call MyAddToFileType('mkd')
    " au FileType mkd      call MyAddToFileType('markdown')
endif

" joker1007/vim-markdown-quote-syntax {{{2
" ----------------------------------------------------------------------------
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

" nelstrom/vim-markdown-folding {{{2
" ----------------------------------------------------------------------------
" if dein#tap('vim-markdown-folding')
"     let g:markdown_fold_style = 'nested'
" endif

" vimconsole.vim {{{1
" ==============================================================================
if dein#tap('vimconsole.vim')
    let g:vimconsole#auto_redraw = 1
    augroup MyVimrc
        autocmd FileType vim,vimconsole
                    \    nnoremap <buffer> <F12> :VimConsoleToggle<CR>
                    \ |  nnoremap <buffer> <C-l> :VimConsoleClear<CR>
    augroup END
    let g:vimconsole#maximum_caching_objects_count = 100
endif

" instant-markdown-vim {{{1
" ============================================================================
" let g:instant_markdown_slow = 1
" let g:instant_markdown_autostart = 0
" autocmd MyVimrc FileType markdown nnoremap <buffer> <Leader>r :InstantMarkdownPreview<CR>


" Git {{{1
" ============================================================================
" vim-fugitive {{{2
" ----------------------------------------------------------------------------
if dein#tap('vim-fugitive')

    nnoremap [fugitive] <Nop>
    nmap <Leader>g [fugitive]
    nnoremap [fugitive]a   :Gwrite<CR>
    nnoremap [fugitive]ci  :Gcommit<CR>
    nnoremap [fugitive]co  :Git checkout %<CR>
    nnoremap [fugitive]d   :Gdiff<CR>
    nnoremap [fugitive]s   :Gstatus<CR>
    nnoremap [fugitive]l   :Glog<CR>
    nnoremap [fugitive]ps  :Git push
    nnoremap [fugitive]psf :Git push -f
    nnoremap [fugitive]pso :Git push origin
    nnoremap [fugitive]pl  :Git pull --rebase
    nnoremap [fugitive]fo  :Git fetch origin<CR>
    nnoremap [fugitive]for :Git fetch origin<CR>:Git rebase origin/master<CR>

    nnoremap [fugitive]2 :diffget //2 <Bar> diffupdate\<CR>
    nnoremap [fugitive]3 :diffget //3 <Bar> diffupdate\<CR>

    " Gbrowse ではgit config --global web.browserの値は見てない
    " ~/.vim/bundle/vim-fugitive/plugin/fugitive.vim
    if !has('gui_running') && $SSH_CLIENT !=# ''
        let g:netrw_browsex_viewer = 'rfbrowser'
    endif

    " gitcommitでカーソル行のファイルをrmする
    function! s:gitcommit_rm()
        if executable('rmtrash')
            let s:my_rm_commant = 'rmtrash'
        else
            let s:my_rm_commant = 'rm -r'
        endif
        " nnoremapだと<C-r><C-g>とrのremapができないのでnmap
        " nmapだと:が;になってしまうので[Colon]を使う
        execute   "nmap <buffer> <LocalLeader>r [Colon]call system('" . s:my_rm_commant . " \"' . expand('%:h:h') . '/<C-r><C-g>\"')<CR>r"
    endfunction

    autocmd MyVimrc FileType gitcommit
    \   call s:gitcommit_rm()
    \|  nmap <buffer> <LocalLeader>co [Colon]Git checkout <C-r><C-g><CR>

    " vimfiler上でfugitiveのコマンドを使う
    autocmd MyVimrc FileType vimfiler
    \   autocmd CursorMoved <buffer> let b:git_dir = '' | call fugitive#detect(vimfiler#get_filename())

endif


" open-browser.vim {{{1
" ============================================================================
if dein#tap('open-browser.vim')
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)
    nmap <C-LeftMouse> <Plug>(openbrowser-smart-search)
    vmap <C-LeftMouse> <Plug>(openbrowser-smart-search)

    autocmd MyVimrc FileType mql4,php
    \   nnoremap <buffer> K :<C-u>MyOpenbrowserSearch n<CR>
    \|  xnoremap <buffer> K :<C-u>MyOpenbrowserSearch v<CR>

    function! s:my_openbrowser_search(mode)
        if a:mode ==# 'n'
            let search_text = expand('<cword>')
        elseif a:mode ==# 'v'
            let V = vital#of('vital')
            let Buffer = V.import('Vim.Buffer')
            let search_text = Buffer.get_last_selected()
        endif

        call openbrowser#search(search_text, &filetype)
    endfunction
    command! -nargs=1 MyOpenbrowserSearch call s:my_openbrowser_search('<args>')
endif

if IsInstalled('keysender.vim') && IsInstalled('vim2browser')
    inoremap <C-s> <Esc>:<C-u>Vim2ChromeAppendAll<CR>:KeysenderKeyCode 52<CR>
    nnoremap <C-s> <Esc>:<C-u>Vim2ChromeAppendAll<CR>:KeysenderKeyCode 52<CR>
endif

" lightline, statusline {{{1
" ============================================================================
    " \       'paste': '%{&paste?"PASTE":""}',
    " \       'readonly': '%2*%{&filetype=="help"?"":&readonly?"RO":""}%*',
    " \       'paste': '%{&paste?"PASTE":""}%R%H%W%q',

let g:lightline = {
\   'colorscheme': 'my_powerline',
\   'active': {
\       'left': [
\           ['mode'],
\           ['flag_red'],
\           ['flag', 'filename', 'fugitive', 'currenttag', 'anzu']
\       ],
\       'right': [
\           ['syntaxcheck', 'column', 'lineinfo'],
\           ['percent'],
\           ['fileformat', 'fileencoding', 'filetype']
\       ]
\   },
\   'inactive': {
\       'left': [
\           ['flag', 'filename', 'fugitive', 'currenttag', 'anzu']
\       ],
\       'right': [
\           ['column', 'lineinfo'],
\           ['percent'],
\           ['fileformat', 'fileencoding', 'filetype']
\       ]
\   },
\   'component': {
\       'flag_red': '%{&paste?"PASTE":""}%R%W%<',
\       'flag': '%H%q',
\       'lineinfo': '%3l:%-2v',
\   },
\   'component_visible_condition': {
\       'flag': '(&filetype == "help" || &filetype == "qf")',
\   },
\   'component_expand': {
\       'syntaxcheck': 'qfstatusline#Update',
\   },
\   'component_type': {
\       'syntaxcheck': 'error',
\   },
\}

let g:lightline['component_function'] = {
\   'mode': 'lightline#mode',
\   'fugitive': 'MyFugitive',
\   'filename': 'MyFilename',
\   'fileformat': 'MyFileformat',
\   'filetype': 'MyFiletype',
\   'fileencoding': 'MyFileencoding',
\   'anzu': 'anzu#search_status',
\   'currenttag': 'MyCurrentTag',
\   'column': 'GetCurrentColumn',
\}

let g:lightline['separator'] = { 'left': '', 'right': '' }
let g:lightline['subseparator'] = { 'left': '|', 'right': '|' }
let g:lightline['mode_map']  = {
\   'n' : 'N',
\   'i' : 'I',
\   'R' : 'R',
\   'v' : 'V',
\   'V' : 'VL',
\   'c' : 'C',
\   "\<C-v>": 'VB',
\   's' : 'S',
\   'S' : 'SL',
\   "\<C-s>": 'SB',
\   '?': ''
\}

" [vim-qfstatusline を作ってみた - mabulog](http://kazuomabuo.hatenablog.jp/entry/2014/06/11/211947) {{{
" :WatchdogsRun後にlightline.vimを更新
" \       'right': [
" \           ['syntaxcheck', 'lineinfo'],
" \   'component_expand': {
" \       'syntaxcheck': 'qfstatusline#Update',
" \   },
" \   'component_type': {
" \       'syntaxcheck': 'error',
" \   },

let g:Qfstatusline#UpdateCmd = function('lightline#update')
" }}}

" 途中で色変更をするとInsert modeがおかしくなる
" autocmd MyVimrc ColorScheme *
"     \   hi User1 ctermfg=red guifg=red

function! MyModified()
  return &filetype =~# 'help\|qf\|gitcommit\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &filetype !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
    return (
    \   &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
    \   &filetype ==# 'unite' ? unite#get_status_string() :
    \   &filetype ==# 'vimshell' ? vimshell#get_status_string() :
    \   &filetype ==# 'help' ? expand('%:t') :
    \   &filetype ==# 'qf' ? '' :
    \   &filetype ==# 'gitcommit' ? '' :
    \   '' !=# expand('%:~:.') ? expand('%:~:.') : '[No Name]'
    \) .
    \('' !=# MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &filetype !~? 'gundo' && exists('*fugitive#head') && strlen(fugitive#head())
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 50 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 50 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 50 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction

function! MyCurrentTag()
  " return tagbar#currenttag('%s', '')
  return ''
endfunction

" [vimでCSVの特定カラムでハイライトを行う - Qiita](http://qiita.com/rita_cano_bika/items/e447c042e70327014609)
" を参考にした
function! GetCurrentColumn()
    if &filetype ==# 'tsv'
        return 'c'.(strlen(substitute(getline('.')[0:col('.')-1], '[^\t]', '', 'g')) + 1)
    elseif &filetype ==# 'csv'
        return 'c'.(strlen(substitute(getline('.')[0:col('.')-1], '[^,]', '', 'g')) + 1)
    else
        return ''
    endif
endfunction
" call lightline#update()

" vim-quickhl {{{1
" ============================================================================
nmap [:space:]m <Plug>(quickhl-manual-this)
xmap [:space:]m <Plug>(quickhl-manual-this)
nmap [:space:]M <Plug>(quickhl-manual-reset)
xmap [:space:]M <Plug>(quickhl-manual-reset)

" vim-scripts/AnsiEsc.vim {{{1
" ============================================================================
autocmd MyVimrc FileType quickrun AnsiEsc
" autocmd MyVimrc FileType qf call s:call_ansi_esc()
" function! s:call_ansi_esc() abort
"     AnsiEsc
"     runtime syntax/qf.vim
" endfunction

" rainbow {{{1
" ============================================================================
if dein#tap('rainbow')
    let g:rainbow_active = 1
    let g:rainbow_conf = {
    \    'guifgs':   ['#FA248F', '#FA8F24', '#8FFA24', '#24FA8F', '#248FFA', '#8F24FA', '#FA2424', '#FAFA24', '#24FA24', '#24FAFA', '#2424FA', '#FA24FA'],
    \    'ctermfgs': ['198',     '208',     '118',     '48',      '33',      '93',      '9',       '11',      '10',      '14',      '21',      '13'],
    \    'operators': '_,_',
    \    'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
    \    'separately': {
    \        '*': {},
    \        'lisp': {
    \            'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \            'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
    \        },
    \        'html': {
    \            'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
    \        },
    \        'xml': {
    \            'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
    \        },
    \        'vim': {
    \            'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
    \        },
    \    }
    \}
endif

" junkfile.vim {{{1
" ============================================================================
if dein#tap('junkfile.vim')
    let g:junkfile#directory = $VIM_CACHE_DIR.'/junkfile'
    let g:junkfile#edit_command = 'new'

    command! -nargs=0 JunkfileFiletype call junkfile#open_immediately(
    \ strftime('%Y-%m-%d-%H%M%S.') . &filetype)

    nnoremap [:junk] <Nop>
    nmap <Leader>j [:junk]

    nnoremap [:junk]o :JunkfileOpen<CR>
    nnoremap [:junk]f :JunkfileFiletype<CR>
    nnoremap [unite]fj :Unite junkfile<CR>
endif

finish " backup {{{1
" eclim {{{2
if dein#tap('eclim')

    " エラーのマークがずれる場合はエンコーディングが間違っている
    " http://eclim.org/faq.html#code-validation-signs-are-showing-up-on-the-wrong-lines

    autocmd MyVimrc FileType java
    \   setlocal omnifunc=eclim#java#complete#CodeComplete
    \|  setlocal completeopt-=preview
    \|  nnoremap <buffer> <C-]> :<C-u>JavaSearch<CR>
    " neocomplcacheで補完するため
    let g:EclimCompletionMethod = 'omnifunc'

    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.java =
    \ '\%(\h\w*\|)\)\.\w*'

    nnoremap [eclim] <Nop>
    nmap <Leader>e [eclim]
    nnoremap [eclim]pi :ProjectInfo<CR>
    nnoremap [eclim]pp :ProjectProblems!<CR>
    nnoremap [eclim]c :OpenUrl http://eclim.org/cheatsheet.html<CR>
    nnoremap [eclim]jc :JavaCorrect<CR>
    nnoremap [eclim]ji :JavaImportOrganize<CR>
endif
" vimwiki {{{2
if dein#tap('vimwiki')

    nmap <Leader>ww  <Plug>VimwikiIndex
    nmap <Leader>w<Leader>d  <Plug>VimwikiDiaryIndex
    nmap <Leader>wn  <Plug>VimwikiMakeDiaryNote
    nmap <Leader>wu  <Plug>VimwikiDiaryGenerateLinks

    let g:vimwiki_list = [{
    \   'path': '~/Dropbox/vimwiki/wiki/', 'path_html': '~/Dropbox/vimwiki/public_html/',
    \   'syntax': 'markdown', 'ext': '.txt'
    \}]
endif

" qfixhowm {{{2
if dein#tap('qfixhowm')
    " QFixHowm互換を切る
    let g:QFixHowm_Convert = 0
    let g:qfixmemo_mapleader = '\M'
    " デフォルトの保存先
    let g:qfixmemo_dir = $HOME . '/Dropbox/memo'
    let g:qfixmemo_filename = '%Y/%m/%Y-%m-%d'
    " メモファイルの拡張子
    let g:qfixmemo_ext = 'md'
    " ファイルタイプをmarkdownにする
    let g:qfixmemo_filetype = 'md'
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
endif
