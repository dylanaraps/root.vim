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

if !exists("g:root#echo")
	let g:root#echo = 1
endif

if !exists("g:root#override_autochdir")
	let g:root#disable_autochdir = 0
endif

" Find Taskrunner {{{

function! FindRoot()

	" The plugin doesn't work with autochdir
	if exists('+autochdir') && &autochdir && g:root#disable_autochdir == 0
	  set noautochdir
	endif

	" start in file's directory
	lcd %:p:h

	" start at first directory in list
	let sdir = 0

	for dir in g:root#patterns[sdir : len(g:root#patterns)]
		if matchstr(dir, '\w\+\.\w*$') == dir
			let fullpath = findfile(dir, ";")
		else
			let fullpath = finddir(dir, ";")
		endif

			let pattern = matchstr(fullpath, '\w*\.*\w*\-*\w*$')
			let path = matchstr(fullpath, '.*\/')

			let homedir = $HOME . "/" . dir

			if fullpath == homedir
				let sdir = sdir + 1
				lcd %:p:h
			elseif empty(pattern) == 0
				break
			elseif sdir == len(g:root#patterns)
				let sdir = 0
			endif

		echom matchstr(dir, "\w+\.\w*$")
	endfor

	execute "lcd" . " " path

	if g:root#echo == 1
		echo "found" pattern "in" getcwd()
	endif
endfunction

" }}}

" This command works with all of gulp/grunt's cmdline flags
command! -nargs=* -complete=file Root call FindRoot()

" Autocmd
if g:root#auto == 1
	augroup root
		au!
		autocmd BufEnter * :Root
	augroup END
endif