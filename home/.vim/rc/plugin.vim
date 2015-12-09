scriptencoding utf-8
" vim-singleton {{{1
" ============================================================================
if IsInstalled('vim-singleton') && has('gui_running')
    call singleton#enable()
endif

" sudo.vim {{{1
" ==============================================================================
" sudo権限で保存する
" http://sanrinsha.lolipop.jp/blog/2012/01/sudo-vim.html
if IsInstalled('sudo.vim')
    if IsInstalled('bclose')
        nmap <Leader>E :e sudo:%<CR><C-^><Plug>Kwbd
    else
        nnoremap <Leader>E :e sudo:%<CR><C-^>:bd<CR>
    endif
    nnoremap <Leader>W :w sudo:%<CR>
endif

" vim-smartword {{{1
" ==============================================================================
if IsInstalled("vim-smartword")
    map w <Plug>(smartword-w)
    map b <Plug>(smartword-b)
    map e <Plug>(smartword-e)
    map ge <Plug>(smartword-ge)
endif

" unite.vim {{{1
" ============================================================================
if IsInstalled('unite.vim')
    let g:unite_data_directory = $VIM_CACHE_DIR.'/unite'
    let g:unite_enable_start_insert = 1
    " let g:unite_source_find_max_candidates = 1000

    nnoremap [unite] <Nop>
    nmap , [unite]

    call unite#custom#profile('default', 'context', {
    \   'start_insert': 1,
    \   'direction': 'topleft',
    \   'winheight': 10,
    \   'auto_resize': 1,
    \   'prompt': '> ',
    \ })

    " uniteの選択のカラーをPmenuSelにする。uniteバッファ以外もCursorLineの色がPmenuSelになってしまう
    " augroup MyVimrc
    "     autocmd Filetype unite hi! link CursorLine PmenuSel
    "     autocmd BufLeave \[unite\]* highlight! link CursorLine NONE
    " augroup END

    call unite#custom_default_action('directory' , 'vimfiler')
    " vimfiler上ではvimfilerを増やさず、移動するだけ
    " autocmd MyVimrc FileType vimfiler
    " \   call unite#custom_default_action('directory', 'lcd')

    call unite#custom_default_action('source/directory/directory' , 'vimfiler')
    call unite#custom_default_action('source/directory_mru/directory' , 'vimfiler')


    " dでファイルの削除
    call unite#custom#alias('file', 'delete', 'vimfiler__delete')
    call unite#custom#alias('directory', 'delete', 'vimfiler__delete')

    " uniteウィンドウを閉じる
    nmap <silent> [unite]q [Colon]<C-u>call GotoWin('\[unite\]')<CR><Plug>(unite_all_exit)
    nnoremap [unite], :<C-u>Unite -toggle<CR>

    " バッファ
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>

    " unite-mappingではnormalのマッピングしか出ないので、すべてのマッピングを出力するようにする
    " http://d.hatena.ne.jp/osyo-manga/20130307/1362621589
    nnoremap <silent> [unite]m :<C-u>Unite output:map<Bar>map!<Bar>lmap<CR>

    " ファイル内検索結果
    nnoremap <silent> [unite]l :<C-u>Unite line<CR>

    " unite.vim/directory {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリ以下のディレクトリ
    nnoremap [unite]d<CR> :<C-u>Unite directory<CR>
    nnoremap [unite]db :<C-u>Unite directory:$VIMDIR/bundle<CR>
    nnoremap [unite]dv :<C-u>Unite directory:$VIMDIR<CR>
    nnoremap [unite]dV :<C-u>Unite directory:$VIM<CR>
    nnoremap [unite]dd :<C-u>Unite directory:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>
    nnoremap [unite]da :<C-u>Unite directory:/Applications directory:$HOME/Applications<CR>

    " unite.vim/file {{{2
    " ------------------------------------------------------------------------
    " カレントディレクトリ以下のファイル
    nnoremap [unite]fc :<C-u>Unite file_rec/async<CR>

    " カレントバッファのディレクトリ以下のファイル
    nnoremap [unite]fb :<C-u>call <SID>unite_file_buffer()<CR>
    function! s:unite_file_buffer()
        if &filetype ==# 'vimfiler'
            normal gc
        endif
        let dir = expand('%:p:h')
        " windowsでドライブのC:をC\:に変更する必要がある
        execute 'Unite file_rec/async:' . escape(dir, ':')
    endfunction

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

    nnoremap [unite]fv :<C-u>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles/home/.vim<CR>
    nnoremap [unite]fd :<C-u>Unite file_rec/async:$SRC_ROOT/github.com/tmsanrinsha/dotfiles<CR>

    " memo {{{3
    " [unite-filters の converter を活用しよう - C++でゲームプログラミング](http://d.hatena.ne.jp/osyo-manga/20130919/1379602932)
    if !exists('g:memo_directory')
        let g:memo_directory = expand('~/Dropbox/memo/doc')
    endif
    let g:unite_source_alias_aliases = {
    \   'memo' : {
    \       'source' : 'file_rec/async',
    \       'args' : g:memo_directory,
    \   },
    \}
    call unite#custom#source('memo', 'sorters', ['sorter_ftime', 'sorter_reverse'])

    nnoremap [unite]fM :<C-u>Unite memo<CR>

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
    call unite#custom#profile('source/grep', 'context',
        \ {'no_quit' : 1})

    " カレントディレクトリに対してgrep
    nnoremap [unite]gc :<C-u>Unite grep:.<CR>
    " カレントバッファのディレクトリ以下に対してgrep
    nnoremap [unite]gb :<C-u>execute "Unite grep:".expand('%:p:h')<CR>
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
    nnoremap [unite]gs :<C-u>Unite grep:$SRC_ROOT<CR>
    "}}}

    "レジスタ一覧
    nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
    " ヤンク履歴
    let g:unite_source_history_yank_enable = 1  "history/yankの有効化
    nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
    " ブックマーク
    nnoremap <silent> [unite]B :<C-u>Unite bookmark<CR>
    call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

    nnoremap <silent> [unite]j :<C-u>Unite jump<CR>


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
    call unite#custom#action('file', 'args', s:args_action)

    " arglistにuniteで選択したファイルを追加する
    let s:argadd_action = {'description': 'argadd', 'is_selectable': 1}

    function! s:argadd_action.func(candidates)
        call s:set_arglist(a:candidates)
    endfunction
    call unite#custom#action('file', 'argadd', s:argadd_action)
