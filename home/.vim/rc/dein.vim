scriptencoding utf-8

let s:dein_dir = expand('$VIM_CACHE_DIR/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければgit clone
if !isdirectory(s:dein_repo_dir)
    echo 'git clone https://github.com/Shougo/dein.vim '.s:dein_repo_dir
    call system('git clone https://github.com/Shougo/dein.vim '.s:dein_repo_dir)
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    let s:toml_files = split(glob('$VIMRC_DIR/*.toml'), "\n")
    for s:toml_file in s:toml_files
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
  call dein#install()
endif

function! s:dein_on_source(plugin) abort
    execute 'autocmd MyVimrc User dein#source#'.g:dein#name
    \   'call s:'.a:plugin.'_on_source()'
endfunction

function! s:add_on_source(dein_name, func) abort
    execute 'autocmd MyVimrc User dein#source#'.a:dein_name
    \   'call '.a:func.'()'
endfunction

if !exists('g:memo_directory')
    let g:memo_directory = expand('~/Dropbox/memo/doc')
endif

" vim-singleton {{{1
" ============================================================================
if dein#tap('vim-singleton') && has('gui_running')
    call singleton#enable()
endif

" colorscheme {{{1
" ============================================================================
if dein#tap('my_molokai')
    colorscheme molokai-customized
    syntax enable
endif

" sudo.vim {{{1
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if dein#tap('sudo.vim')
    if dein#tap('bclose')
        nmap <Leader>E :e sudo:%<CR><C-^><Plug>Kwbd
    else
        nnoremap <Leader>E :e sudo:%<CR><C-^>:bd<CR>
    endif
    nnoremap <Leader>W :w sudo:%<CR>
endif

" vim-smartword {{{1
" ==============================================================================
if dein#tap('vim-smartword')
    map w <Plug>(smartword-w)
    map b <Plug>(smartword-b)
    map e <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)
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
    nmap <silent> [unite]q [Colon]<C-u>call GotoWin('\[unite\]')<CR><Plug>(unite_all_exit)
    nnoremap <silent> <C-w>, :<C-u>call GotoWin('\[unite\]')<CR>
    nnoremap [unite], :<C-u>Unite -toggle<CR>

    " バッファ
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>

    " ファイル内検索結果
    nnoremap <silent> [unite]l :<C-u>Unite line<CR>

    " Unite output {{{2
    " ------------------------------------------------------------------------
    " Unite output:map {{{3
    " unite-mappingではnormalのマッピングしか出ないので、すべてのマッピングを出力するようにする
    " http://d.hatena.ne.jp/osyo-manga/20130307/1362621589
    nnoremap <silent> [unite]m :<C-u>Unite output:map<Bar>map!<Bar>lmap -default-action=verbose<CR>

    " verbose mapするアクションの定義
    " [unite.vim の action について理解する - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20131004/1380890539)
    let s:action_verbose_map = {
    \   'description' : 'verbose',
    \   'is_selectable' : 1,
    \}

    function! s:action_verbose_map.func(candidates)
        for candidate in a:candidates
            execute 'verbose map' matchstr(candidate.unite__abbr, '^\S\+\s\+\zs\S\+\ze')
        endfor
    endfunction

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
    nnoremap [unite]Om :<C-u>Unite output:messages -log -buffer-name=messages -no-start-insert<CR>

    " Unite outputでruntimpathを出力する {{{3
    nnoremap [unite]Or :<C-u>Unite output:echo\ join(split(&runtimepath,','),\"\\n\")<CR>

    " Unite.vim directory {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリ以下のディレクトリ
    nnoremap [unite]dc :<C-u>Unite directory<CR>
    " カレントバッファのディレクトリ以下
    nnoremap [unite]d. :<C-u>execute "Unite directory:".expand('%:p:h')<CR>
    nnoremap [unite]dd :<C-u>Unite directory:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    nnoremap [unite]dv :<C-u>Unite directory:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]dV :<C-u>Unite directory:$VIM<CR>
    nnoremap [unite]db :<C-u>Unite directory:$HOME/.vim/bundle<CR>
    nnoremap [unite]da :<C-u>Unite directory:/Applications directory:$HOME/Applications<CR>

    " Unite file(_rec) {{{2
    " ------------------------------------------------------------------------
    " プロジェクトディレクトリ以下のファイル
    " こちらのコマンドだと、カレントディレクトリがあるプロジェクトディレクトリ以下
    " nnoremap [unite]fp :<C-u>Unite file_rec:!<CR>
    " こちらのコマンドだと、カレントバッファのファイルがあるプロジェクトディレクトリ以下
    nnoremap [unite]fp :<C-u>call <SID>unite_file_project('-start-insert')<CR>
    function! s:unite_file_project(...)
        let l:opts = (a:0 ? join(a:000, ' ') : '')
        let l:project_dir = GetProjectDir()

        if isdirectory(l:project_dir.'/.git')
            execute 'lcd '.l:project_dir
            execute 'Unite '.opts.' file_rec/git:--cached:--others:--exclude-standard'
        else
            execute 'Unite '.opts.' file_rec/async:'.l:project_dir
        endif
    endfunction

    nnoremap [unite]f. :<C-u>execute "Unite file_rec/async:".expand('%:p:h')<CR>
    nnoremap [unite]fv :<C-u>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]fd :<C-u>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>

    " unite grep {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリに対してgrep
    nnoremap [unite]gc :<C-u>Unite grep:.<CR>
    " カレントバッファのディレクトリ以下に対してgrep
    nnoremap [unite]g. :<C-u>execute "Unite grep:".expand('%:p:h')<CR>
    " 全バッファに対してgrep
    nnoremap [unite]gB :<C-u>Unite grep:$buffers<CR>
    " プロジェクト内のファイルに対してgrep
    nnoremap [unite]gp :<C-u>call <SID>unite_grep_project('-start-insert')<CR>
    function! s:unite_grep_project(...)
        let opts = (a:0 ? join(a:000, ' ') : '')
        let l:project_dir = GetProjectDir()
        if !executable('ag') && isdirectory(l:project_dir.'/.git')
            execute 'Unite '.opts.' grep/git:/:--untracked'
        else
            execute 'Unite '.opts.' grep:'.l:project_dir
        endif
    endfunction

    nnoremap [unite]gd :<C-u>Unite grep:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    nnoremap [unite]gv :<C-u>Unite grep:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]gV :<C-u>Unite grep:$VIM<CR>
    nnoremap [unite]gb :<C-u>Unite grep:$HOME/.vim/bundle<CR>
    "}}}

    "レジスタ一覧
    nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
    " ヤンク履歴
    let g:unite_source_history_yank_enable = 1  "history/yankの有効化
    nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
    " ブックマーク
    nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>

    nnoremap <silent> [unite]j :<C-u>Unite jump<CR>

    " unite memo {{{2
    " ------------------------------------------------------------------------
    nnoremap [unite]fM :<C-u>Unite memo<CR>

    " [unite-filters の converter を活用しよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20130919/1379602932)
    let g:unite_source_alias_aliases = {
    \   'memo' : {
    \       'source' : 'file_rec/async',
    \       'args' : g:memo_directory,
    \   },
    \}
    execute 'nnoremap [unite]gM :<C-u>Unite grep:'.g:memo_directory.'<CR>'

    " unite-grep {{{2
    " ------------------------------------------------------------------------
    " :h unite-source-grep
    " grepの結果のファイル名を短くするのはこの辺を見ればできるかも
    " :h unite#custom#profile()
    " [:Unite file でどこにいるのかわからなくなる問題を解決する - basyura's blog](http://blog.basyura.org/entry/2013/05/08/210536)
    if executable('ag')
        " Use ag in unite grep source.
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts =
        \ '-f --vimgrep --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
        let g:unite_source_grep_recursive_opt = ''
    elseif executable('pt')
        " ptは複数PATH指定ができない。
        " ptの文字コードチェックは512byteまで。
        let g:unite_source_grep_command = 'pt'
        let g:unite_source_grep_default_opts = '-e -S --nogroup --nocolor'
        let g:unite_source_grep_recursive_opt = ''
        let g:unite_source_grep_encoding = 'utf-8'
    elseif executable('grep')
        let g:unite_source_grep_command = 'grep'
        let g:unite_source_grep_default_opts = '-inHE'
        let g:unite_source_grep_recursive_opt = '-r'
    elseif executable('jvgrep')
        " jvgrepは遅い
        let g:unite_source_grep_command = 'jvgrep'
        let g:unite_source_grep_default_opts = '--color=never -i'
        let g:unite_source_grep_recursive_opt = '-R'
    endif

    let g:unite_source_grep_max_candidates = 1000
    " Set "-no-quit" automatically in grep unite source.


    " unite-args {{{2
    " ------------------------------------------------------------------------
    function! s:set_arglist(candidates)
        let argslist = {}
        for candidate in a:candidates
            " h unite-kind-file
            let argslist[candidate.action__path] = 1
        endfor
        execute 'argadd' join(map(keys(argslist), 'fnameescape(v:val)'))
    endfunction

    " arglistにuniteで選択したファイルを設定する
    let s:args_action = {'description': 'args', 'is_selectable': 1}

    function! s:args_action.func(candidates)
        silent! argdelete *
        call s:set_arglist(a:candidates)
    endfunction

    " arglistにuniteで選択したファイルを追加する
    let s:argadd_action = {'description': 'argadd', 'is_selectable': 1}

    function! s:argadd_action.func(candidates)
        call s:set_arglist(a:candidates)
    endfunction

    function! s:unite_on_source() abort
        call unite#custom#action('source/output/*', 'verbose', s:action_verbose_map)
        call unite#custom#profile('default', 'context', {
        \   'start_insert': 1,
        \   'direction': 'topleft',
        \   'winheight': 10,
        \   'auto_resize': 1,
        \   'prompt': '> ',
        \ })
        call unite#custom_default_action('directory' , 'vimfiler')
        " vimfiler上ではvimfilerを増やさず、移動するだけ
        " autocmd MyVimrc FileType vimfiler
        " \   call unite#custom_default_action('directory', 'lcd')

        call unite#custom_default_action('source/directory/directory' , 'vimfiler')
        call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')

        " dでファイルの削除
        call unite#custom#alias('file', 'delete', 'vimfiler__delete')
        call unite#custom#alias('directory', 'delete', 'vimfiler__delete')

        call unite#custom#source('memo', 'sorters', ['sorter_ftime', 'sorter_reverse'])

        call unite#custom#profile('source/grep', 'context',
        \ {'no_quit' : 1})

        call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

        call unite#custom#action('file', 'argadd', s:argadd_action)
        call unite#custom#action('file', 'args', s:args_action)
    endfunction

    call s:dein_on_source('unite')

    nnoremap [unite]D :<C-u>Unite dein<CR>
