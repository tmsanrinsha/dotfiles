scriptencoding utf-8
" 使わなくなった設定

" savevers.vim {{{2
" ----------------------------------------------------------------------------
if  IsInstalled('savevers.vim')
    set backup
    " pathmodeを設定するとbackupdirで設定されたディレクトリではなく、
    " 保存したファイルがあるディレクトリにファイルが作成される
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
endif

" eclim {{{2
if IsInstalled('eclim')

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

" scrooloose/syntastic {{{2
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

" vimwiki {{{2
if IsInstalled('vimwiki')

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
if IsInstalled('qfixhowm')
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
