scriptencoding utf-8

if &compatible
  set nocompatible
endif

let s:dein_dir = g:dein_dir
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければgit clone
if !isdirectory(s:dein_repo_dir)
    if !executable('git')
        echomsg 'git not found'
    else
        echo 'git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir
        echo system('git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir)
    endif
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#add('Shougo/neocomplete')
    call dein#add('Shougo/neosnippet')
    call dein#add('Shougo/neosnippet-snippets')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on

let g:dein#install_process_timeout = 1200

" vimprocは先にインストールする
if dein#check_install(['vimproc.vim'])
    if !executable('cc')
        echomsg 'cc not found'
    else
        call dein#install(['vimproc.vim'])
    endif
endif

if dein#check_install()
    " vimがサイレンスモード(-s)で起動した場合はデフォルトのNoが選ばれる
    " これによってcall dein#install()した後にdein#update()するという
    " 無駄な処理を行わずにすむ
    if confirm('Install bundles now?', "yes\nNo", 2) == 1
        call dein#install()
    endif
endif