endif

" neomru {{{1
" ============================================================================
if dein#tap('neomru.vim')
    "最近使用したファイル一覧
    nnoremap <silent> [unite]fm :<C-u>Unite neomru/file<CR>
    "最近使用したディレクトリ一覧
    nnoremap <silent> [unite]dm :<C-u>Unite neomru/directory<CR>

    " ファイルが存在するかチェックしない
    " ファイルへの書き込みを60秒ごとにする
    let g:neomru#update_interval = 60
    let g:neomru#do_validate = 0

    function! s:neomru_on_source() abort
        call unite#custom#source(
        \'neomru/file', 'ignoer_pattern',
        \'\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
        \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
        \'\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
        \'\|\%(^\%(fugitive\)://\)'.
        \'\|/mnt/'
        \)
    endfunction

    call s:add_on_source('unite.vim', 's:neomru_on_source')
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
    nnoremap [unite]o<CR> :<C-u>Unite outline<CR>
    nnoremap [unite]of :<C-u>Unite outline:folding<CR>
    nnoremap [unite]oo :<C-u>Unite -vertical -winwidth=40 -no-auto-resize -no-quit outline<CR>

    function! s:unite_outline_on_source() abort
        call unite#sources#outline#alias('ref-man', 'man')
        call unite#sources#outline#alias('rmd', 'markdown')
        call unite#sources#outline#alias('tmux', 'conf')
        call unite#sources#outline#alias('vimperator', 'conf')
        call unite#sources#outline#alias('zsh', 'conf')
    endfunction

    call s:add_on_source('unite.vim', 's:unite_outline_on_source')
endif

autocmd MyVimrc FileType yaml
\   nnoremap <buffer> [unite]o :<C-u>Unite outline:folding<CR>

