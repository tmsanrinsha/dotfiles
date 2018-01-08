scriptencoding utf-8

if &compatible
  set nocompatible
endif

" dein.vim がなければgit clone
" if !isdirectory(s:dein_repo_dir)
"     if !executable('git')
"         echomsg 'git not found'
"     else
"         echo 'git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir
"         echo system('git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir)
"     endif
" endif

execute 'set runtimepath^=' . g:dein_repo_dir

if dein#load_state(g:dein_dir)
  call dein#begin(g:dein_dir)

  if EnableDeoplete()
    call dein#add('Shougo/deoplete.nvim', {
    \   'lazy': 1,
    \   'on_i': 1,
    \   'depends': [
    \     'FastFold',
    \     'neoinclude.vim',
    \     'neosnippet.vim',
    \     'vim-snippets'
    \   ],
    \   'hook_source': 'call SourceRc("plugins/deoplete_hook_source.vim")'
    \})
  elseif has('lua')
    call dein#add('Shougo/neocomplete.vim', {
    \   'lazy': 1,
    \   'on_i': 1,
    \   'depends': [
    \     'FastFold',
    \     'neoinclude.vim',
    \     'neosnippet.vim',
    \     'vim-snippets'
    \   ],
    \   'hook_source': 'call SourceRc("plugins/neocomplete_hook_source.vim")'
    \})
  endif

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

let g:dein#install_process_timeout = 1200
let g:dein#types#git#clone_depth = 1
let g:dein#install_max_processes = 4

if dein#check_install()
    " vimがサイレンスモード(-s)で起動した場合はデフォルトのNoが選ばれる
    " これによってcall dein#install()した後にdein#update()するという
    " 無駄な処理を行わずにすむ
    if confirm('Install bundles now?', "&yes\n&No", 2) == 1
        call dein#install()
    endif
endif

" repo以下のautoloadを保存したら.dein以下にコピーする {{{2
" ----------------------------------------------------------------------------
" dein.vimは.dein以下にautoloadをコピーし、それを使うので、pluginのデバック時に
" repo以下を編集・保存したら.dein以下にコピーするようにする
let s:sync_save_dir_list = [
\    {
\      'glob' : g:dein_dir . '/repos/**/autoload/**/*.vim',
\      'from' : g:dein_dir . '/repos/.*/autoload',
\      'to'   : g:dein_dir . '/.cache/.vimrc/.dein/autoload',
\    },
\    {
\      'glob' : g:dein_dir . '/repos/**/colors/*.vim',
\      'from' : g:dein_dir . '/repos/.*/colors',
\      'to'   : g:dein_dir . '/.cache/.vimrc/.dein/colors',
\    },
\    {
\      'glob' : g:dein_dir . '/repos/**/ftplugin/**/*.vim',
\      'from' : g:dein_dir . '/repos/.*/ftplugin',
\      'to'   : g:dein_dir . '/.cache/.vimrc/.dein/ftplugin',
\    },
\    {
\      'glob' : g:dein_dir . '/repos/**/indent/*.vim',
\      'from' : g:dein_dir . '/repos/.*/indent',
\      'to'   : g:dein_dir . '/.cache/.vimrc/.dein/indent',
\    },
\]

" windowsのときはうまくいかない
if $OS !~ 'Windows_NT'
  call SetAutocmdSyncSaveDir(s:sync_save_dir_list)
endif
