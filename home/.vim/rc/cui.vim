" key setting {{{1
" ============================================================================
if v:version > 701
    " :h terminal-info
    " cuiのvimでaltを使う設定 {{{2
    " ------------------------------------------------------------------------
    " https://github.com/cpfaff/vim-my-setup/blob/master/vimrc
    for i in range(32,126)
        let c = nr2char(i)
        if c=='|' || c=='"'
            exec "set <M-\\".c.">=\<Esc>\\".c
        elseif c==' ' || c==':' || c=='>' || c==#'P' || c=='['
            "set <M-Space>=\<Esc>\<Space> 他のsetに影響する?
            "set <M-\>>=\<Esc>> <M->>に対してsetできない
            "set <M-:>はインサートモードから抜けて、コマンド打つときに引っかかる
            "set <M-P>=\<Esc>P  \ePは制御シーケンスで使用するためsetしない
            "set <M-[>=\<Esc>[  これがあるとvim起動した後、2cが打たれる
        else
            exec "set <M-".c.">=\<Esc>".c
        endif
    endfor

    " <C-Tab><S-C-Tab>など、ターミナル上で定義されていないキーを設定するためのトリック {{{2
    " ------------------------------------------------------------------------
    " :h t_ku以下にないものは以下で定義
    " http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    " MapFastKeycode: helper for fast keycode mappings
    " makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
    function! <SID>MapFastKeycode(key, keycode)
        if s:fast_i == 46
            echohl WarningMsg
            echomsg "Unable to map ".a:key.": out of spare keycodes"
            echohl None
            return
        endif
        let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
        exec 'set '.vkeycode.'='.a:keycode
        exec 'map '.vkeycode.' '.a:key
        let s:fast_i += 1
    endfunction
    let s:fast_i = 0

    call <SID>MapFastKeycode('<C-Tab>', "[27;5;9~")
    call <SID>MapFastKeycode('<S-C-Tab>', "[27;6;9~")
endif

" 端末でCtrl+Spaceを打つと<NUL>(^@)が送られるのでmapしておく
map  <NUL> <C-Space>
map! <NUL> <C-Space>

set <S-Left>=[1;2D
set <S-Right>=[1;2C
set <S-Up>=[1;2A
set <S-Down>=[1;2B

" paste {{{1
" ==============================================================================
"Tera TermなどのBracketed Paste Modeをサポートした端末では
"以下の設定で、貼り付けるとき自動的にpasteモードに切り替えてくれる。
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
if v:version > 603
    if &term == "screen"
        " for tmux
        let &t_SI = "\ePtmux;\e\e[?2004h\e\\"
        let &t_EI = "\ePtmux;\e\e[?2004l\e\\"
        "for screen
        " let &t_SI = "\eP\e[?2004h\e\\"
        " let &t_EI = "\eP\e[?2004l\e\\"
    elseif &term == "xterm"
        " for xterm
        let &t_SI = "\e[?2004h"
        let &t_EI = "\e[?2004l"
    endif
    let &pastetoggle = "\e[201~"

    exec "set <F13>=\e[200~"
    inoremap <F13> <C-o>:set paste<CR>
endif
"}}}
" clipboard {{{
" ==============================================================================
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
function! s:Paste64Copy() range
    let l:tmp = @"
    silent normal gvy
    let l:selected = @"
    let @" = l:tmp
    let l:i = 0
    let l:len = strlen(l:selected)
    let l:escaped = ''
    while l:i < l:len
        let l:c = strpart(l:selected, l:i, 1)
        if char2nr(l:c) < 128
            let l:escaped .= printf("\\u%04x", char2nr(l:c))
        else
            let l:escaped .= l:c
        endif
        let l:i += 1
    endwhile
    call system('echo -en "' . l:escaped . '" | paste64.mac > /dev/tty')
endfunction

command! -range Paste64Copy :call s:Paste64Copy()

vnoremap <A-c> :Paste64Copy<CR>
" }}}
" mouse {{{
" ==============================================================================
" For screen, tmux
" if &term == "xterm-256color"
"     augroup MyAutoCmd
"         autocmd VimLeave * :set mouse=
"     augroup END
" 
"     " screenでマウスを使用するとフリーズするのでその対策
"     " Tere Termだと自動で認識されているかも
"     " http://slashdot.jp/journal/514186/vim-%E3%81%A7%E3%81%AE-xterm-%E3%81%AE%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%AE%E8%87%AA%E5%8B%95%E8%AA%8D%E8%AD%98
"     set ttymouse=xterm2
" endif
" Using the mouse on a terminal.
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632') " I couldn't use has('mouse_sgr') :-(
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif
"}}}
" カーソルの形状の変化 {{{
" ============================================================================
"http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html

"if &term == "xterm-256color" && v:version > 603
"    "let &t_SI .= "\eP\e[3 q\e\\"
"    let &t_SI .= "\eP\e[?25h\e[5 q\e\\"
"    let &t_EI .= "\eP\e[1 q\e\\"
"elseif &term == "xterm" && v:version > 603
"    "let &t_SI .= "\e[3 q"
"    let &t_SI .= "\e[?25h\e[5 q"
"    let &t_EI .= "\e[1 q"
"endif
" }}}
