"=============================================================
" FILE: root.vim
" AUTHOR:  Dylan Araps <dylan.araps at gmail.com>
" License: MIT license
"=============================================================

let g:root#patterns = get(g:, 'root#patterns', ['.git', '_darcs', '.hg', '.bzr', '.svn'])
let g:root#auto = get(g:, 'root#auto', 0)
let g:root#autocmd_patterns = get(g:, 'root#autocmd_patterns', "*")
let g:root#echo = get(g:, 'root#echo', 1)

" Find Root {{{

function! root#FindRoot()
    if &buftype == ""
        " The plugin doesn't work with autochdir
        set noautochdir

        " Start in open file's directory
        lcd %:p:h
        let liststart = 0

        for pattern in g:root#patterns[liststart : len(g:root#patterns)]
            " If pattern is a file use findfile() else use finddir()
            if matchstr(pattern, '\m\C\w\+\.\w*$') == pattern
                let fullpath = findfile(pattern, ';')
            else
                let fullpath = finddir(pattern, ';')
            endif

            " Split the directory into path/match
            let match = matchstr(fullpath, '\m\C[^\/]*$')
            let path = matchstr(fullpath, '\m\C.*\/')

            " $HOME + match
            let home = $HOME . '/' . pattern

            " If the search hits home try the next item in the list.
            " Once a match is found break the loop.
            if fullpath == home
                let liststart = liststart + 1
                lcd %:p:h
            elseif empty(match) == 0
                break
            endif

            " If the search hits the end of the list start over
            if liststart == len(g:root#patterns)
                let liststart = 0
            endif
        endfor

        " If path is anything but blank
        if path != ''
            exe 'lcd' . ' ' path
        endif

        if g:root#echo == 1 && match != ''
            echom 'Found' match 'in' getcwd()
        elseif g:root#echo == 1
            echom 'Root dir not found'
        endif
    endif
endfunction

" }}}
