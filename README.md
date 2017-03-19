# root.vim

root.vim changes your working directory to your project's root automatically on file open or manually with the `:Root` command.

The plugin identifies the root of your project using a known file/directory. By default it looks for VCS folders such as .git, .hg and .bzr but you can configure it to look for any number of files or folders that sit in your project's root.

I wrote this plugin for fun and was heavily inspired by [vim-rooter](https://github.com/airblade/vim-rooter).


## Installation

Use your favorite plugin manager.

- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'dylanaraps/root.nvim'` to your .nvimrc
  2. Run `:PlugInstall`


## Options


### Patterns

Default: `let g:root#patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn']`

The files and folders to look for when finding the root directory. Setting your own value overwrites the defaults.

```vimL
	" Overriding the default list
	let g:root#patterns = ['.sass-cache', 'Readme.md', 'gulpfile.coffee']
```

You can add to the default list like this:

```vimL
	" Add more files/folders without losing default values
	let g:root#patterns += ['.sass-cache', 'Readme.md', 'gulpfile.coffee']
```


### Auto

Default: `let g:root#auto = 0`

root.vim supports automatically changing your directory to the project root on file open. This option is disabled by default and can be enabled by changing the value to a 1.


### Auto Patterns

Default: `let g:root#autocmd_patterns = "*"`

When `g:root#auto` is set to a 1 all files trigger the automatic behavior. You can restrict this to specific files and extensions using a comma separated list.

```vimL
	" Limit the automatic behavior to only html/css/js files
	let g:root#autocmd_patterns = "*.html,*.css,*.js"

	" Limit the automatic behavior to files starting with Bob
	let g:root#autocmd_patterns = "Bob*.*"
```


### Echo

Default: `let g:root#echo = 1`

Enable/Disable echoing of the "Directory changed to ~/folder/../..".

```vimL
	" Disable echoing on dir change
	let g:root#echo = 0
```