endif

" neomru {{{1
" ============================================================================
if IsInstalled('neomru.vim')
    " ファイルが存在するかチェックしない
    " ファイルへの書き込みを60秒ごとにする
    let g:neomru#update_interval = 60
    let g:neomru#do_validate = 0
    call unite#custom#source(
    \'neomru/file', 'ignoer_pattern',
    \'\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
    \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
    \'\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
    \'\|\%(^\%(fugitive\)://\)'.
    \'\|/mnt/'
    \)

    "最近使用したファイル一覧
    nnoremap <silent> [unite]fm :<C-u>Unite file_mru<CR>
    "最近使用したディレクトリ一覧
    nnoremap <silent> [unite]dm :<C-u>Unite directory_mru<CR>
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
if IsInstalled('unite-outline')
    nnoremap [unite]oo :<C-u>Unite outline<CR>
    nnoremap [unite]of :<C-u>Unite outline:folding<CR>
    nnoremap [unite]O :<C-u>Unite -vertical -winwidth=40 -no-auto-resize -no-quit outline<CR>
    let bundle = neobundle#get('unite-outline')
    function! bundle.hooks.on_source(bundle)
        call unite#sources#outline#alias('ref-man', 'man')
        call unite#sources#outline#alias('tmux', 'conf')
        call unite#sources#outline#alias('vimperator', 'conf')
        call unite#sources#outline#alias('zsh', 'conf')
    endfunction
endif

autocmd MyVimrc FileType yaml
\   nnoremap <buffer> [unite]o :<C-u>Unite outline:folding<CR>