" tacroe/unite-mark {{{1
" =========================================================================
nnoremap [unite]` :<C-u>Unite mark<CR>

" neoyank.vim {{{1
" =========================================================================
if dein#tap('neoyank.vim')
    nnoremap [unite]hy :<C-u>Unite history/yank<CR>
    let g:neoyank#file = $VIM_CACHE_DIR.'/yankring.txt'
endif

" vim-unite-history {{{1
" =========================================================================
if dein#tap('vim-unite-history')
    nnoremap [unite]hc :<C-u>Unite history/command<CR>
    nnoremap [unite]hs :<C-u>Unite history/search<CR>
    cnoremap <M-r> :<C-u>Unite history/command -start-insert -default-action=edit<CR>
    inoremap <C-x>,hc <C-o>:Unite history/command -start-insert -default-action=insert<CR>
endif

" unite-ghq {{{1
" ============================================================================
if dein#tap('unite-ghq')
    nnoremap [unite]dg :<C-u>Unite ghq<CR>

    function! s:unite_ghq_on_source() abort
        call unite#custom_default_action('source/ghq/directory', 'vimfiler')
    endfunction

    call s:add_on_source('unite.vim', 's:unite_ghq_on_source')
endif

" cdr {{{1
" ============================================================================
if dein#tap('vital.vim')
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

" unite-zsh-cdr.vim {{{2
" ----------------------------------------------------------------------------
if dein#tap('unite-zsh-cdr.vim')
    nnoremap [unite]dr :<C-u>Unite zsh-cdr<CR>

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

        autocmd MyVimrc FileType int-*
            \   inoremap <buffer> <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-x>\<C-l>"
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

    function! s:conque_on_source() abort
        " 違うバッファに移ってもバッファを更新し続ける。
        " ただし、スクロールはできない
        let g:ConqueTerm_ReadUnfocused = 1
        " プログラムが終了したらバッファを閉じる
        let g:ConqueTerm_CloseOnEnd = 1
        " 設定がまずい場合は立ち上げ時にwarningを出す
        let g:ConqueTerm_StartMessages = 1
        " <C-w>をウィンドウを変更するために使わない(ConqueTerm上で<C-w>を使う)
        let g:ConqueTerm_CWInsert = 0
        " 通常の<Esc>はconqueTermにEscapeを送って、<C-j>はVimにEscapeを送る
        let g:ConqueTerm_EscKey = '<C-j>'

        " [もぷろぐ: Vim から zsh を呼ぶ ﾌﾟﾗｷﾞﾝ 紹介](http://ac-mopp.blogspot.jp/2013/02/vim-zsh.html)
        " bufferが消えた時プロセスを終了する。なくてもいい気がする
        " function! s:delete_ConqueTerm(buffer_name)
        "     let term_obj = conque_term#get_instance(a:buffer_name)
        "     call term_obj.close()
        " endfunction
        " autocmd! my_conque BufWinLeave zsh\s-\s? call <SID>delete_ConqueTerm(expand('%'))
    endfunction

    execute 'autocmd MyVimrc User' 'dein#source#'.g:dein#name
    \   'call s:conque_on_source()'
endif

" neocomplete {{{1
" ============================================================================
if dein#tap('neocomplete.vim')
    function! s:neocomplete_on_source() abort
        " Use neocomplcache.
        let g:neocomplete#enable_at_startup = 1
        " Use smartcase.
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_ignore_case = 1

        " smartcaseな補完にする
        let g:neocomplete#enable_camel_case = 0

        " Set minimum syntax keyword length.
        let g:neocomplete#sources#syntax#min_syntax_length = 3

        " for keyword
        let g:neocomplete#auto_completion_start_length = 2

        set pumheight=10
        " 補完候補取得に時間がかかったときにスキップ
        let g:neocomplete#skip_auto_completion_time = "0.1"
        " let g:neocomplete#skip_auto_completion_time = '1'
        " 候補の数を増やす
        " execute 'let g:'.s:neocom_.'max_list = 3000'

        " execute 'let g:'.s:neocom_.'force_overwrite_completefunc = 1'

        " if !exists('g:neocomplete#same_filetypes')
        "   let g:neocomplete#same_filetypes = {}
        " endif
        " " In default, completes from all buffers.
        " let g:neocomplete#same_filetypes._ = '_'

        let g:neocomplete#enable_auto_close_preview=0
        " fugitiveのバッファも閉じてしまうのでコメントアウト
        " autocmd MyVimrc InsertLeave *.* pclose

        " let g:neocomplete#sources#tags#cache_limit_size = 1000000
        " 使用する補完の種類を減らす
        " http://alpaca-tc.github.io/blog/vim/neocomplete-vs-youcompleteme.html
        " 現在のSourceの取得は 
        " `:echo keys(neocomplete#variables#get_sources())`
        " デフォルト: ['file', 'tag', 'neosnippet', 'vim', 'dictionary',
        " 'omni', 'member', 'syntax', 'include', 'buffer', 'file/include']

        if !exists('g:neocomplete#sources')
          let g:neocomplete#sources = {}
        endif
        " let g:neocomplete#sources._    = ['tag', 'syntax', 'neosnippet', 'ultisnips', 'dictionary', 'omni', 'member', 'buffer', 'file', 'file/include']
        let g:neocomplete#sources._    = ['tag', 'syntax', 'neosnippet', 'dictionary', 'omni', 'member', 'buffer', 'file', 'file/include']
        " codeのハイライトのためsyntaxファイルを大量に読み込むため、syntaxを入れておくと、insertモード開始時に固まるので抜く
        let g:neocomplete#sources.markdown = ['tag', 'neosnippet', 'omni', 'member', 'buffer', 'file', 'file/include']
        " shawncplus/phpcomplete.vimで補完されるため、syntaxはいらない
        let g:neocomplete#sources.php      = ['tag', 'neosnippet', 'omni', 'member', 'buffer', 'file', 'file/include']
        let g:neocomplete#sources.vim      = ['member', 'buffer', 'file', 'neosnippet', 'file/include', 'vim']
        let g:neocomplete#sources.vimshell = ['buffer', 'vimshell']

        " 補完候補の順番
        if dein#tap('neocomplete.vim')
            " defaultの値は ~/.vim/bundle/neocomplete.vim/autoload/neocomplete/sources/ 以下で確認
            " ファイル名補完
            call neocomplete#custom#source('file',         'rank', 450)
            call neocomplete#custom#source('neosnippet',   'rank', 440)
            call neocomplete#custom#source('member',       'rank', 430)
            call neocomplete#custom#source('buffer',       'rank', 420)
            call neocomplete#custom#source('omni',         'rank', 410)
            call neocomplete#custom#source('file/include', 'rank', 370)
            call neocomplete#custom#source('tag',          'rank', 360)
            call neocomplete#custom#source('syntax',       'rank', 300)
            " call neocomplete#custom#source('ultisnips',    'rank', 400)
        endif

        let g:neocomplete#data_directory = $VIM_CACHE_DIR . '/neocomplete'

        " Enable omni completion.
        augroup MyVimrc
            autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
            autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        augroup END
        " let g:neocomplete#sources#omni#functions.sql =
        " \ 'sqlcomplete#Complete'

        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif

        if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
        endif

        if !exists('g:neocomplete#sources#omni#functions')
            let g:neocomplete#sources#omni#functions = {}
        endif

        let g:neocomplete#sources#omni#functions.dot = 'GraphvizComplete'
        let g:neocomplete#force_omni_input_patterns.dot = '\%(=\|,\|\[\)\s*\w*'
        " forceで設定しているとmarkdownのコードブロックでも探そうとするらしく
        "   -- オムニ補完 (^O^N^P) パターンは見つかりませんでした
        " が表示される

        let g:neocomplete#sources#omni#input_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'


        " 日本語も補完させたい場合は
        " g:neocomplete#enable_multibyte_completionをnon-0にして
        " g:neocomplete#keyword_patternsも変更する必要あり

        " key mappings {{{2
        inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
        execute 'inoremap <expr><C-l> neocomplete#complete_common_string()'
        execute 'inoremap <expr><C-Space> neocomplete#start_manual_complete()'
        " execute 'inoremap <expr><C-Space> pumvisible() ? "\<C-n>" : neocomplete#start_manual_complete()'
        " inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-n>"
        execute 'inoremap <expr><C-g>  pumvisible() ? neocomplete#undo_completion() : "\<C-g>"'

        " <C-u>, <C-w>した文字列をアンドゥできるようにする
        " http://vim-users.jp/2009/10/hack81/
        " C-uでポップアップを消したいがうまくいかない
        execute 'inoremap <expr><C-u>  pumvisible() ? neocomplete#smart_close_popup()."\<C-g>u<C-u>" : "\<C-g>u<C-u>"'
        execute 'inoremap <expr><C-w>  pumvisible() ? neocomplete#smart_close_popup()."\<C-g>u<C-w>" : "\<C-g>u<C-w>"'

        " Vim - smartinput の <BS> や <CR> の汎用性を高める - Qiita
        " <http://qiita.com/todashuta@github/items/bdad8e28843bfb3cd8bf>


        " previewしない
        set completeopt-=preview
        if MyHasPatch('patch-7.4.775')
            " insert,selectしない
            set completeopt+=noinsert,noselect
        endif

        " auto_selectするとsnippetの方でうまくいかない
        " let g:neocomplete#enable_auto_select = 1
        " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        " function! s:my_cr_function()
        "     " For no inserting <CR> key.
        "     return pumvisible() ? "\<C-y>" : "\<CR>"
        "     " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
        " endfunction

        " " <TAB>: completion.
        " " ポップアップが出ていたら下を選択
        " " 出てなくて、
        " "   *があるときは右にインデント。a<BS>しているのは、改行直後に<Esc>すると、autoindentによって挿入された
        " "   空白が消えてしまうので
        " "   それ以外は普通のタブ
        " " 矩形選択して挿入モードに入った時にうまくいかない
        " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        "     \   (match(getline('.'), '^\s*\*') >= 0 ? "a<BS>\<Esc>>>A" : "\<Tab>")
        " inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" :
        "     \   (match(getline('.'), '^\s*\*') >= 0 ? "a<BS>\<Esc><<A" : "\<S-Tab>")

        " ポップアップが出てない時に、カーソルの左側がスペースならばタブ、そうでない場合は手動補完
        " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        " \   <SID>check_back_space() ? "\<TAB>" :
        " \   neocomplete#start_manual_complete()
        " function! s:check_back_space()
        "     let col = col('.') - 1
        "     return !col || getline('.')[col - 1]  =~ '\s'
        " endfunction

        " <BS>, <C-h> でポップアップを閉じて文字を削除。ポップアップを選択していたときはそれがキャンセルされた後に削除される。
        " 例) fuとタイプして、補完候補のfunctionを選択していた時に<BS>するとfになる
        " lexima.vimと競合するのでコメントアウト
        " execute 'inoremap <expr><BS>  pumvisible() ? neocomplete#smart_close_popup()."\<BS>"  : "\<BS>"'
        " execute 'inoremap <expr><C-h> pumvisible() ? neocomplete#smart_close_popup()."\<C-h>" : "\<C-h>"'

        " <CR> でポップアップ中の候補を選択し改行する
        " execute 'inoremap <expr><CR> neocomplete#close_popup()."\<CR>"'

        " これをやるとコピペに改行があるときにポップアップが選択されてしまう
        " 補完候補が表示されている場合は確定。そうでない場合は改行
        " execute 'inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"'

        " endif

        " let g:neocomplete#fallback_mappings =
        " \ ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

        " inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
        " inoremap <expr><C-x><C-n>  neocomplete#start_manual_complete('buffer')
        imap  <C-x>u <Plug>(neocomplete_start_unite_complete)
        " imap  <C-x>u <Plug>(neocomplete_start_unite_quick_match)

        " let g:neocomplete#enable_cursor_hold_i = 1
        " let g:neocomplete#cursor_hold_i_time = 100

        " let g:neocomplete#disable_auto_complete = 1
        " let g:neocomplete#enable_refresh_always = 1
        " autocmd MyVimrc FileType *
        " \   if &filetype == 'php'
        " \|      echom 'php'
        " \|      let g:neocomplete#enable_cursor_hold_i=1
        " \|      let g:neocomplete#cursor_hold_i_time=100
        " \|      NeoCompleteEnable
        " \|  else
        " \|      let g:neocomplete#enable_cursor_hold_i=0
        " \|      NeoCompleteEnable
        " \|  endif

        " ?
        " let g:neocomplete#fallback_mappings =
        " \ ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

        " inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
        " inoremap <expr><C-x><C-n>  neocomplete#start_manual_complete('buffer')
        imap  <C-x>u <Plug>(neocomplete_start_unite_complete)
        " imap  <C-x>u <Plug>(neocomplete_start_unite_quick_match)
        " }}}
    endfunction

    call s:dein_on_source('neocomplete')
endif

" neosnippet {{{1
" ==============================================================================
if dein#tap('neosnippet.vim')
    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory= [
    \   '~/.vim/bundle/vim-snippets/snippets',
    \   '~/.vim/bundle/wmgraphviz.vim/snippets',
    \]

    function! s:neosnippet_on_source() abort
        " Plugin key-mappings.
        imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)" :
        \   "\<C-o>D"
        smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)" :
        \   "\<C-o>D"
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " For snippet_complete marker.
        " if has('conceal')
        "     set conceallevel=2 concealcursor=niv
        " endif

        " Enable snipMate compatibility feature.
        let g:neosnippet#enable_snipmate_compatibility = 1

    endfunction

    call s:dein_on_source('neosnippet')
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

