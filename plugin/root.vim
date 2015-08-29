" root.vim
" by Dylan Araps

if exists("g:loaded_root")
	finish
endif

let g:loaded_root = 1

if !exists("g:root#patterns")
	let g:root#patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn']
endif

if !exists("g:root#auto")
	let g:root#auto = 0
endif

if !exists("g:root#autocmd_patterns")
	let g:root#autocmd_patterns = "*"
endif

if !exists("g:root#echo")
	let g:root#echo = 1
endif

if !exists("g:root#override_autochdir")
	let g:root#disable_autochdir = 1
endif

" Find Taskrunner {{{

function! FindRoot()
	" The plugin doesn't work with autochdir
	if g:root#disable_autochdir == 1
	  set noautochdir
	endif

	" Start in open file's directory
	lcd %:p:h
	let liststart = 0

	for pattern in g:root#patterns[liststart : len(g:root#patterns)]
		" If pattern is a file use findfile() else use finddir()
		if matchstr(pattern, '\w\+\.\w*$') == pattern
			let fullpath = findfile(pattern, ";")
		else
			let fullpath = finddir(pattern, ";")
		endif

		" Split the directory into path/match
		let match = matchstr(fullpath, '[^\/]*$')
		let path = matchstr(fullpath, '.*\/')

		" $HOME + match
		let home = $HOME . "/" . pattern

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
	if path != ""
		execute "lcd" . " " path
	endif

	if g:root#echo == 1 && match != ""
		echom "Found" match "in" getcwd()
	else
		echom "Root dir not found"
	endif
endfunction

" }}}

command! Root call FindRoot()

" Autocmd
if g:root#auto == 1
	augroup root
		au!
		execute 'autocmd BufEnter ' . g:root#autocmd_patterns . ' :Root'
	augroup END
endif