" simplerooter.vim
" by Dylan Araps

if exists("g:loaded_simplerooter")
	finish
endif

let g:loaded_simplerooter = 1

if !exists("g:simplerooter#dirlist")
	let g:simplerooter#dirlist = ['.git', '_darcs', '.hg', '.bzr', '.svn']
endif

if !exists("g:simplerooter#auto")
	let g:simplerooter#auto = 0
endif

if !exists("g:simplerooter#echodir")
	let g:simplerooter#echodir = 1
endif

if !exists("g:simplerooter#override_autochdir")
	let g:simplerooter#override_autochdir = 0
endif

" Find Taskrunner {{{

function! FindRoot()

	" The plugin doesn't work with autochdir
	if exists('+autochdir') && &autochdir && g:simplerooter#override_autochdir == 0
	  set noautochdir
	endif

	" start in file's directory
	lcd %:p:h

	" start at first directory in list
	let sdir = 0

	for dir in g:simplerooter#dirlist[sdir : len(g:simplerooter#dirlist)]
		let fullpath = finddir(dir, ";")
		let cutpath = matchstr(fullpath, '\w*\.*\w*\-*\w*$')

		let homedir = $HOME . "/" . dir

		" if the recursive search hits your home directory start at the next item in the list right back in the open file's directory.
		if fullpath == homedir
			let sdir = sdir + 1
			lcd %:p:h
		elseif empty(cutpath) == 0
			break
		elseif sdir == len(g:simplerooter#dirlist)
			let sdir = 0
		endif
	endfor

	execute "lcd" . " " fullpath
	lcd ..

	if g:simplerooter#echodir == 1
		echo "found" cutpath "in" getcwd()
	endif
endfunction

" }}}

" This command works with all of gulp/grunt's cmdline flags
command! -nargs=* -complete=file Root call FindRoot()

" Autocmd
if g:simplerooter#auto == 1
	augroup simplerooter
		au!
		autocmd BufEnter * :Root
	augroup END
endif