" lexima.vim {{{1
" ==============================================================================
if dein#tap('lexima.vim')
    " reloadble
    function! s:lexima_on_source() abort
        let g:lexima_no_default_rules = 1
        let g:lexima_enable_space_rules = 0
        call lexima#set_default_rules()

        " <C-h>でlexima.vimの<BS>の動きをさせる
        imap <C-h> <BS>

        " <C-f>で右に移動
        imap <C-f> <Right>
        call lexima#add_rule({'char': '<Right>', 'leave': 1})

        " dot repeatableな<C-d>。lexima.vimによって追加された文字以外は
        " 消してくれないので、コメント
        " call lexima#add_rule({'char': '<C-d>', 'delete': 1})
        inoremap <C-d> <Del>

        " matchparisで設定したもの(「,」:（,）など)をルールに追加
        for s:val in split(&matchpairs, ',')
            if s:val ==# '<:>'
                continue
            endif
            let s:val = escape(s:val, '[]')
            let s:pair = split(s:val, ':')
            execute "call lexima#add_rule({'char': '".s:pair[0]."', 'input_after': '". s:pair[1]."'})"
            execute "call lexima#add_rule({'char': '".s:pair[1]."', 'at': '\\%#".s:pair[1]."', 'leave': 1})"
            execute "call lexima#add_rule({'char': '<BS>', 'at': '".s:pair[0].'\%#'.s:pair[1]."', 'delete': 1})"
        endfor

        call lexima#add_rule({'char': '<CR>', 'at': '" \%#',  'input': '<BS><BS>'})

        " Markdownのリストでなんにも書いてない場合に改行した場合はリストを消す
        for s:val in ['-', '\*', '+', '1.', '>']
            execute 'call lexima#add_rule({''char'': ''<CR>'', ''at'': ''^\s*'.s:val.'\s*\%#'',  ''input'': ''<C-w><C-w><CR>'', ''filetype'': ''markdown''})'
            execute 'call lexima#add_rule({''char'': ''<CR>'', ''at'': ''^\s*'.s:val.'\s*\%#'',  ''input'': ''<Esc>0Di'', ''filetype'': ''rmd''})'
        endfor

        " Vim script {{{2
        " --------------------------------------------------------------------
        " Vim scriptで以下のようなインデントをする
        " NeoBundleLazy "cohama/lexima.vim", {
        " \   "autoload": {
        " \       "insert": 1
        " \   }
        " \}
        for s:val in ['{:}', '\[:\]']
            let s:pair = split(s:val, ':')

            " {\%#}
            " ↓
            " {
            " \   \%%
            " \}
            execute 'call lexima#add_rule({''char'': ''<CR>'', ''at'': '''.s:pair[0].'\%#'.s:pair[1].''', ''input'': ''<CR>\   '', ''input_after'': ''<CR>\'', ''filetype'': ''vim''})'
            " \   {\%#}
            " ^^^^ shiftwidthの倍数 - 1の長さ
            " ↓
            " \   {
            " \       \%#
            " \   }
            let s:indent = &l:shiftwidth
            " indent 5つ分まで設定
            for s:i in range(1, 5)
                let s:space_num = s:indent * s:i - 1
                let s:space = ''
                for s:j in range(s:space_num + s:indent)
                    let s:space = s:space . ' '
                endfor
                let s:space_after = ''
                for s:j in range(s:space_num)
                    let s:space_after = s:space_after . ' '
                endfor

                execute 'call lexima#add_rule({''char'': ''<CR>'', ''at'': ''^\s*\\\s\{'.s:space_num.'\}.*'.s:pair[0].'\%#'.s:pair[1].''', ''input'': ''<CR>\'.s:space.''', ''input_after'': ''<CR>\'.s:space_after.''', ''filetype'': ''vim''})'
            endfor
        endfor

        " \   {
        " \       'hoge': 'fuga',\%#
        " \   }
        " ↓
        " \   {
        " \       'hoge': 'fuga',
        " \       \%#
        " \   }
        let s:indent = &l:shiftwidth
        " indent 5つ分まで設定
        for s:i in range(1, 5)
            let s:space_num = s:indent * s:i - 1
            let s:space = ''
            for s:j in range(s:space_num)
                let s:space = s:space . ' '
            endfor
            execute 'call lexima#add_rule({''char'': ''<CR>'', ''at'': ''^\s*\\\s\{'.s:space_num.'\}.*,\%#'', ''input'': ''<CR>\'.s:space.''', ''filetype'': ''vim''})'
        endfor
        " }}}

        call lexima#add_rule({'char': '<Right>', 'at': '\%#"""',  'leave': 3})
        call lexima#add_rule({'char': '<Right>', 'at': "\\%#'''", 'leave': 3})
        call lexima#add_rule({'char': '<Right>', 'at': '\%#```',  'leave': 3})

        " ｛｛｛1などの入力
        " call lexima#add_rule({'char': '{', 'at': '{{\%#}}', 'delete': 2})
        call lexima#add_rule({'char': '1', 'at': '{{{\%#}}}', 'delete': 3})
        call lexima#add_rule({'char': '2', 'at': '{{{\%#}}}', 'delete': 3})
        call lexima#add_rule({'char': '3', 'at': '{{{\%#}}}', 'delete': 3})

        call lexima#add_rule({'char': '"', 'filetype': ['vimperator']})

        " <!-- | -->
        call lexima#add_rule({'char': '!', 'at': '<\%#', 'input': '!-- ', 'input_after': ' -->', 'filetype': ['html', 'xml', 'apache']})

        " call lexima#add_rule({'char': '=', 'input': ' = '})
        " call lexima#add_rule({'char': '=', 'input': '=', 'syntax': 'vimSet'})
        " call lexima#add_rule({'char': '+', 'input': ' + '})
        " call lexima#add_rule({'char': '+', 'input': '+', 'syntax': 'vimOption'})
        " call lexima#add_rule({'char': '-', 'input': ' - '})
        " call lexima#add_rule({'char': '-', 'input': '-', 'syntax': 'vimSetEqual'})
        " call lexima#add_rule({'char': '*', 'input': ' * '})
        " call lexima#add_rule({'char': '/', 'input': ' / '})
        " call lexima#add_rule({'char': '/', 'input': '/', 'syntax': ['String', 'shQuote']})
        " call lexima#add_rule({'char': ',', 'input': ', '})


        " neocomplete.vimとの連携
        " imapを使ってlexima.vimの<BS>にマップ。巡回参照になってしまうので、<C-h>にはマップ出来ない
        " execute 'imap <expr><C-h> pumvisible() ? ' . s:neocom . '#smart_close_popup()."\<BS>" : "\<BS>"'
    endfunction

    call s:dein_on_source('lexima')
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

        " let g:quickrun_no_default_key_mappings = 1
        " map <Leader>r <Plug>(quickrun)

        " <C-c> で実行を強制終了させる
        " quickrun.vim が実行していない場合には <C-c> を呼び出す
        nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

        if !exists('g:quickrun_config')
            let g:quickrun_config = {}
        endif
        " 共通の設定
        " [shabadou.vim を使って quickrun.vim をカスタマイズしよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20120919/1348054752)
        let g:quickrun_config['_'] = {
        \ 'runner':                                    'vimproc',
        \ 'runner/vimproc/updatetime':                 50,
        \ 'outputter':                                 'multi:buffer:quickfix',
        \ 'outputter/buffer/split':                    'botright 8sp',
        \ 'hook/cd/directory':                         '%S:p:h',
        \ 'hook/close_quickfix/enable_hook_loaded':    1,
        \ 'hook/close_quickfix/enable_success':        1,
        \ 'hook/close_buffer/enable_empty_data':       1,
        \ 'hook/close_buffer/enable_failure':          1,
        \ 'hook/hier_update/enable_exit':              1,
        \ 'hook/hier_update/priority_exit':            2,
        \ 'hook/qfsigns_update/enable_exit':           1,
        \ 'hook/qfsigns_update/priority_exit':         2,
        \ 'hook/quickfix_status_enable/enable_exit':   1,
        \ 'hook/quickfix_status_enable/priority_exit': 2,
        \}
        " \ 'hook/qfstatusline_update/enable_exit':      1,
        " \ 'hook/qfstatusline_update/priority_exit':    2,

        " PHP {{{2
        " --------------------------------------------------------------------
        let g:quickrun_config['php'] = deepcopy(g:quickrun#default_config['php'])
        let g:quickrun_config['php']['hook/cd/directory'] = '%S:p:h'
        let g:quickrun_config['phpv'] = {
        \   'exec': 'php %s',
        \   'hook/eval/enable': 1,
        \   'hook/eval/template': '<?php %s'
        \}

        let g:quickrun_config['php.phpunit'] = {
        \ 'hook/cd/directory'              : '%S:p:h',
        \ 'command'                        : 'phpunit.sh',
        \ 'cmdopt'                         : '',
        \ 'exec'                           : '%c -v --debug --colors %o %s',
        \ 'outputter/quickfix/errorformat' : '%f:%l,%m in %f on line %l',
        \}

        let g:quickrun_config['sudo_phpunit'] = deepcopy(g:quickrun_config['php.phpunit'])
        let g:quickrun_config['sudo_phpunit']['exec'] = 'echo %{GetPassword()} | sudo -S '.g:quickrun_config['sudo_phpunit']['exec']

        let g:quickrun_config['php-cs-fixer'] = {
        \   'hook/cd/directory'              : '%S:p:h',
        \   'outputter'                     : 'buffer',
        \   'hook/close_buffer/enable_failure':          0,
        \   'command'                        : 'php-cs-fixer.sh',
        \   'cmdopt'                         : '',
        \   'exec'                           : '%c --diff %o %a',
        \}
        " composer.json {{{3
        let g:quickrun_config['composer.json'] = {
        \ 'hook/cd/directory' : '%S:p:h',
        \ 'command'           : 'composer',
        \ 'cmdopt'            : '',
        \ 'exec'              : '%c %a',
        \}

        autocmd MyVimrc BufRead,BufNewFile composer.json
        \   setlocal filetype=composer.json
        \ | nnoremap <buffer> <Leader>ri :<C-u>QuickRun -args install<CR>
        \ | nnoremap <buffer> <Leader>ru :<C-u>QuickRun -args update<CR>

        " R lang {{{2
        " --------------------------------------------------------------------
        let g:quickrun_config['rmd'] = {
        \ 'command'                        : 'Rscript',
        \ 'cmdopt'                         : '-e',
        \ 'exec'                           : ['%c %o "library(rmarkdown);rmarkdown::render(''%s:p'')"'],
        \ 'outputter'                      : 'quickfix',
        \}

        " dot, graphviz {{{2
        " --------------------------------------------------------------------
        let g:quickrun_config['dot'] = {
        \ 'hook/cd/directory'              : '%S:p:h',
        \ 'command'                        : 'dot',
        \ 'cmdopt'                         : '',
        \ 'exec'                           : ['%c -Tpng %s -o %s:r.png', 'open -a Firefox %s:r.png'],
        \ 'outputter/quickfix/errorformat' : 'Error: %f: %m in line %l %.%#,%EError: %m,%C%m,%Z%m'
        \}

        " Android Dev {{{2
        " --------------------------------------------------------------------
        " function! s:QuickRunAndroidProject()
        "     let l:project_dir = unite#util#path2project_directory(expand('%'))
        "
        "     for l:line in readfile(l:project_dir.'/AndroidManifest.xml')
        "         " package名の取得
        "         " ex) com.sample.helloworld
        "         if !empty(matchstr(l:line, 'package="\zs.*\ze"'))
        "             let l:package = matchstr(l:line, 'package="\zs.*\ze"')
        "             continue
        "         endif
        "
        "         " android:nameの取得
        "         " ex) com.sample.helloworld.HelloWorldActivity
        "         if !empty(matchstr(l:line, 'android:name="\zs.*\ze"'))
        "             let l:android_name = matchstr(l:line, 'android:name="\zs.*\ze"')
        "             break
        "         endif
        "     endfor
        "
        "     if empty(l:package)
        "         echo 'package名が見つかりません'
        "         return -1
        "     elseif empty(l:android_name)
        "         echo 'android:nameが見つかりません'
        "         return -1
        "     endif
        "
        "     let l:apk_file = l:project_dir.'/bin/'.matchstr(l:android_name, '[^.]\+$').'-debug.apk'
        "     " ex) com.sample.helloworld/.HelloWorldActivity
        "     let l:component = substitute(l:android_name, '\zs\.\ze[^.]*$', '/.', '')
        "
        "     let g:quickrun_config['androidProject'] = {
        "     \   'hook/cd/directory'           : l:project_dir,
        "     \   'hook/output_encode/encoding' : 'sjis',
        "     \   'exec'                        : [
        "     \       'android update project --path .',
        "     \       'ant debug',
        "     \       'adb -d install -r '.l:apk_file,
        "     \       'adb shell am start -a android.intent.action.MAIN -n '.l:package.'/'.l:android_name
        "     \   ]
        "     \}
        "
        "     QuickRun androidProject
        " endfunction
        "
        " command! QuickRunAndroidProject call s:QuickRunAndroidProject()
        " autocmd MyVimrc BufRead,BufNewFile */workspace/* nnoremap <buffer> <Leader>r :QuickRunAndroidProject<CR>

        " Node.js {{{2
        " --------------------------------------------------------------------
        " let g:quickrun_config['node'] = {
        "             \   'runner/vimproc/updatetime' : 1000,
        "             \   'command'                : 'tail',
        "             \   'cmdopt'                 : '',
        "             \   'exec'                   : '%c %o ~/git/jidaraku_schedular/log',
        "             \   'outputter/multi'   : [ 'buffer', 'quickfix' , 'message'],
        "             \}
        " "
        " set errorformat=debug:\%s
        call SourceRc('quickrun_local.vim')
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

    function! s:watchdogs_on_source() abort
        let g:watchdogs_check_BufWritePost_enable = 1

        if !exists('g:quickrun_config')
            let g:quickrun_config = {}
        endif

        let g:quickrun_config['watchdogs_checker/_'] = {
        \ 'hook/hier_update/enable_exit':              1,
        \ 'hook/hier_update/priority_exit':            2,
        \ 'hook/qfsigns_update/enable_exit':           1,
        \ 'hook/qfsigns_update/priority_exit':         2,
        \ 'hook/quickfix_status_enable/enable_exit':   1,
        \ 'hook/quickfix_status_enable/priority_exit': 2,
        \}
        " \ 'hook/qfstatusline_update/enable_exit':      1,
        " \ 'hook/qfstatusline_update/priority_exit':    2,

        " quickrunの出力結果が空の時にquickrunのバッファを閉じる設定。
        " watchdogsの場合は出力が無いので、これを1にしておくと
        " quickrunでなんらかのプログラムを実行したあと保存をすると
        " その出力結果が消えてしまうので、0にする
        let g:quickrun_config['watchdogs_checker/_']['hook/close_buffer/enable_empty_data'] = 0

        " open_cmdを''にするとquickfixが開かない。開くとhook/*_updateが効かない
        let g:quickrun_config['watchdogs_checker/_']['outputter/quickfix/open_cmd'] = ''
        " quickfixを開いてかつ、updateしたいときはautocmd FileType qfで
        " windo HierUpdateなどを行う

        " apaache {{{2
        " ------------------------------------------------------------------------
        let g:quickrun_config["watchdogs_checker/apache"] = {
        \   "command":           "apachectl",
        \   "cmdopt":            "configtest",
        \   "exec":              "%c %o",
        \   "errorformat":       "%A%.%#Syntax error on line %l of %f:,%Z%m,%-G%.%#",
        \}

        let g:quickrun_config["apache/watchdogs_checker"] = {
        \   "type" : "watchdogs_checker/apache"
        \}

        " cpp {{{2
        " ------------------------------------------------------------------------
        let g:quickrun_config["cpp/watchdogs_checker"] = {
        \   "type"
        \       : executable("g++")         ? "watchdogs_checker/g++"
        \       : executable("clang-check") ? "watchdogs_checker/clang_check"
        \       : executable("clang++")     ? "watchdogs_checker/clang++"
        \       : executable("cl")          ? "watchdogs_checker/cl"
        \       : "",
        \}

        let g:quickrun_config["watchdogs_checker/g++"] = {
        \   "command"   : "g++",
        \   "exec"      : "%c %o -std=gnu++0x -fsyntax-only %s:p ",
        \   "outputter" : "quickfix",
        \}

        " mql {{{2
        " ------------------------------------------------------------------------
        let g:quickrun_config["watchdogs_checker/mql"] = {
        \   "hook/cd/directory": '%S:p:h',
        \   "command":           "wine",
        \   "cmdopt":            '~/Dropbox/src/localhost/me/MetaTrader/mql.exe /i:Z:'.$HOME.'/PlayOnMac''''''''s\ virtual\ drives/OANDA_MT4_/drive_c/Program\ Files/OANDA\ -\ MetaTrader/MQL4',
        \   "exec":              "%c %o %S:t",
        \   "errorformat":       '%f(%l\,%c) : %m',
        \}
        " hook/cd/directoryでファイルのあるディレクトリに移動して、execでファイル名を指定して実行。
        " ディレクトリを移動しない場合、wine側で認識させるためにz:をファイルパスにつけル必要があり、つけた結果エラー結果にz:がついてしまい、Vimで開くことができなくなる
        " cmdoptでmql.exeをwineに渡す。#includeを読み込むためにはProgram FilesのMetaTraderディレクトリにmql.exeを置いておくか、/i:オプションでworking directoryを指定する
        " MetaTraderディレクトリにmql.exeを置いておくと、MetaTraderの再起動時にファイルが消えてしまうので後者の方法を取る
        " シングルクォートが非常に多いが
        " シングルクォートの中でシングルクォートを表すには''、
        " さらにvimprocでシングルクォートを表すために''''、
        " さらにwineの引数でシングルクォートを表すために''''''''
        " となっている

        let g:quickrun_config["mql4/watchdogs_checker"] = {
        \   "type" : "watchdogs_checker/mql"
        \}

        " fugitiveのdiffなどの表示画面ではcheckしない
        autocmd MyVimrc BufRead fugitive://*.mq4
        \   let b:watchdogs_checker_type = ''


        " java {{{2
        " ------------------------------------------------------------------------
        let g:quickrun_config['java/watchdogs_checker'] = {
        \   'type': ''
        \}

        " php {{{2
        " ------------------------------------------------------------------------
        if executable('phpcs')
            let g:quickrun_config['watchdogs_checker/php'] = {
            \   'exec' : ['php -l %s:p', 'phpcs --standard=PSR2 --report=csv %s:p'],
            \   'errorformat' :
            \       '%m\ in\ %f\ on\ line\ %l,'.
            \       '%-GNo syntax errors detected in %.%#,'.
            \       '%-GErrors parsing %.%#,'.
            \       '%-G,'.
            \       '"%f"\,%l\,%c\,%t%*[^\,]\,"%m"\,%.%#,'.
            \       '%-GFile\,Line\,Column\,Type\,Message\,Source\,Severity\,Fixable'
            \}
        else
            let g:quickrun_config['watchdogs_checker/php'] = {
            \   'command' : 'php',
            \   'exec'    : '%c %o -l %s:p',
            \   'errorformat' : '%m\ in\ %f\ on\ line\ %l,%Z%m,%-G%.%#',
            \}
        endif


        let g:quickrun_config['php.phpunit/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/php'
        \}

        " R-lang {{{2
        " --------------------------------------------------------------------
        " Rmd {{{3
        let g:quickrun_config['rmd/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/rmd'
        \}

        let g:quickrun_config['watchdogs_checker/rmd'] = {
        \   'hook/cd/directory': '%S:p:h',
        \   'command': 'Rscript',
        \   'cmdopt': '-e',
        \   'exec': ['%c %o "library(rmarkdown);rmarkdown::render(''%s:p'')"', 'sleep 1', 'touch %s:p:r.html'],
        \}

        " sh {{{2
        " --------------------------------------------------------------------
        " filetypeがshでも基本的にbashを使うので、bashでチェックする
        let g:quickrun_config['sh/watchdogs_checker'] = {
        \   'type': (executable('bash') ? 'watchdogs_checker/bash' : '')
        \}

        let g:quickrun_config['watchdogs_checker/bash'] = {
        \   'command':     'bash',
        \   'exec':        '%c -n %o %s:p',
        \   'errorformat': '%f:\ line\ %l:%m',
        \}

        " sql {{{2
        " ------------------------------------------------------------------------
        " filetypeがshでも基本的にbashを使うので、bashでチェックする
        let g:quickrun_config['sql/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/sql'
        \}

        " https://sql.treasuredata.com/
        let g:quickrun_config['watchdogs_checker/sql'] = {
        \   'command':     'curl',
        \   'exec':        '%c -s "https://td-sql.herokuapp.com/api/v1/query/validate?callback=angular.callbacks._1\&engine=hive\&query=`cat %s | perl -pe ''s/\n/%%0A/''`"',
        \   'errorformat': '%f:\ line\ %l:%m',
        \}

        " \   'exec':        "%c -v \"https://td-sql.herokuapp.com/api/v1/query/validate?callback=angular.callbacks._1\\&engine=hive\\&query=`cat %s`\"",
        " \   'exec':        '%c -v "https://td-sql.herokuapp.com/api/v1/query/validate?callback=angular.callbacks._1\&engine=hive\&query=\$(cat %s)"',
        " vim {{{2
        " ------------------------------------------------------------------------
        let g:quickrun_config['vim/watchdogs_checker'] = {
        \   'type': executable('vint') ? 'watchdogs_checker/vint' : '',
        \}

        let g:quickrun_config['watchdogs_checker/vint'] = {
        \       'command'   : 'vint',
        \       'exec'      : '%c %o %s:p',
        \}

        " zsh {{{2
        " ------------------------------------------------------------------------
        " let g:quickrun_config['zsh/watchdogs_checker'] = {
        " \   'type': ''
        " \}

        call SourceRc('watchdogs_local.vim')
        " watchdogs.vim の設定を更新（初回は呼ばれる）
        call watchdogs#setup(g:quickrun_config)

    endfunction

    call s:add_on_source(g:dein#name, 's:watchdogs_on_source')
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
let g:qfsigns#Config = {"id": '5050', 'name': 'qfsign'}
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

    " そもそもclipboardはoperator
    " let bundle = neobundle#get("vim-operator-user")
    " function! bundle.hooks.on_source(bundle)
    "     " clipboard copyのoperator
    "     " http://www.infiniteloop.co.jp/blog/2011/11/vim-operator/
    "     function! OperatorYankClipboard(motion_wiseness)
    "         let visual_commnad =
    "             \ operator#user#visual_command_from_wise_name(a:motion_wiseness)
    "         execute 'normal!' '`['.visual_commnad.'`]"+y'
    "     endfunction
    "
    "     call operator#user#define('yank-clipboard', 'OperatorYankClipboard')
    " endfunction
    " map [:space:]y <Plug>(operator-yank-clipboard)
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

" vital-coaster, CTRL-A, CTRL-X {{{1
" ============================================================================
" - の前に空白文字以外があれば <C-x> を、それ以外は <C-a> を呼ぶ
" "Vim で特定の条件でのみ <C-a> でインクリメントしないようにする - Secret Garden(Instrumental":http://secret-garden.hatenablog.com/entry/2015/05/14/180752
" -423  ←これは <C-a> される
" d-423 ←これは <C-x> される

if dein#tap('vital-coaster')
    nmap <C-a> <Plug>(my-increment)
    nmap <C-x> <Plug>(my-decriment)

    nnoremap <expr> <Plug>(my-increment) <SID>increment('\S-\d\+', "\<C-x>")
    nnoremap <expr> <Plug>(my-decriment) <SID>decrement('\S-\d\+', "\<C-a>")
    let s:Buffer = vital#of('vital').import('Coaster.Buffer')

    function! s:count(pattern, then, else)
        let word = s:Buffer.get_text_from_pattern(a:pattern)
        if word !=# ''
            return a:then
        else
            return a:else
        endif
    endfunction

    " 第一引数に <C-a> を無視するパターンを設定
    " 第二引数に無視した場合の代替キーを設定
    function! s:increment(ignore_pattern, ...)
        let key = get(a:, 1, '')
        return s:count(a:ignore_pattern, key, "\<C-a>")
    endfunction

    function! s:decrement(ignore_pattern, ...)
        let key = get(a:, 1, '')
        return s:count(a:ignore_pattern, key, "\<C-x>")
    endfunction
endif

" vim-asterisk {{{1
" ============================================================================
if dein#tap('vim-asterisk')
    map *  <Plug>(asterisk-z*)
    " map #  <Plug>(asterisk-z#)
    map #  <Plug>(asterisk-gz#)
    " map g* <Plug>(asterisk-gz*)
    " map g# <Plug>(asterisk-gz#)
    let g:asterisk#keeppos = 1

    nmap g* *:%s/<C-r>//<C-r>//gc<M-b><M-b><M-b>
    nmap g# #:%s/<C-r>//<C-r>//gc<M-b><M-b><M-b>
endif

" vim-easymotion {{{1
" ============================================================================
if dein#tap('vim-easymotion')
    map ' <Plug>(easymotion-s2)
    " map ' <Plug>(easymotion-bd-jk)
    " map f <Plug>(easymotion-fl)
    " map t <Plug>(easymotion-tl)
    " map F <Plug>(easymotion-Fl)
    " map T <Plug>(easymotion-Tl)

    function! s:easymotion_on_source() abort
        let g:EasyMotion_smartcase = 1
        let g:EasyMotion_keys = 'asdfgghjkl;:qwertyuiop@zxcvbnm,./1234567890-'
        let g:EasyMotion_do_mapping = 0
    endfunction

    call s:dein_on_source('easymotion')
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

" vim-ref {{{1
" ============================================================================
if dein#tap('vim-ref')
    function! s:vim_ref_on_source() abort
        if has('mac')
            let g:ref_man_cmd = 'man -P cat'
        endif
        " command! -nargs=* Man Ref man <args>
    endfunction

    call s:dein_on_source('vim_ref')
endif

" vim-partedit {{{1
" ============================================================================
if dein#tap('vim-partedit')
    " let g:partedit#auto_prefix = 0

    nnoremap <Leader>pe :<C-u>MyParteditContext<CR>
    xnoremap <Leader>pe :Partedit -opener split<CR>
    nnoremap <Leader>pq :<C-u>ParteditEnd<CR>
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
nnoremap <C-p> gT
nnoremap <C-n> gt

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
    nmap <expr><C-p> yankround#is_active() ? "\<Plug>(yankround-prev)" : "gT"
    nmap <expr><C-n> yankround#is_active() ? "\<Plug>(yankround-next)" : "gt"
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
    nmap [:space:]<C-w>f     <Plug>(gf-user-<C-w>f)
    xmap [:space:]<C-w>f     <Plug>(gf-user-<C-w>f)
    nmap [:space:]<C-w><C-f> <Plug>(gf-user-<C-w><C-f>)
    xmap [:space:]<C-w><C-f> <Plug>(gf-user-<C-w><C-f>)
    nmap [:space:]<C-w>F     <Plug>(gf-user-<C-w>F)
    xmap [:space:]<C-w>F     <Plug>(gf-user-<C-w>F)
    nmap [:space:]<C-w>gf    <Plug>(gf-user-<C-w>gf)
    xmap [:space:]<C-w>gf    <Plug>(gf-user-<C-w>gf)
    nmap [:space:]<C-w>gF    <Plug>(gf-user-<C-w>gF)

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

" caw {{{1
" ==============================================================================
" http://d.hatena.ne.jp/osyo-manga/20120106/1325815224
if dein#tap('caw.vim')
    " コメントアウトのトグル
    nmap <Leader>cc <Plug>(caw:i:toggle)
    xmap <Leader>cc <Plug>(caw:i:toggle)
    " http://d.hatena.ne.jp/osyo-manga/20120303/1330731434
    " 現在の行をコメントアウトして下にコピー
    nmap <Leader>cy yyPgcij
    xmap <Leader>cy ygvgcigv<C-c>p
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
    " こう設定しないとpangloss/vim-javascriptに上書きされてしまう
    autocmd MyVimrc BufRead *.js  setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType css  setlocal formatexpr=CSSBeautify()
    autocmd MyVimrc FileType html setlocal formatexpr=HtmlBeautify()
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

" diff {{{1
" ============================================================================
set diffopt+=vertical
nnoremap [VIMDIFF] <Nop>
nmap [:space:]d [VIMDIFF]
nnoremap [VIMDIFF]t :diffthis<CR>
nnoremap [VIMDIFF]u :diffupdate<CR>
nnoremap [VIMDIFF]o :diffoff<CR>
nnoremap [VIMDIFF]T :windo diffthis<CR>
nnoremap [VIMDIFF]O :windo diffoff<CR>
nnoremap [VIMDIFF]s :vertical diffsplit<space>
nnoremap [VIMDIFF]w :set diffopt+=iwhite<CR>
nnoremap [VIMDIFF]W :set diffopt-=iwhite<CR>
nnoremap dP :<C-u>%diffput<CR>
nnoremap dO :<C-u>%diffget<CR>

" vimdiffでより賢いアルゴリズム (patience, histogram) を使う - Qiita {{{2
" ----------------------------------------------------------------------------
" http://qiita.com/takaakikasai/items/3d4f8a4867364a46dfa3
" https://github.com/fumiyas/home-commands/blob/master/git-diff-normal
let s:git_diff_normal='git-diff-normal'
" let s:git_diff_normal_opts=["--diff-algorithm=histogram"]
" gitのバージョンが1.7だと--diff-algorithmが使えなかった
let s:git_diff_normal_opts=['--patience']

function! GitDiffNormal()
    let args=[s:git_diff_normal]
    if &diffopt =~# 'iwhite'
        call add(args, '--ignore-all-space')
    endif
    call extend(args, s:git_diff_normal_opts)
    call extend(args, [v:fname_in, v:fname_new])
    let cmd=join(args, ' ') . '>' . v:fname_out
    call system(cmd)
endfunction

autocmd MyVimrc FilterWritePre *
\   if &diff && !exists('g:my_check_diff')
\|      if executable(s:git_diff_normal) && executable('git')
\|          set diffexpr=GitDiffNormal()
\|      endif
\|      let g:my_check_diff = 1
\|  endif

" diffchar.vim {{{2
" ----------------------------------------------------------------------------
" vimdiffで単語単位の差分表示: diffchar.vimが超便利 - Qiita
" http://qiita.com/takaakikasai/items/0d617b6e0aed490dff35
if dein#tap('diffchar.vim')
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

" eclim {{{1
" ============================================================================
if dein#tap('eclim')

    " エラーのマークがずれる場合はエンコーディングが間違っている
    " http://eclim.org/faq.html#code-validation-signs-are-showing-up-on-the-wrong-lines

    function! s:eclim_on_source() abort
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

    endfunction

    call s:dein_on_source('eclim')
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

function! s:set_python_path()
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
" call s:set_python_path()
" }}}

autocmd MyVimrc FileType python
\   if ! exists('g:python_path')
\|      let g:python_path = system('python -', 'import sys;sys.stdout.write(",".join(sys.path))')
\|  endif
\|  let &l:path = g:python_path

" {{{2 jedi
" ----------------------------------------------------------------------------
if dein#tap('jedi-vim')
    function! s:jedi_on_source() abort
        " call s:set_python_path()

        autocmd MyVimrc FileType python setlocal omnifunc=jedi#completions

        if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
        endif

        " iexe pythonで>>>がある場合も補完が効くように
        " '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        " を ^\s* -> ^>*\s* に変更した
        let g:neocomplete#force_omni_input_patterns.python =
        \ '\%([^. \t]\.\|^>*\s*@\|^>*\s*from\s.\+import \|^>*\s*from \|^>*\s*import \)\w*'

        let g:jedi#completions_enabled = 0
        " completeopt, <C-c>の変更をしない
        let g:jedi#auto_vim_configuration = 0

        " quickrunと被るため大文字に変更
        let g:jedi#rename_command = '<Leader>R'
        let g:jedi#goto_assignments_command = '<C-]>'

        if jedi#init_python()
            function! s:jedi_auto_force_py_version() abort
                let major_version = pyenv#python#get_internal_major_version()
                call jedi#force_py_version(major_version)
            endfunction
            augroup vim-pyenv-custom-augroup
                autocmd! *
                autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
                autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
            augroup END
        endif
    endfunction

    call s:dein_on_source('jedi')
endif

" C, C++ {{{1
" ============================================================================
function! s:getCPath()
    if ! exists('g:c_path')
        let g:c_path = substitute(
        \   system("gcc -print-search-dirs | awk -F= '/libraries/ {print $2}'")
        \   , "\<NL>", '', ''
        \) . '/include'
    endif
    return g:c_path
endfunction

autocmd MyVimrc Filetype c,cpp
\|  execute 'setlocal path+='.s:getCPath()
\|  setlocal suffixesadd=.h

if dein#tap('vim-marching')
    function! s:marching_on_source() abort
        " clang コマンドの設定
        let g:marching_clang_command = "clang"

        " オプションを追加する
        " filetype=cpp に対して設定する場合
        " let g:marching#clang_command#options = {
        " \   "cpp" : "-std=gnu++1y"
        " \}

        " インクルードディレクトリのパスを設定
        let g:marching_include_paths = [
        \   s:getCPath()
        \]

        " neocomplete.vim と併用して使用する場合
        let g:marching_enable_neocomplete = 1

        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns = {}
        endif

        let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

        " オムニ補完時に補完ワードを挿入したくない場合
        " imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)

        " キャッシュを削除してからオムに補完を行う
        imap <buffer> <C-x><C-x><C-o> <Plug>(marching_force_start_omni_complete)

    endfunction

    call s:dein_on_source('marching')
endif

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

if dein#tap('neocomplete.vim')
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.r = '[[:alnum:].\\\$]\+'
    let g:neocomplete#sources#omni#functions.r = 'rcomplete#CompleteR'
endif

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

" rcmdnk/vim-markdown {{{2
" ----------------------------------------------------------------------------
" if dein#tap('rcmdnk_vim-markdown')
if dein#tap('vim-markdown')
    let g:vim_markdown_folding_disabled = 1
    " macでgxを使いたい場合
    let g:netrw_browsex_viewer= 'open'
    let g:vim_markdown_no_default_key_mappings=1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_conceal = 0

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
if dein#tap('vim-markdown-folding')
    function! s:markdown_folding_on_source() abort
        let g:markdown_fold_style = 'nested'
    endfunction

    call s:dein_on_source('markdown_folding')
endif

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
    nnoremap [fugitive]pl  :Git pull --rebase origin master
    nnoremap [fugitive]fo  :Git fetch origin<CR>
    nnoremap [fugitive]for :Git fetch origin<CR>:Git rebase origin/master<CR>

    nnoremap [fugitive]2 :diffget //2 <Bar> diffupdate\<CR>
    nnoremap [fugitive]3 :diffget //3 <Bar> diffupdate\<CR>

    " Gbrowse ではgit config --global web.browserの値は見てない
    " ~/.vim/bundle/vim-fugitive/plugin/fugitive.vim
    if !has('gui_running') && $SSH_CLIENT != ''
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

" gitv {{{2
" ----------------------------------------------------------------------------
if dein#tap('gitv')
    function! s:gitv_on_source() abort
        function! GitvGetCurrentHash()
            return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
        endfunction

        autocmd MyVimrc FileType gitv
            \   setlocal iskeyword+=/,-,.
            \|  nnoremap <buffer> <LocalLeader>rb :<C-u>Git rebase -i    <C-r>=GitvGetCurrentHash()<CR><CR>
            \|  nnoremap <buffer> <LocalLeader>rv :<C-u>Git revert       <C-r>=GitvGetCurrentHash()<CR><CR>
            \|  nnoremap <buffer> <LocalLeader>h  :<C-u>Git cherry-pick  <C-r>=GitvGetCurrentHash()<CR><CR>
            \|  nnoremap <buffer> <LocalLeader>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR><CR>
    endfunction

    call s:dein_on_source('gitv')
endif

" open-browser.vim {{{1
" ============================================================================
if dein#tap('open-browser.vim')
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)
    nmap <C-LeftMouse> <Plug>(openbrowser-smart-search)
    vmap <C-LeftMouse> <Plug>(openbrowser-smart-search)

    autocmd MyVimrc FileType *
    \    if &filetype !~ 'vim\|help\|man\|ref'
    \|      nnoremap <buffer> K :<C-u>MyOpenbrowserSearch n<CR>
    \|      xnoremap <buffer> K :<C-u>MyOpenbrowserSearch v<CR>
    \|  endif

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

    function! s:open_browser_on_source() abort
        let g:netrw_nogx = 1 " disable netrw's gx mapping.
        let g:openbrowser_open_filepath_in_vim = 0 " Vimで開かずに関連付けされたプログラムで開く

        if !exists('g:openbrowser_search_engines')
            let g:openbrowser_search_engines = {}
        endif
        let g:openbrowser_search_engines.php =
        \   'http://www.php.net/search.php?show=quickref&=&pattern={query}'
        let g:openbrowser_search_engines.mql4 =
        \   'http://www.mql4.com/search#!keyword={query}'

        if $SSH_CLIENT != ''
            let g:openbrowser_browser_commands = [
            \   {
            \       "name": "rfbrowser",
            \       "args": "rfbrowser {uri}"
            \   }
            \]
        endif
    endfunction

    call s:dein_on_source('open_browser')
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
\           ['column', 'lineinfo'],
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
\   }
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

