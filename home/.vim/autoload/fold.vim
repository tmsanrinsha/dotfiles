function! s:IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! s:NextNonBlankLine(lnum)
    let lnum = nextnonblank(a:lnum)
    if lnum == 0
        return -2
    else
        return lnum
    endif
endfunction

function! fold#indent(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = s:IndentLevel(a:lnum)
    let next_indent = s:IndentLevel(s:NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction
