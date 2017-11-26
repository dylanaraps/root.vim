"=============================================================
" FILE: root.vim
" AUTHOR:  Dylan Araps <dylan.araps at gmail.com>
" License: MIT license
"=============================================================

let g:root#patterns = get(g:, 'root#patterns', ['.git', '_darcs', '.hg', '.bzr', '.svn'])
let g:root#auto = get(g:, 'root#auto', 0)
let g:root#autocmd_patterns = get(g:, 'root#autocmd_patterns', '*')
let g:root#echo = get(g:, 'root#echo', 1)

" Find Root {{{

function! root#FindRoot()
    if &buftype ==? ''
        " The plugin doesn't work with autochdir
        set noautochdir

        " Start in open file's directory
        lcd %:p:h
        let l:liststart = 0

        for l:pattern in g:root#patterns[l:liststart : len(g:root#patterns)]
            " If l:pattern is a file use findfile() else use finddir()
            if matchstr(l:pattern, '\m\C\w\+\.\w*$') == l:pattern
                let l:fullpath = findfile(l:pattern, ';')
            else
                let l:fullpath = finddir(l:pattern, ';')
            endif

            " Split the directory into path/match
            let l:match = matchstr(l:fullpath, '\m\C[^\/]*$')
            let l:path = matchstr(l:fullpath, '\m\C.*\/')

            " $HOME + match
            let l:home = $HOME . '/' . l:pattern

            " If the search hits home try the next item in the list.
            " Once a match is found break the loop.
            if l:fullpath == l:home
                let l:liststart = l:liststart + 1
                lcd %:p:h
            elseif empty(l:match) == 0
                break
            endif

            " If the search hits the end of the list start over
            if l:liststart == len(g:root#patterns)
                let l:liststart = 0
            endif
        endfor

        " If path is anything but blank
        if l:path !=? ''
            exe 'lcd' . ' ' l:path
        endif

        if g:root#echo == 1 && l:match !=? ''
            echom 'Found' l:match 'in' getcwd()
        elseif g:root#echo == 1
            echom 'Root dir not found'
        endif
    endif
endfunction

" }}}
