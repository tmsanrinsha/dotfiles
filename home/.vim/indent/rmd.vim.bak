" $VIMRUNTIME/indent/rmd.vimのはmarkdownのlistのインデントが行けないので修正
" Vim indent file
" Language:	Rmd
" Author:	Jakson Alves de Aquino <jalvesaq@gmail.com>
" Last Change:	Thu Jul 10, 2014  07:11PM


" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
runtime indent/r.vim

" ---- 追加 ----
" 複数あるときまずい
" execute 'source '.globpath(&runtimepath, 'indent/markdown.vim')
" " Automatically insert bullets
" setlocal formatoptions+=r
" " Do not automatically insert bullets when auto-wrapping with text-width
" setlocal formatoptions-=c
" " Accept various markers as bullets
" setlocal comments=b:*,b:+,b:-,b:1.
"
" " Automatically continue blockquote on line break
" setlocal comments+=bn:>
" ---- 追加ここまで ----

let s:RIndent = function(substitute(&indentexpr, "()", "", ""))
let b:did_indent = 1

setlocal indentkeys=0{,0},:,!^F,o,O,e
setlocal indentexpr=GetRmdIndent()

if exists("*GetRmdIndent")
  finish
endif

" function GetMdIndent()
"   let pline = getline(v:lnum - 1)
"   let cline = getline(v:lnum)
"   if prevnonblank(v:lnum - 1) < v:lnum - 1 || cline =~ '^\s*[-\+\*]\s' || cline =~ '^\s*\d\+\.\s\+'
"     return indent(v:lnum)
"   elseif pline =~ '^\s*[-\+\*]\s'
"     return indent(v:lnum - 1) + 2
"   elseif pline =~ '^\s*\d\+\.\s\+'
"     return indent(v:lnum - 1) + 3
"   endif
"   return indent(prevnonblank(v:lnum - 1))
" endfunction

function GetRmdIndent()
  if getline(".") =~ '^[ \t]*```{r .*}$' || getline(".") =~ '^[ \t]*```$'
    return 0
  endif
  if search('^[ \t]*```{r', "bncW") > search('^[ \t]*```$', "bncW")
    return s:RIndent()
  else
    " rcmdnk/vim-markdownのを使う
    return GetMarkdownIndent()
  endif
endfunction

" vim: sw=2

