scriptencoding utf-8
" key setting {{{1
" ============================================================================
if v:version > 701
    " :h terminal-info
    " cuiのvimでaltを使う設定 {{{2
    " ------------------------------------------------------------------------
    for i in range(32,126)
        let c = nr2char(i)
        if c ==# '|'
            exec "set <M-\\".c.">=\<Esc>\\".c
        elseif c ==# ' ' || c ==# ':' || c ==# '>' || c ==# 'P' || c ==# '[' || c ==# '"'
            "set <M-Space>=\<Esc>\<Space> 他のsetに影響する?
            "set <M-\>>=\<Esc>> <M->>に対してsetできない
            "set <M-:>はインサートモードから抜けて、コマンド打つときに引っかかる
            "set <M-P>=\<Esc>P  \ePは制御シーケンスで使用するためsetしない
            "set <M-[>=\<Esc>[  これがあるとvim起動した後、2cが打たれる
        else
            exec 'set <M-'.c.'>=\<Esc>'.c
        endif
    endfor
    exec 'set <M-CR>=\<Esc>\<CR>'
    exec 'set <M-C-h>=\<Esc>\<C-H>'
    exec 'set <M-C-?>=\<Esc>\<C-?>'

    " cuiのvimで<C-Space>を使う設定 {{{2
    " ------------------------------------------------------------------------
    " 端末でCtrl+Spaceを打つと<NUL>(^@)が送られるのでmapしておく
    imap  <NUL> <C-Space>
    cmap  <NUL> <C-Space>
    " map! <NUL> <C-Space>

    " cuiでShift+カーソルキーを使う設定{{{2
    " ------------------------------------------------------------------------
    " \<Esc>が使えない？
    " executeを書かないと、vintでひっかかる
    execute 'set <S-Left>=[1;2D'
    execute 'set <S-Right>=[1;2C'
    execute 'set <S-Up>=[1;2A'
    execute 'set <S-Down>=[1;2B'

    " <C-Tab><S-C-Tab>など、ターミナル上で定義されていないキーを設定するためのトリック {{{2
    " ------------------------------------------------------------------------
    " :h t_ku以下にないものは以下で定義
    " http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
    " MapFastKeycode: helper for fast keycode mappings
    " makes use of unused vim keycodes <[S-]F15> to <[S-]F37>
    function! <SID>MapFastKeycode(key, keycode)
        if s:fast_i == 46
            echohl WarningMsg
            echomsg 'Unable to map '.a:key.': out of spare keycodes'
            echohl None
            return
        endif
        let vkeycode = '<'.(s:fast_i/23==0 ? '' : 'S-').'F'.(15+s:fast_i%23).'>'
        exec 'set '.vkeycode.'='.a:keycode
        exec 'map '.vkeycode.' '.a:key
        let s:fast_i += 1
    endfunction
    let s:fast_i = 0

    call <SID>MapFastKeycode('<C-Tab>', '[27;5;9~')
    call <SID>MapFastKeycode('<S-C-Tab>', '[27;6;9~')
endif

" clipboard {{{1
" ==============================================================================
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
function! s:Paste64Copy() range
    let l:tmp = @"
    silent normal! gvy
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

