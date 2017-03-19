"=============================================================
" FILE: root.vim
" AUTHOR:  Dylan Araps <dylan.araps at gmail.com>
" License: MIT license
"=============================================================

if exists('g:loaded_root')
    finish
endif
let g:loaded_root = 1

command! Root call root#FindRoot()

if g:root#auto == 1
    augroup root
        au!
        exe 'autocmd BufEnter ' . g:root#autocmd_patterns . ' :Root'
    augroup END
endif