" tacroe/unite-mark {{{1
" =========================================================================
nnoremap [unite]` :<C-u>Unite mark<CR>

" neoyank.vim {{{1
" =========================================================================
if IsInstalled('neoyank.vim')
    nnoremap [unite]hy :<C-u>Unite history/yank<CR>
    let g:neoyank#file = $VIM_CACHE_DIR.'/yankring.txt'
endif

" vim-unite-history {{{1
" =========================================================================
if IsInstalled('vim-unite-history')
    nnoremap [unite]hc :<C-u>Unite history/command<CR>
    nnoremap [unite]hs :<C-u>Unite history/search<CR>
    cnoremap <M-r> :<C-u>Unite history/command -start-insert -default-action=edit<CR>
    inoremap <C-x>hc <C-o>:Unite history/command -start-insert -default-action=append<CR>a
endif

" unite-ghq {{{1
" =========================================================================
if IsInstalled('unite-ghq')
    nnoremap [unite]dg :<C-u>Unite ghq<CR>

    let bundle = neobundle#get("unite-ghq")
    function! bundle.hooks.on_source(bundle)
        call unite#custom_default_action('source/ghq/directory', 'vimfiler')
    endfunction
endif

" unite-zsh-cdr.vim {{{1
" =========================================================================
if IsInstalled('unite-zsh-cdr.vim')
    nnoremap [unite]dr :<C-u>Unite zsh-cdr<CR>

    let g:unite_zsh_cdr_chpwd_recent_dirs = g:recent_dirs_file
endif
" vimfiler {{{1
" ==============================================================================
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0

let g:vimfiler_data_directory = $VIM_CACHE_DIR.'/.vimfiler'

nnoremap [VIMFILER] <Nop>
nmap <Leader>f [VIMFILER]
nnoremap <silent> [VIMFILER]f :VimFiler<CR>
nnoremap <silent> [VIMFILER]b :VimFilerBufferDir<CR>
nnoremap <silent> [VIMFILER]c :VimFilerCurrentDir<CR>
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
"}}}
" vimshell {{{1
" ============================================================================
if IsInstalled('vimshell.vim')
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

    let bundle = neobundle#get('vimshell.vim')
    function! bundle.hooks.on_source(bundle)
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
endif

" Conque-Shell {{{1
" ============================================================================
if IsInstalled('Conque-Shell')
    " 現在のバッファのディレクトリでzshを立ち上げる
    noremap <Leader>C<CR> :ConqueTerm zsh<CR>
    noremap <Leader>Cb    :cd %:h <bar> ConqueTerm zsh<CR>

    let g:neocomplete#lock_buffer_name_pattern = 'zsh -'

    let bundle = neobundle#get("Conque-Shell")
    function! bundle.hooks.on_source(bundle)
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
endif "}}}
" neocomplcache & neocomplete {{{
" ============================================================================
if IsInstalled('neocomplcache.vim') || IsInstalled('neocomplete.vim')
    if IsInstalled('neocomplete.vim')
        let bundle = neobundle#get('neocomplete.vim')
        let s:neocom = 'neocomplete'
        let s:neocom_ = 'neocomplete#'
    else
        let bundle = neobundle#get('neocomplcache.vim')
        let s:neocom = 'neocomplcache'
        let s:neocom_ = 'neocomplcache_'
    endif

    function! bundle.hooks.on_source(bundle)
        " Use neocomplcache.
        execute 'let g:'.s:neocom_.'enable_at_startup = 1'
        " Use smartcase.
        execute 'let g:'.s:neocom_.'enable_smart_case = 1'
        execute 'let g:'.s:neocom_.'enable_ignore_case = 1'
        " Use camel case completion.
        let g:neocomplcache_enable_camel_case_completion = 1
        " Use underbar completion.
        let g:neocomplcache_enable_underbar_completion = 1 " Deleted

        " smartcaseな補完にする
        let g:neocomplete#enable_camel_case = 0

        " Set minimum syntax keyword length.
        if IsInstalled('neocomplete.vim')
            let g:neocomplete#sources#syntax#min_syntax_length = 3
        else
            let g:neocomplcache_min_syntax_length = 3
        endif
        " for keyword
        let g:neocomplete#auto_completion_start_length = 2

        set pumheight=10
        " 補完候補取得に時間がかかったときにスキップ
        execute 'let g:'.s:neocom_.'skip_auto_completion_time = "0.1"'
        " let g:neocomplete#skip_auto_completion_time = '1'
        " 候補の数を増やす
        " execute 'let g:'.s:neocom_.'max_list = 3000'

        " execute 'let g:'.s:neocom_.'force_overwrite_completefunc = 1'

        " if !exists('g:neocomplete#same_filetypes')
        "   let g:neocomplete#same_filetypes = {}
        " endif
        " " In default, completes from all buffers.
        " let g:neocomplete#same_filetypes._ = '_'

        " previewしない
        set completeopt-=preview
        if MyHasPatch('patch-7.4.775')
            " insert,selectしない
            set completeopt+=noinsert,noselect
        endif

        execute 'let g:'.s:neocom_.'enable_auto_close_preview=0'
        " fugitiveのバッファも閉じてしまうのでコメントアウト
        " autocmd MyVimrc InsertLeave *.* pclose

        let g:neocomplcache_enable_auto_delimiter = 0

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

        if !exists('g:neocomplcache_sources_list')
          let g:neocomplcache_sources_list = {}
        endif
        " shawncplus/phpcomplete.vimで補完されるため、syntaxはいらない
        let g:neocomplcache_sources_list.php  = ['tags_complete', 'snippets_complete', 'dictionary_complete', 'omni_complete', 'member_complete', 'include_complete', 'buffer_complete', 'filename_complete', 'filename_include']

        " 補完候補の順番
        if IsInstalled('neocomplete.vim')
            " defaultの値は ~/.vim/bundle/neocomplete.vim/autoload/neocomplete/sources/ 以下で確認
            " ファイル名補完
            call neocomplete#custom#source('file',         'rank', 450)
            call neocomplete#custom#source('neosnippet',   'rank', 440)
            call neocomplete#custom#source('member',       'rank', 430)
            call neocomplete#custom#source('omni',         'rank', 420)
            call neocomplete#custom#source('buffer',       'rank', 380)
            call neocomplete#custom#source('file/include', 'rank', 370)
            call neocomplete#custom#source('tag',          'rank', 360)
            call neocomplete#custom#source('syntax',       'rank', 300)
            " call neocomplete#custom#source('ultisnips',    'rank', 400)
        endif


        if IsInstalled('neocomplete.vim')
            let g:neocomplete#data_directory = $VIM_CACHE_DIR . '/neocomplete'
        else
            let g:neocomplcache_temporary_dir = $VIM_CACHE_DIR . '/neocomplcache'
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
            autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
            autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
        augroup END
        " let g:neocomplete#sources#omni#functions.sql =
        " \ 'sqlcomplete#Complete'

        " Enable heavy omni completion.
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif

        let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.php  = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
        let g:neocomplcache_omni_patterns.c    = '\%(\.\|->\)\h\w*'
        let g:neocomplcache_omni_patterns.cpp  = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

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

        " key mappings {{{
        execute 'inoremap <expr><C-g>  pumvisible() ? '.s:neocom.'#undo_completion() : "\<C-g>"'
        " execute 'inoremap <expr><C-l>  pumvisible() ? '.s:neocom.'#complete_common_string() : '.s:neocom.'#start_manual_complete()'
        execute 'inoremap <expr><C-l> ' . s:neocom.'#complete_common_string()'
        execute 'inoremap <expr><C-Space> '.s:neocom.'#start_manual_complete()'
        " execute 'inoremap <expr><C-Space> pumvisible() ? "\<C-n>" : '.s:neocom. '#start_manual_complete()'
        " inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-n>"

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

        " <TAB>: completion.
        inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<Tab>"
        " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        " \   <SID>check_back_space() ? "\<TAB>" :
        " \   neocomplete#start_manual_complete()
        " function! s:check_back_space() "{{{
        "     let col = col('.') - 1
        "     return !col || getline('.')[col - 1]  =~ '\s'
        " endfunction"}}}
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " execute 'inoremap <expr><C-e>  pumvisible() ? '.s:neocom.'#cancel_popup() : "\<C-e>"'
        inoremap <expr><C-g><C-g> neocomplete#cancel_popup()
        " <C-u>, <C-w>した文字列をアンドゥできるようにする
        " http://vim-users.jp/2009/10/hack81/
        " C-uでポップアップを消したいがうまくいかない
        execute 'inoremap <expr><C-u>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-u>" : "\<C-g>u<C-u>"'
        execute 'inoremap <expr><C-w>  pumvisible() ? '.s:neocom.'#smart_close_popup()."\<C-g>u<C-w>" : "\<C-g>u<C-w>"'

        " Vim - smartinput の <BS> や <CR> の汎用性を高める - Qiita {{{1
        " <http://qiita.com/todashuta@github/items/bdad8e28843bfb3cd8bf>
        " if IsInstalled('vim-smartinput')
        "     call smartinput#map_to_trigger('i', '<Plug>(smartinput_BS)',
        "           \                        '<BS>',
        "           \                        '<BS>')
        "     call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)',
        "           \                        '<BS>',
        "           \                        '<C-h>')
        "     call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)',
        "           \                        '<Enter>',
        "           \                        '<Enter>')
        "
        "     " <BS> でポップアップを閉じて文字を削除
        "     execute 'imap <expr> <BS> '
        "         \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_BS)"'
        "
        "     " <C-h> でポップアップを閉じて文字を削除
        "     execute 'imap <expr> <C-h> '
        "         \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_C-h)"'
        "
        "     " <CR> でポップアップ中の候補を選択し改行する
        "     " execute 'imap <expr> <CR> '
        "     "     \ . s:neocom . '#smart_close_popup() . "\<Plug>(smartinput_CR)"'
        "
        "     " <CR> でポップアップ中の候補を選択するだけで、改行はしないバージョン
        "     " ポップアップがないときには改行する
        "     " imap <expr> <CR> pumvisible() ?
        "     "     \ neocomplcache#close_popup() : "\<Plug>(smartinput_CR)"
        " else }}}

        " <BS>, <C-h> でポップアップを閉じて文字を削除。ポップアップを選択していたときはそれがキャンセルされた後に削除される。
        " 例) fuとタイプして、補完候補のfunctionを選択していた時に<BS>するとfになる
        " lexima.vimと競合するのでコメントアウト
        " execute 'inoremap <expr><BS>  pumvisible() ? ' . s:neocom . '#smart_close_popup()."\<BS>"  : "\<BS>"'
        " execute 'inoremap <expr><C-h> pumvisible() ? ' . s:neocom . '#smart_close_popup()."\<C-h>" : "\<C-h>"'

        " <CR> でポップアップ中の候補を選択し改行する
        " execute 'inoremap <expr><CR> ' . s:neocom . '#close_popup()."\<CR>"'

        " これをやるとコピペに改行があるときにポップアップが選択されてしまう
        " 補完候補が表示されている場合は確定。そうでない場合は改行
        " execute 'inoremap <expr><CR>  pumvisible() ? ' . s:neocom . '#close_popup() : "<CR>"'

        " execute 'let g:'.s:neocom_.'enable_auto_select = 1'
        " endif
        " }}}
    endfunction
endif
if IsInstalled('neocomplete.vim')
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

    inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
    " inoremap <expr><C-x><C-n>  neocomplete#start_manual_complete('buffer')
    imap  <C-x>u <Plug>(neocomplete_start_unite_complete)
    " imap  <C-x>u <Plug>(neocomplete_start_unite_quick_match)
endif

" neosnippet {{{1
" ==============================================================================
if IsInstalled('neosnippet.vim')
    " Tell Neosnippet about the other snippets
    let g:neosnippet#snippets_directory= [
    \   '~/.vim/bundle/vim-snippets/snippets',
    \   '~/.vim/bundle/wmgraphviz.vim/snippets',
    \]

    let bundle = neobundle#get('neosnippet.vim')

    function! bundle.hooks.on_source(bundle)
        " Plugin key-mappings.
        imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)" :
        \   "\<C-o>D"
        smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)" :
        \   "\<C-o>D"
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=niv
        endif

        " Enable snipMate compatibility feature.
        let g:neosnippet#enable_snipmate_compatibility = 1

    endfunction
endif
" }}}
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

" lexima.vim {{{1
" ==============================================================================
if IsInstalled('lexima.vim')
    " reloadble
    let bundle = neobundle#get('lexima.vim')
    function! bundle.hooks.on_source(bundle)
    let g:lexima_no_default_rules = 1
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


    call lexima#add_rule({'char': '<CR>', 'at': '" \%#',  'input': '<BS><BS>'})

    " Markdownのリストでなんにも書いてない場合に開業した場合はリストを消す
    call lexima#add_rule({'char': '<CR>', 'at': '^\s*\*\s*\%#',  'input': '<BS><BS><CR>', 'filetype': 'markdown'})

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
endif

" vim-quickrun {{{1
" ============================================================================
if IsInstalled('vim-quickrun')
    nnoremap <Leader>r :QuickRun -mode n<CR>
    xnoremap <Leader>r :QuickRun -mode v<CR>

    " let bundle = neobundle#get('vim-quickrun')
    " function! bundle.hooks.on_source(bundle)
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
        \ 'hook/qfstatusline_update/enable_exit':      1,
        \ 'hook/qfstatusline_update/priority_exit':    2,
        \ 'hook/quickfix_status_enable/enable_exit':   1,
        \ 'hook/quickfix_status_enable/priority_exit': 2,
        \}

        " PHP {{{2
        " --------------------------------------------------------------------
        " see ../after/ftplugin/php.vim

        " composer.json {{{3
        let g:quickrun_config['composer.json'] = {
        \ 'hook/cd/directory' : '%S:p:h',
        \ 'command'           : 'composer',
        \ 'cmdopt'            : '',
        \ 'exec'              : '%c %a',
        \}

        " dot {{{2
        " --------------------------------------------------------------------
        let g:quickrun_config['dot'] = {
        \ 'hook/cd/directory'              : '%S:p:h',
        \ 'command'                        : 'dot',
        \ 'cmdopt'                         : '',
        \ 'exec'                           : ['%c -Tpng %s -o %s:r.png', 'open %s:r.png'],
        \ 'outputter/quickfix/errorformat' : 'Error: %f: %m in line %l %.%#,%EError: %m,%C%m,%Z%m'
        \}

        " Android Dev {{{2
        " --------------------------------------------------------------------
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
        " endfunction

        command! QuickRunAndroidProject call s:QuickRunAndroidProject()
        autocmd MyVimrc BufRead,BufNewFile */workspace/* nnoremap <buffer> <Leader>r :QuickRunAndroidProject<CR>

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
    endfunction
endif
"}}}
" vim-watchdogs {{{1
" ============================================================================
if IsInstalled('vim-watchdogs')
    augroup WatchdogsSetting
        autocmd!
        autocmd BufWritePre *
        \   NeoBundleSource vim-watchdogs |
        \   autocmd! WatchdogsSetting
    augroup END

    let g:bundle = neobundle#get('vim-watchdogs')
    function! g:bundle.hooks.on_source(bundle)
        let g:watchdogs_check_BufWritePost_enable = 1

        if !exists('g:quickrun_config')
            let g:quickrun_config = {}
        endif

        let g:quickrun_config['watchdogs_checker/_'] = {
        \ 'hook/hier_update/enable_exit':              1,
        \ 'hook/hier_update/priority_exit':            2,
        \ 'hook/qfsigns_update/enable_exit':           1,
        \ 'hook/qfsigns_update/priority_exit':         2,
        \ 'hook/qfstatusline_update/enable_exit':      1,
        \ 'hook/qfstatusline_update/priority_exit':    2,
        \ 'hook/quickfix_status_enable/enable_exit':   1,
        \ 'hook/quickfix_status_enable/priority_exit': 2,
        \}

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

        " sh {{{2
        " ------------------------------------------------------------------------
        " filetypeがshでも基本的にbashを使うので、bashでチェックする
        let g:quickrun_config["sh/watchdogs_checker"] = {
        \   "type": (executable("bash") ? "watchdogs_checker/bash" : "")
        \}

        let g:quickrun_config["watchdogs_checker/bash"] = {
        \   "command":     "bash",
        \   "exec":        "%c -n %o %s:p",
        \   "errorformat": '%f:\ line\ %l:%m',
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
if IsInstalled('vim-operator-user')

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
nmap [:space:]y "+y
xmap [:space:]y "+y
nmap [:space:]yy "+yy
nmap [:space:]Y "+y$

" vim-fakeclip {{{2
" ----------------------------------------------------------------------------
if IsInstalled('vim-fakeclip')
    " +clipboardでもfakeclipのキーマッピングを使う
    let g:fakeclip_provide_provide_key_mapping = 1
    " クリップボードコピーのコマンドにrfpbcopyを使う
    let g:fakeclip_write_clipboard_command = 'rfpbcopy'
endif

" textobj {{{1
" ============================================================================
if IsInstalled('vim-textobj-lastpat') && !MyHasPatch('patch-7.3.610')
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
" }}}
" CTRL-A, CTRL-X {{{1
" ============================================================================
" - の前に空白文字以外があれば <C-x> を、それ以外は <C-a> を呼ぶ {{{2
" ----------------------------------------------------------------------------
" Vm で特定の条件でのみ <C-a> でインクリメントしないようにする - Secret Garden(Instrumental)
" http://secret-garden.hatenablog.com/entry/2015/05/14/180752)
"
" -423  ←これは <C-a> される
" d-423 ←これは <C-x> される

if IsInstalled('vital-coaster')
    nnoremap <expr> <C-a> <SID>increment('\S-\d\+', "\<C-x>")
    nnoremap <expr> <C-x> <SID>decrement('\S-\d\+', "\<C-a>")

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
if IsInstalled('vim-asterisk')
    map *  <Plug>(asterisk-z*)
    " map #  <Plug>(asterisk-z#)
    map #  <Plug>(asterisk-gz#)
    " map g* <Plug>(asterisk-gz*)
    " map g# <Plug>(asterisk-gz#)
    let g:asterisk#keeppos = 1
endif

" vim-easymotion {{{1
" ============================================================================
if IsInstalled('vim-easymotion')
    map ' <Plug>(easymotion-s2)
    " map ' <Plug>(easymotion-bd-jk)
    " map f <Plug>(easymotion-fl)
    " map t <Plug>(easymotion-tl)
    " map F <Plug>(easymotion-Fl)
    " map T <Plug>(easymotion-Tl)

    let bundle = neobundle#get('vim-easymotion')
    function! bundle.hooks.on_source(bundle)
        let g:EasyMotion_smartcase = 1
        let g:EasyMotion_keys = 'asdfgghjkl;:qwertyuiop@zxcvbnm,./1234567890-'
        let g:EasyMotion_do_mapping = 0
    endfunction
endif
"}}}
" vim-multiple-cursors {{{
" ============================================================================
if IsInstalled('vim-multiple-cursors')
    let g:multi_cursor_use_default_mapping = 0
    let g:multi_cursor_next_key='+'
    let g:multi_cursor_prev_key='-'
    let g:multi_cursor_skip_key='&'
    let g:multi_cursor_quit_key='<Esc>'
endif
" }}}
" vim-ref {{{1
" ============================================================================
if IsInstalled('vim-ref')
    cabbrev man Ref man

    let bundle = neobundle#get("vim-ref")
    function! bundle.hooks.on_source(bundle)
        if has('mac')
            let g:ref_man_cmd = "man -P cat"
        endif
        " command! -nargs=* Man Ref man <args>
    endfunction
endif

" vim-partedit {{{1
" ============================================================================
if IsInstalled('vim-partedit')
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
"}}}
" vim-visualstar {{{1
" ==============================================================================
" if IsInstalled('vim-visualstar')
"     map * <Plug>(visualstar-*)N
"     map # <Plug>(visualstar-g*)N
" endif

" vim-alignta {{{1
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
" LeafCage/yankround.vim {{{1
" ============================================================================
nnoremap <C-p> gT
nnoremap <C-n> gt

if IsInstalled('yankround.vim') && v:version >= 703
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
if IsInstalled('vim-gf-user')
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
if IsInstalled('caw.vim')
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
if IsInstalled('tcomment_vim')
    " コメントアウトしてコピー
    nmap <C-_>y yyP<Plug>TComment_<C-_><C-_>j
    xmap <C-_>y ygv<Plug>TComment_<C-_><C-_>gv<C-c>p

    let g:tcommentTextObjectInlineComment = ''
endif

" vim-jsbeautify {{{
" ==============================================================================
if IsInstalled('vim-jsbeautify')
    autocmd MyVimrc FileType javascript setlocal formatexpr=JsBeautify()
    autocmd MyVimrc FileType css        setlocal formatexpr=CSSBeautify()
    autocmd MyVimrc FileType html       setlocal formatexpr=HtmlBeautify()
else
    autocmd MyVimrc FileType html
        \   nnoremap <buffer> gq :%s/></>\r</ge<CR>gg=G
        \|  xnoremap <buffer> gq  :s/></>\r</ge<CR>gg=G
endif

if executable('xmllint')
    " formatexprの方が優先されるので、消しておく必要がある
    autocmd MyVimrc FileType xml
    \   setlocal formatprg=xmllint\ --format\ --encode\ utf-8\ -
    \|  setlocal formatexpr=
else
    autocmd MyVimrc FileType xml
    \   nnoremap <buffer> gq :%s/></>\r</ge<CR>gg=G
    \|  xnoremap <buffer> gq  :s/></>\r</ge<CR>gg=G
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

if IsInstalled('foldCC')
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
if IsInstalled('Kwbd.vim')
    nmap <Leader>bd <Plug>Kwbd
endif

" savevers.vim {{{1
" ============================================================================
set backup
set patchmode=.bak
set backupdir=$VIM_CACHE_DIR/savevers
execute "set backupskip+=*" . &patchmode
execute "set suffixes+=" . &patchmode

let g:versdiff_no_resize = 0

autocmd MyVimrc BufEnter * call s:updateSaveversDirs()
function! s:updateSaveversDirs()
    let s:basedir = $VIM_CACHE_DIR . "/savevers"
    " ドライブ名を変更して、連結する (e.g. C: -> /C/)
    let g:savevers_dirs = s:basedir . substitute(expand("%:p:h"), '\v\c^([a-z]):', '/\1/' , '')
endfunction

function! s:existOrMakeSaveversDirs()
    if !isdirectory(g:savevers_dirs)
        call mkdir(g:savevers_dirs, "p")
    endif
endfunction

autocmd MyVimrc BufWrite * call s:updateSaveversDirs() | call s:existOrMakeSaveversDirs()

" PreserveNoEOL {{{1
" ============================================================================
let g:PreserveNoEOL = 1

" detectindent {{{1
" ============================================================================
if IsInstalled('detectindent')
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
" vimdiffでより賢いアルゴリズム (patience, histogram) を使う - Qiita {{{2
" http://qiita.com/takaakikasai/items/3d4f8a4867364a46dfa3
" https://github.com/fumiyas/home-commands/blob/master/git-diff-normal
let s:git_diff_normal="git-diff-normal"
" let s:git_diff_normal_opts=["--diff-algorithm=histogram"]
" gitのバージョンが1.7だと--diff-algorithmが使えなかった
let s:git_diff_normal_opts=["--patience"]

function! GitDiffNormal()
    let args=[s:git_diff_normal]
    if &diffopt =~ "iwhite"
        call add(args, "--ignore-all-space")
    endif
    call extend(args, s:git_diff_normal_opts)
    call extend(args, [v:fname_in, v:fname_new])
    let cmd=join(args, " ") . ">" . v:fname_out
    call system(cmd)
endfunction

autocmd MyVimrc FilterWritePre *
\   if &diff && !exists('g:my_check_diff')
\|      if executable(s:git_diff_normal) && executable('git')
\|          set diffexpr=GitDiffNormal()
\|      endif
\|      let g:my_check_diff = 1
\|  endif

" scrooloose/syntastic {{{1
" ============================================================================
if IsInstalled('syntastic')
    autocmd MyVimrc BufWrite * NeoBundleSource syntastic
    let g:syntastic_mode_map = {
        \   'mode': 'active',
        \   'passive_filetypes': ['vim']
        \}
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_sh_checkers = ['']
endif
" }}}
" eclim {{{
" ============================================================================
if IsInstalled('eclim')

    " エラーのマークがずれる場合はエンコーディングが間違っている
    " http://eclim.org/faq.html#code-validation-signs-are-showing-up-on-the-wrong-lines
    let bundle = neobundle#get("eclim")

    function! bundle.hooks.on_source(bundle)
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
endif
" }}}
" phpcomplete.vim {{{1
" ============================================================================
let g:phpcomplete_enhance_jump_to_definition = 1
" let g:phpcomplete_mappings = {
"    \ 'jump_to_def': '<C-]>',
"    \ 'jump_to_def_split': '<C-W><C-]>',
"    \ 'jump_to_def_vsplit': '<C-W><C-\>',
"    \}

" Python, jedi-vim {{{1
" ============================================================================
" pythonのsys.pathの設定 " {{{
" [VimのPythonインターフェースのパスの問題を解消する - Qiita](http://qiita.com/tmsanrinsha/items/cfa3808b8d0cc915cd75)
" python2は$PYTHON_DLLを設定しなくてもうまくいく
if filereadable('/usr/local/Frameworks/Python.framework/Python')
    let $PYTHON_DLL = '/usr/local/Frameworks/Python.framework/Python'
endif

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

if IsInstalled('jedi-vim')
    let bundle = neobundle#get('jedi-vim')
    function! bundle.hooks.on_source(bundle)
        call s:set_python_path()

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
    endfunction
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

if IsInstalled('vim-marching')
    let bundle = neobundle#get("vim-marching")
    function! bundle.hooks.on_source(bundle)
        autocmd MyVimrc FileType python setlocal omnifunc=jedi#completions
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
endif

if IsInstalled('vim-cpp-auto-include')
    autocmd MyVimrc BufWritePre *.cpp :ruby CppAutoInclude::process
endif

" R lang, jcfaria/Vim-R-plugin {{{1
" ============================================================================
autocmd MyVimrc FileType r
\   nmap <buffer> <LocalLeader>ss <Plug>RSendLine
\|  vmap <buffer> <LocalLeader>s <Plug>RSendSelection
\|  imap <M-CR> <Esc><Plug>RSendLineo

" _で->などのマッピングをしない
let vimrplugin_assign = 0

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

if IsInstalled('neocomplete.vim')
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

" vimconsole.vim {{{1
" ==============================================================================
if IsInstalled('vimconsole.vim')
    let g:vimconsole#auto_redraw = 1
    augroup MyVimrc
        autocmd FileType vim,vimconsole
                    \    nnoremap <buffer> <F12> :VimConsoleToggle<CR>
                    \ |  nnoremap <buffer> <C-l> :VimConsoleClear<CR>
    augroup END
    let g:vimconsole#maximum_caching_objects_count = 100
endif
" }}}
" instant-markdown-vim {{{
" ============================================================================
" let g:instant_markdown_slow = 1
" let g:instant_markdown_autostart = 0
" autocmd MyVimrc FileType markdown nnoremap <buffer> <Leader>r :InstantMarkdownPreview<CR>
" }}}
" Git {{{1
" ============================================================================
" vim-fugitive {{{2
" ----------------------------------------------------------------------------
if IsInstalled('vim-fugitive')

    nnoremap [fugitive] <Nop>
    nmap <Leader>g [fugitive]
    nnoremap [fugitive]a   :Gwrite<CR>
    nnoremap [fugitive]ci  :Gcommit<CR>
    nnoremap [fugitive]co  :Git checkout %<CR>
    nnoremap [fugitive]d   :Gdiff<CR>
    nnoremap [fugitive]s   :Gstatus<CR>
    nnoremap [fugitive]l   :Glog<CR>
    nnoremap [fugitive]ps  :Git push
    nnoremap [fugitive]pso :Git push origin
    nnoremap [fugitive]pl  :Git pull --rebase origin master
    nnoremap [fugitive]fo  :Git fetch origin<CR>
    nnoremap [fugitive]for :Git fetch origin<CR>:Git rebase origin/master<CR>

    nnoremap [fugitive]2 :diffget //2 <Bar> diffupdate\<CR>
    nnoremap [fugitive]3 :diffget //3 <Bar> diffupdate\<CR>

    " Gbrowse ではgit config --global web.browserの値は見てない
    " ~/.vim/bundle/vim-fugitive/plugin/fugitive.vim
    if !has('gui_running')
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
if IsInstalled('gitv')
    let bundle = neobundle#get('gitv')

    function! bundle.hooks.on_source(bundle)
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
endif

" open-browser.vim {{{1
" ============================================================================
if IsInstalled('open-browser.vim')
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

    let bundle = neobundle#get('open-browser.vim')
    function! bundle.hooks.on_source(bundle)
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
    \           ['syntaxcheck', 'lineinfo'],
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
    \   'component_function': {
    \       'mode': 'lightline#mode',
    \       'fugitive': 'MyFugitive',
    \       'filename': 'MyFilename',
    \       'fileformat': 'MyFileformat',
    \       'filetype': 'MyFiletype',
    \       'fileencoding': 'MyFileencoding',
    \       'anzu': 'anzu#search_status',
    \       'currenttag': 'MyCurrentTag',
    \   },
    \   'separator': { 'left': '', 'right': '' },
    \   'subseparator': { 'left': '|', 'right': '|' },
    \   'mode_map': {
    \       'n' : 'N',
    \       'i' : 'I',
    \       'R' : 'R',
    \       'v' : 'V',
    \       'V' : 'VL',
    \       'c' : 'C',
    \       "\<C-v>": 'VB',
    \       's' : 'S',
    \       'S' : 'SL',
    \       "\<C-s>": 'SB',
    \       '?': '' }
    \}
    " \   'component_expand': {
    " \       'syntaxcheck': 'qfstatusline#Update',
    " \   },
    " \   'component_type': {
    " \       'syntaxcheck': 'error',
    " \   },

" :WatchdogsRun後にlightline.vimを更新
let g:Qfstatusline#UpdateCmd = function('lightline#update')

" 資料
" vim-qfstatusline を作ってみた - mabulog
" http://kazuomabuo.hatenablog.jp/entry/2014/06/11/211947

" 途中で色変更をするとInsert modeがおかしくなる
" autocmd MyVimrc ColorScheme *
"     \   hi User1 ctermfg=red guifg=red

function! MyModified()
  return &ft =~ 'help\|qf\|gitcommit\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
    return (
    \   &ft == 'vimfiler' ? vimfiler#get_status_string() :
    \   &ft == 'unite' ? unite#get_status_string() :
    \   &ft == 'vimshell' ? vimshell#get_status_string() :
    \   &ft == 'help' ? expand('%:t') :
    \   &ft == 'qf' ? '' :
    \   &ft == 'gitcommit' ? '' :
    \   '' != expand('%:~:.') ? expand('%:~:.') : '[No Name]'
    \) .
    \('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head())
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
  return winwidth(0) > 50 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyCurrentTag()
  " return tagbar#currenttag('%s', '')
  return ''
endfunction

" vim-quickhl {{{1
" ============================================================================
nmap [:space:]m <Plug>(quickhl-manual-this)
xmap [:space:]m <Plug>(quickhl-manual-this)
nmap [:space:]M <Plug>(quickhl-manual-reset)
xmap [:space:]M <Plug>(quickhl-manual-reset)

" rainbow {{{1
" ============================================================================
if IsInstalled("rainbow")
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
endif " }}}
" junkfile.vim {{{1
" ============================================================================
if IsInstalled('junkfile.vim')
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

" vimwiki {{{1
" ============================================================================
if IsInstalled('vimwiki')

    nmap <Leader>ww  <Plug>VimwikiIndex
    nmap <Leader>w<Leader>d  <Plug>VimwikiDiaryIndex
    nmap <Leader>wn  <Plug>VimwikiMakeDiaryNote
    nmap <Leader>wu  <Plug>VimwikiDiaryGenerateLinks

    let bundle = neobundle#get('vimwiki')
    function! bundle.hooks.on_source(bundle)
        let g:vimwiki_list = [{
            \   'path': '~/Dropbox/vimwiki/wiki/', 'path_html': '~/Dropbox/vimwiki/public_html/',
            \   'syntax': 'markdown', 'ext': '.txt'
            \}]

    endfunction
endif

" memoliset.vim {{{1
" ============================================================================
if IsInstalled('memolist.vim')
    " call neobundle#config('memolist.vim', {
    "     \   'autoload': {
    "     \       'commands': ['MemoNew', 'MemoList', 'MemoGrep']
    "     \   }
    "     \})

    nnoremap <Leader>mn  :MemoNew<CR>
    nnoremap <Leader>ml  :MemoList<CR>
    nnoremap <Leader>mg  :MemoGrep<CR>

    let g:memolist_path = expand('~/Dropbox/memo')

    let bundle = neobundle#get('memolist.vim')
    function! bundle.hooks.on_source(bundle)
        let g:memolist_memo_suffix = "txt"
        let g:memolist_unite = 1
    endfunction
endif
" }}}
" vimrepress {{{
" ============================================================================
if IsInstalled('vimrepress')
    " call neobundle#config('vimrepress', {
    "     \   'autoload' : {
    "     \       'commands' : [
    "     \           'BlogList', 'BlogNew', 'BlogSave', 'BlogPreview'
    "     \       ]
    "     \   },
    "     \})
endif
" }}}
" qfixhowm {{{
" ==============================================================================
if IsInstalled('qfixhowm')

    let bundle = neobundle#get("qfixhowm")
    function! bundle.hooks.on_source(bundle)
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
endif
" }}}
if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    " hookの設定より下に書かないとだめ
    call neobundle#call_hook('on_source')
endif