" mouse {{{1
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
    " インサートモードではマウスを使わない
    set mouse=nvch
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632') " I couldn't use has('mouse_sgr') :-(
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" 制御シーケンス {{{1
" ==============================================================================
" アプリケーション側(Vim)からエスケープ(\e)で始まる特殊な文字列を送って端末を制御する事ができる
" 対応していない場合もあるので注意。
" 検証端末は主にiTerm2とTera Term
"
" tmux, screenなどのターミナルマルチプレクサ使用時にターミナルマルチプレクサが制御シーケンスに対応しておらず
" 制御シーケンスが端末まで届かないことがある。
" その場合、パススルーシーケンス
" tmuxだと"\ePtmux;\e"と"\e\\"
" screenだと'\eP'と"\e\\"
" で制御シーケンスを囲むことで、ターミナルマルチプレクサを素通りさせて端末まで届けることができる
" tmuxの場合だと制御シーケンス内の\eを\e\eで、\\を\\\\でエスケープする必要がある
"
" ターミナルマルチプレクサを使用しているかはここでは$TERMがscreenかで判断する
"
" 端末オプション (:help terminal-options)
" &t_SI: 挿入モード開始
" &t_EI: 挿入モード終了
"
" 以下を参考にして設定する
" * [vim からの制御シーケンスの使用例](http://ttssh2.sourceforge.jp/manual/ja/usage/tips/vim.html)

" 挿入モードでカーソルの形状を変更する {{{2
" ----------------------------------------------------------------------------
" [「vim からの制御シーケンスの使用例」をScreen上でも使えるようにする | SanRin舎](http://sanrinsha.lolipop.jp/blog/2011/11/%E3%80%8Cvim-%E3%81%8B%E3%82%89%E3%81%AE%E5%88%B6%E5%BE%A1%E3%82%B7%E3%83%BC%E3%82%B1%E3%83%B3%E3%82%B9%E3%81%AE%E4%BD%BF%E7%94%A8%E4%BE%8B%E3%80%8D%E3%82%92screen%E4%B8%8A%E3%81%A7%E3%82%82%E4%BD%BF.html)
if v:version > 603
    if &term =~? 'screen' || &term =~? 'xterm'
        " for tmux and xterm
        " let &t_SI .= "\e[5 q" 縦線点滅
        let &t_SI .= "\e[6 q" " 縦線点灯
        " let &t_EI .= "\e[1 q" " 箱型点滅
        let &t_EI .= "\e[2 q" " 箱型点灯

        " for screen
        " let &t_SI .= "\eP\e[3 q\e\\"
        " let &t_EI = "\eP\e[1 q\e\\"
    endif
endif

" paste {{{2
" ------------------------------------------------------------------------------
" Bracketed Paste Modeを利用して、クリップボードからの貼り付け時に
" 自動的にpasteモードに切り替え、終了後に戻す
" http://sanrinsha.lolipop.jp/blog/2013/01/10618.html
if v:version > 603
    if &term =~? 'screen'
        " for tmux >= 1.7
        let &t_SI = &t_SI."\e[?2004h"
        let &t_EI = "\e[?2004l".&t_EI
        " for tmux
        " let &t_SI = &t_SI."\ePtmux;\e\e[?2004h\e\\"
        " let &t_EI = "\ePtmux;\e\e[?2004l\e\\".&t_EI
        "for screen
        " let &t_SI = &t_SI."\eP\e[?2004h\e\\"
        " let &t_EI = "\eP\e[?2004l\e\\".&t_EI
    elseif &term =~? 'xterm'
        " for xterm
        let &t_SI = &t_SI."\e[?2004h"
        let &t_EI = "\e[?2004l".&t_EI
    endif
    let &pastetoggle = "\e[201~"

    exec "set <F13>=\e[200~"
    inoremap <F13> <C-O>:set paste<CR>
endif

" ウィンドウタイトルを保存・復元する {{{2
" ----------------------------------------------------------------------------
" tmuxを使っていると効果が無い
let &t_ti .= "\e[22;0t"
let &t_te .= "\e[23;0t"

" Use vsplit mode {{{2
" ----------------------------------------------------------------------------
" [20行でできる、端末版vimの縦分割スクロール高速化設定 - Qiita](http://qiita.com/kefir_/items/c725731d33de4d8fb096)
" if has("vim_starting") && !has('gui_running') && has('vertsplit')
"   function! g:EnableVsplitMode()
"     " enable origin mode and left/right margins
"     let &t_CS = "y"
"     let &t_ti = &t_ti . "\e[?6;69h"
"     let &t_te = "\e[?6;69l" . &t_te
"     let &t_CV = "\e[%i%p1%d;%p2%ds"
"     call writefile([ "\e[?6h\e[?69h" ], "/dev/tty", "a")
"   endfunction
"
"   " old vim does not ignore CPR
"   map <special> <Esc>[3;9R <Nop>
"
"   " new vim can't handle CPR with direct mapping
"   " map <expr> ^[[3;3R g:EnableVsplitMode()
"   execute "set t_F9=\<ESC>[3;3R"
"   map <expr> <t_F9> g:EnableVsplitMode()
"   let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
" endif
