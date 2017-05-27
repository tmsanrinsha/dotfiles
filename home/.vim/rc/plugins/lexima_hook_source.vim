scriptencoding utf-8

let g:lexima_no_default_rules = 1
call lexima#set_default_rules()

" let g:lexima_enable_basic_rules = 0
" let g:lexima_enable_newline_rules = 1
let g:lexima_enable_space_rules = 0
let g:lexima_enable_endwise_rules = 1


" <C-h>でlexima.vimの<BS>の動きをさせる
imap <C-h> <BS>

" <C-f>で右に移動
imap <C-f> <Right>
call lexima#add_rule({'char': '<Right>', 'leave': 1})

" dot repeatableな<C-d>。lexima.vimによって追加された文字以外は消してくれないので、コメント
" call lexima#add_rule({'char': '<C-d>', 'delete': 1})
inoremap <C-d> <Del>

" 右側が単語を構成する文字の時は補完をしない
call lexima#add_rule({'char': '(', 'at': '\%#.*\k'})
call lexima#add_rule({'char': ')', 'at': '\%#.*\k'})
call lexima#add_rule({'char': '{', 'at': '\%#.*\k'})
call lexima#add_rule({'char': '}', 'at': '\%#.*\k'})
call lexima#add_rule({'char': '[', 'at': '\%#.*\k'})
call lexima#add_rule({'char': ']', 'at': '\%#.*\k'})
call lexima#add_rule({'char': "'", 'at': '\%#.*\k'})
call lexima#add_rule({'char': '"', 'at': '\%#.*\k'})

" ```で補完させない
call lexima#add_rule({'char': '`', 'at': '``\%#'})

" matchparisで設定したもの(「,」:（,）など)をルールに追加
for s:val in split(&matchpairs, ',')
    if s:val ==# '<:>'
        continue
    endif
    let s:val = escape(s:val, '[]')
    let s:pair = split(s:val, ':')
    call lexima#add_rule({'char': s:pair[0], 'input_after': s:pair[1], 'except': '\%#\S'})
    call lexima#add_rule({'char': s:pair[1], 'at': '\%#'.s:pair[1], 'leave': 1})
    call lexima#add_rule({'char': '<BS>', 'at': s:pair[0].'\%#'.s:pair[1], 'delete': 1})
endfor

call lexima#add_rule({'char': '<CR>', 'at': '" \%#',  'input': '<BS><BS>'})

" Markdownのリストでなんにも書いてない場合に改行した場合はリストを消す {{{2
" ----------------------------------------------------------------------------
for s:val in ['-', '\*', '+', '1.']
    call lexima#add_rule({'char': '<CR>', 'at': '^\s*'.s:val.'\s*\%#',  'input': '<C-u>', 'filetype': 'markdown'})
    call lexima#add_rule({'char': '<CR>', 'at': '^\s*'.s:val.'\s*\%#',  'input': '<Esc>0Di', 'filetype': 'rmd'})
endfor

" Vim script {{{2
" --------------------------------------------------------------------
" Vim scriptで以下のようなインデントをする
" NeoBundleLazy "cohama/lexima.vim", {
" \   "autoload": {
" \       "insert": 1
" \   }
" \}

if &l:shiftwidth == 0
    let s:indent = &l:tabstop
else
    let s:indent = &l:shiftwidth
endif

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

" endwise {{{1
" ============================================================================
let s:cr_key = '<CR>'

function! s:make_rule(at, end, filetype, syntax)
  return {
  \ 'char': '<CR>',
  \ 'input': s:cr_key,
  \ 'input_after': '<CR>' . a:end,
  \ 'at': a:at,
  \ 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1' . a:end,
  \ 'filetype': a:filetype,
  \ 'syntax': a:syntax,
  \ }
endfunction

call lexima#add_rule(s:make_rule('^```.*\%#', '```', 'markdown', []))

" ruby.chef {{{1
" ----------------------------------------------------------------------------
call lexima#add_rule(s:make_rule('^\s*\%(module\|def\|class\|if\|unless\|for\|while\|until\|case\)\>\%(.*[^.:@$]\<end\>\)\@!.*\%#', 'end', 'ruby.chef', []))
call lexima#add_rule(s:make_rule('^\s*\%(begin\)\s*\%#', 'end', 'ruby.chef', []))
call lexima#add_rule(s:make_rule('\%(^\s*#.*\)\@<!do\%(\s*|.*|\)\?\s*\%#', 'end', 'ruby.chef', []))
call lexima#add_rule(s:make_rule('\<\%(if\|unless\)\>.*\%#', 'end', 'ruby.chef', 'rubyConditionalExpression'))

" expand {{{1
" ----------------------------------------------------------------------------
iunmap \[
iunmap \]

" neocomplete.vimとの連携 {{{1
" ============================================================================
" これで出来そう
" inoremap <expr> <CR> someCondition() ? '' : lexima#expand('<CR>', 'i')