" let g:Qfstatusline#UpdateCmd = function('lightline#update')
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
if dein#tap("rainbow")
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

" vim-geeknote {{{1
" ============================================================================
if dein#tap('vim-geeknote')
    function! s:geeknote_on_source() abort
        call s:set_python_path()
    endfunction

    call s:dein_on_source('geeknote')
endif

" vimwiki {{{1
" ============================================================================
if dein#tap('vimwiki')

    nmap <Leader>ww  <Plug>VimwikiIndex
    nmap <Leader>w<Leader>d  <Plug>VimwikiDiaryIndex
    nmap <Leader>wn  <Plug>VimwikiMakeDiaryNote
    nmap <Leader>wu  <Plug>VimwikiDiaryGenerateLinks

    function! s:vimwiki_on_source() abort
        let g:vimwiki_list = [{
            \   'path': '~/Dropbox/vimwiki/wiki/', 'path_html': '~/Dropbox/vimwiki/public_html/',
            \   'syntax': 'markdown', 'ext': '.txt'
            \}]
    endfunction

    call s:dein_on_source('vimwiki')
endif

" memoliset.vim {{{1
" ============================================================================
if dein#tap('memolist.vim')
    nnoremap <Leader>mn  :MemoNew<CR>
    nnoremap <Leader>ml  :Unite memo<CR>
    execute 'nnoremap <Leader>mg :<C-u>Unite grep:'.g:memo_directory.'<CR>'

    let g:memolist_path = g:memo_directory.'/'.strftime('%Y/%m')

    function! s:memolist_on_source() abort
        let g:memolist_memo_suffix = 'md'
        let g:memolist_template_dir_path = '~/.vim/template/memolist'
        let g:memolist_unite = 1
    endfunction

    call s:dein_on_source('memolist')
endif

" qfixhowm {{{1
" ==============================================================================
if dein#tap('qfixhowm')

    function! s:qfixhowm_on_source() abort
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
    endfunction

    call s:dein_on_source('qfixhowm')
endif
