if exists('b:did_my_after_ftplugin_html')
  finish
endif
let b:did_my_after_ftplugin_html = 1

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . ' | ' : '')
\ . 'setlocal includeexpr< path<'

runtime macros/matchit.vim "HTML tag match

" gf(goto file)の設定 {{{1
" ============================================================================
" http://sanrinsha.lolipop.jp/blog/2012/01/vim%E3%81%AEgf%E3%82%92%E6%94%B9%E8%89%AF%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B.html
setlocal includeexpr=substitute(v:fname,'^\\/','','')
setlocal path&
setlocal path+=./;/

" HTML Key Mappings for Typing Character Codes: {{{1
" ============================================================================
" * http://www.stripey.com/vim/html.html
" * https://github.com/sigwyg/dotfiles/blob/8c70c4032ebad90a8d92b76b1c5d732f28559e40/.vimrc
"
" |--------------------------------------------------------------------
" |Keys     |Insert   |For  |Comment
" |---------|---------|-----|-------------------------------------------
" |\&       |&amp;    |&    |ampersand
" |\<       |&lt;     |<    |less-than sign
" |\>       |&gt;     |>    |greater-than sign
" |\.       |&middot; |・   |middle dot (decimal point)
" |\?       |&#8212;  |?    |em-dash
" |\2       |&#8220;  |“   |open curved double quote
" |\"       |&#8221;  |”   |close curved double quote
" |\`       |&#8216;  |‘   |open curved single quote
" |\'       |&#8217;  |’   |close curved single quote (apostrophe)
" |\`       |`        |`    |OS-dependent open single quote
" |\'       |'        |'    |OS-dependent close or vertical single quote
" |\<Space> |&nbsp;   |     |non-breaking space
" |---------------------------------------------------------------------
inoremap <buffer> \\ \
inoremap <buffer> \& &amp;
inoremap <buffer> \< &lt;
inoremap <buffer> \> &gt;
inoremap <buffer> \. ・
inoremap <buffer> \- &#8212;
inoremap <buffer> \<Space> &nbsp;
inoremap <buffer> \` &#8216;
inoremap <buffer> \' &#8217;
inoremap <buffer> \2 &#8220;
inoremap <buffer> \" &#8221;
