" Configuration file for vim

"" Set up options.
" First things first.
set nocp

" Spacing and indentation.
set ts=4
set sw=4
set sts=4
set et
set ai

" Backups, saving, and statefulness.
set uc=0				" No swap file.
set nobk				" No backups.
set vi='20,\"50	" 20 marks and 50 lines.
set hi=50				" 50 items in command line history.

" Status line.
set ru					" Turn on ruler.
set ls=2				" Always show a status bar for powerline.

" Folding.
if has("folding")
	set fdm=marker
endif

" Text handling.
set spc=				" Don't complain about uncapitalized words starting a sentence.
set flp=^[-*+•]\\+\\s\\+	" Don't indent lines starting with a number and a dot.
set fo+=n				" Indent lists properly.
if v:version >= 704 || (v:version == 703 && has("patch541"))
	set fo+=j				" Remove comment characters when joining lines.
endif
set tw=80
set bs=indent,eol,start
set wrap
set nf=alpha,hex,octal	" Make Ctrl-A and Ctrl-X work on text.

" Loading files.
set ml					" Modelines are nice.
set enc=utf-8		" Always use UTF-8.
set tenc=utf-8
set wim=longest,full
set su=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set hid					" Don't force saving when changing buffers.

" Search.
set nohls

" Rendering.
if exists("$SSH_CONNECTION") || filereadable(expand("$HOME") . '/.slowbox')
	set notf			" Speed up redrawing on slow SSH connections.
endif
if has("termguicolors") && exists("$COLORTERM") && $COLORTERM == "truecolor"
	set tgc
end

" GUI settings.
if has("gui_running")
	set lines=24
	set co=128
	set gcr+=a:blinkon0
	set gfn=Monospace\ 8
	set go-=tT			" Disable tearoffs and toolbar.
endif

"" Terminal issues.
" These terminals are capable of supporting 16 colors, but they lie and only
" claim support for 8.  Fix it so things don't look ugly.
if &term == "xterm" || &term == "xterm-debian" || &term == "xterm-xfree86"
	set t_Co=16
	set t_Sf=[3%dm
	set t_Sb=[4%dm
endif
if has("termguicolors") && &tgc && &t_8f == ''
	set t_8f=[38;2;%lu;%lu;%lum
	set t_8b=[48;2;%lu;%lu;%lum
endif

"" Comamnds.
if has("user_commands")
	command! -range=% DoTidy			call <SID>DoTidy(<line1>, <line2>)
	command! -range=% Trailing		call <SID>ClearTrailingWhitespace(<line1>, <line2>, "")
	command! -range=% TrailingAll	call <SID>ClearTrailingWhitespace(<line1>, <line2>, "\v(^--)@<!\s+$")
	command! Edir	execute ':e ' . expand('%:p:h')
	command! -nargs=1	Emod	execute ':e ' . <SID>ModulePath("<args>")
	command! AppendSignature	call <SID>AppendSignature()
endif

"" Maps.
" Show highlighting groups under cursor.
noremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")  . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" "* is hard to type.  Map it to something easier.
noremap <Leader><Leader> "*
noremap <Leader>c "+
" Trim trailing whitespace.
noremap <Leader>w :Trailing<CR>
noremap <Leader>zw :TrailingAll<CR>
" Toggle whitespace highlighting.
noremap <Leader>t :call <SID>ToggleWhitespaceChecking()<CR>
" Toggle executable bit.
noremap <Leader>x :call <SID>ToggleExecutable()<CR>
" Beautify files.
noremap <Leader>b :DoTidy<CR>
nnoremap <Leader>pp :set paste!<CR>
nnoremap <Leader>ll :set list!<CR>

"" Graceful exit.
" Versions of Vim without +eval will exit here.
if 0 | finish | endif

"" Automatic file handling.
if has("autocmd")
	filetype plugin indent on
endif
if $TERM == 'dumb'
	hi clear
	set t_Co=0
	syntax off
else
	syntax enable
endif

"" Autocommands.
" Setting file type.
augroup setf
	au BufEnter,BufRead,BufNewFile *.adoc										setf asciidoc
	au BufEnter,BufRead,BufNewFile ~/*.txt									setf asciidoc
	au BufEnter,BufRead,BufNewFile merge_request_testing.*	setf asciidoc
	au BufEnter,BufRead,BufNewFile *.dbx										setf docbkxml
	au BufEnter,BufRead,BufNewFile *.mx											setf groff
	au BufEnter,BufRead,BufNewFile $VIMRUNTIME/doc/*.txt		setf help
	au BufEnter,BufRead,BufNewFile reportbug-*							setf mail
	au BufEnter,BufRead,BufNewFile reportbug.*							setf mail
	au BufEnter,BufRead,BufNewFile *.xml										setf xml
	au BufEnter,BufRead,BufNewFile *.xsl										setf xslt
	au BufEnter,BufRead,BufNewFile *.pasm										setf parrot
	au BufEnter,BufRead,BufNewFile *.pir										setf pir
	au BufEnter,BufRead,BufNewFile *.iced										setf coffee
	au BufEnter,BufRead,BufNewFile lib6/*.pm								setf perl6
augroup end

" File type-specific parameters.
augroup setl
	au FileType asciidoc		setl tw=80 ts=2 sw=2 sts=2 spell com=b://
	au FileType clojure			setl ts=2 sw=2 sts=2 et
	au FileType cpp					setl cin cino=t0 noet
	au FileType c						setl cin cino=t0 noet
	au FileType cs					setl cin cino=t0 noet
	au FileType docbkxml		setl cms=<!--%s-->
	au FileType gitcommit		setl tw=72 spell com=b:#
	au FileType javascript	setl cin cino=t0,j1,J1
	au FileType java				setl cin cino=t0,j1 noet
	au FileType mail				setl tw=72 ts=2 sw=2 sts=2 et spell com=n:>
	au FileType python			setl et si tw=79
	au FileType rst					setl et si ts=2 sw=2 sts=2 spell
	au FileType ruby				setl ts=2 sw=2 sts=2 et si
	au FileType sass				setl tw=0 noet
	au FileType scss				setl tw=0 noet
	au FileType vim					setl ts=2 sw=2 sts=2 noet
	au FileType xslt				setl tw=0 ts=2 sw=2 sts=2 noet
augroup end

" Language-specific setup.
if v:version >= 700
	augroup call
		au FileType perl				call s:SelectPerlSyntasticCheckers()
		au FileType python			call s:SelectPythonSyntasticCheckers()
	augroup end
endif

" Language-specific variables.
if v:version >= 700
	augroup let
		au FileType mail			let b:airline_whitespace_disabled = 1
	augroup end
endif

" Syntax commands.
augroup syntax
	au FileType asciidoc		syn sync clear | syn sync minlines=25
augroup end

" Whitespace-related autocommands.
if v:version >= 702 || (v:version == 701 && has("patch40"))
	" matchadd and friends showed up in Vim 7.1.40.
	augroup whitespace
		au FileType			*				call s:SetWhitespacePattern(0)
		au BufWinEnter	*				call s:SetWhitespacePattern(0)
		au WinEnter			*				call s:SetWhitespacePattern(0)
		au InsertEnter	*				call s:SetWhitespacePattern(1)
		au InsertLeave	*				call s:SetWhitespacePattern(0)
		" Prevent a memory leak in old versions of Vim.
		au BufWinLeave	*				call clearmatches()
		au WinLeave			*				call clearmatches()
		au Syntax				*				call s:SetWhitespacePattern(0)
		au ColorScheme	*				hi def link bmcTrailingWhitespace	Error
		au ColorScheme	*				hi def link bmcSpaceTabWhitespace	Error
		au ColorScheme	*				hi def link bmcTrailingNewline	Error
	augroup end
endif

" Event-related tasks.
if v:version >= 702
	augroup events
		au FileChangedShellPost	*	AirlineRefresh
	augroup end
endif

"" Color scheme.
" This needs to go after the whitespace handling, since it can cause warnings if
" placed before it.
colorscheme ct_grey

"" Graceful exit.
" Vim 6.3 gets very upset if it sees lists or dictionaries, or, for that matter,
" Pathogen.
if v:version < 700
	finish
endif

" Syntastic complains to the terminal if its requirements aren't met.
if v:version == 700 && !has('patch175')
	let g:loaded_syntastic_plugin = 1
endif

"" Bundles.
" Some versions of Vim have a broken autoload, or at least it doesn't work in
" this case, so help it out.
runtime autoload/pathogen.vim
let Fn = function("pathogen#infect")
execute Fn()

"" Language-specific functions.
" perlcritic is *extremely* slow on large files.
function! s:SelectPerlSyntasticCheckers()
	let pcrc = expand("$HOME") . '/.perlcriticrc'
	" If the file has at least 500 lines or there's not a ~/.perlcriticrc...
	if len(getline(500, 500)) == 1 || !filereadable(pcrc)
		let b:syntastic_checkers = []
	else
		let b:syntastic_checkers = ['perlcritic']
		let theme = ''
		let themetext = matchstr(readfile(expand(pcrc, '')), theme)
		if strlen(theme) && strlen(themetext)
			let g:syntastic_perl_perlcritic_args = '--theme ' . theme
		endif
	endif
	if exists('g:syntastic_enable_perl_checker')
		if g:syntastic_enable_perl_checker
			call add(b:syntastic_checkers, "perl")
		endif
	endif
endfunction

function! s:SelectPythonSyntasticCheckers()
	let b:syntastic_checkers = ['python', 'pep8']
endfunction

" Tidy code.
function! s:DoTidy(start, end)
	let cmd = "cat"
	if &ft == "perl"
		let cmd = "perltidy -q"
	elseif &ft == "python"
		let cmd = "pythontidy"
	endif
	call s:ForRange(a:start, a:end, "!" . cmd)
endfunction

"" General functions.
" Do an ex command for a range.
function! s:ForRange(start, end, command, ...)
	let winview = winsaveview()
	let text = ":"
	" Optional prefix.  Can be used for :silent
	if a:0
		let text .= a:1 . " "
	endif
	let text .= a:start . "," . a:end . a:command
	execute text
	call winrestview(winview)
endfunction

"" Whitespace handling functions.
" Turn it on.
function! s:EnableWhitespaceChecking()
	if !exists('b:whitespace')
		let b:whitespace = {'enabled': -1, 'patterns': {}}
	endif
	if b:whitespace['enabled'] == -1
		let b:whitespace['enabled'] = s:GetDefaultWhitespaceMode()
		for i in s:GetPatternList()
			let b:whitespace['patterns'][i] = -1
		endfor
	endif
endfunction

" Toggle it.
function! s:ToggleWhitespaceChecking()
	let b:whitespace['enabled'] = !b:whitespace['enabled']
	call s:SetWhitespacePattern(0)
endfunction

" List of all the patterns.
function! s:GetPatternList()
	return ['trailing', 'spacetab', 'newline']
endfunction

function! s:GetDefaultWhitespaceMode()
	return &ft == "help" && &readonly ? 0 : 1
endfunction

" Set up the patterns.
function! s:SetWhitespacePattern(mode)
	if !s:GetDefaultWhitespaceMode()
		call clearmatches()
		return
	endif
	call s:EnableWhitespaceChecking()
	for i in s:GetPatternList()
		try
			call matchdelete(b:whitespace['patterns'][i])
		catch /E80[23]/
		endtry
	endfor
	if b:whitespace['enabled']
		if a:mode == 1
			let pattern = s:SetWhitespacePatternGeneral() . '%#@<!$'
		elseif a:mode == 0
			let pattern = s:SetWhitespacePatternGeneral() . '$'
		endif
		let stpat = s:SetWhitespacePatternSpaceTab()
		let tnpat = '\v\n%$'
		let patterns = {}
		let patterns['trailing'] = matchadd('bmcTrailingWhitespace', pattern)
		let patterns['spacetab'] = matchadd('bmcSpaceTabWhitespace', stpat)
		let patterns['newline'] = matchadd('bmcTrailingNewline', stpat)
		let b:whitespace['patterns'] = patterns
	else
		let b:whitespace['patterns'] = {}
		for i in s:GetPatternList()
			let b:whitespace['patterns'][i] = -1
		endfor
	endif
endfunction

" Create a language-specific trailing whitespace pattern.
function! s:SetWhitespacePatternGeneral()
	if &et
		let indent = repeat(' ', &sw)
		let nonindent = '(\t| {' . (&sw+1) . '}| {1,' . (&sw-1) . '})'
	else
		let indent = '\t'
		let nonindent = '( +)'
	endif
	let pod_indent = exists('g:bmcPodIndentOk') && g:bmcPodIndentOk
	if &ft == "mail"
		" ExtEdit puts trailing whitespace in header fields.  Don't warn about this,
		" since it will strip it off.  mutt always inserts "> " for indents; don't
		" warn about that either.  And finally, don't warn about the signature
		" delimiter, since there's nothing we can do about that.
		let pattern = '\v(^(--|[A-Z]+[a-zA-Z-]+:\s*|[> ]*\>))@<!'
		" If we're in format=flowed mode, ignore a single trailing space at the end
		" of a nonempty line.
		if &fo =~ 'w'
			let pattern .= '(\s{2,}|\t\s*|^\s+)'
		else
			let pattern .= '\s+'
		endif
	elseif &ft == "diff" || &ft == "review"
		" Don't complain about extra spaces if they start at the beginning of a
		" line.  git and diff insert these.
		let pattern = '\v(^\s*)@<!\s+'
	elseif (&ft == "perl" || &ft == "pod") && pod_indent
		" Unfortunately, Pod uses spaces to delimit a verbatim block, so don't
		" complain about spaces if they use the standard indent.
		let pattern = '\v(^' . indent . '\s+|^(' . nonindent . ')|(\S)@<=\s+)'
	else
		let pattern = '\v\s+'
	endif
	return pattern
endfunction

" Create a language-specific space-followed-by-tab pattern.
function! s:SetWhitespacePatternSpaceTab()
	if &ft == "diff" || &ft == "review"
		" Don't complain about extra spaces if they start at the beginning of a
		" line.  git and diff insert these.
		let pattern = '\v(^)@<! +\ze\t+'
	else
		let pattern = '\v +\ze\t+'
	endif
	return pattern
endfunction

function! s:ClearTrailingWhitespace(start, end, pattern)
	if a:pattern
		let pattern = a:pattern
	else
		let pattern = s:SetWhitespacePatternGeneral() . '$'
	endif
	echo 's/' . pattern . '//g'
	call s:ForRange(a:start, a:end, 's/' . pattern . '//g', 'silent!')
endfunction

function! s:AppendSignature()
	try
		" Space or non-breaking space (U+00A0)
		silent /^--[  ]$/,$delete
	catch /E486/
	endtry
	let lines = readfile(expand("$HOME") . '/.signature')
	call insert(lines, '-- ', 0)
	for i in lines
		$put =i
	endfor
endfunction

function! s:SetUpLanguageHooks()
	if has("perl") && isdirectory(expand("$HOME") . '/lib/perl5')
		perl splice @INC, -1, 0, "$ENV{'HOME'}/lib/perl5"
	endif
endfunction

function! s:ModulePathPerl(module)
	perl <<EOM
	package vimrc::bmc;
	sub f {
		my $m = shift;
		$m =~ s{::}{/}g;
		for (@INC) {
			my $p = "$_/$m.pm";
			return $p if -e $p;
		}
		return '';
	}
	my $x = VIM::Eval('a:module');
	my $p = f($x);
	# Sanitize because of VIM::DoCommand.
	$p = '' if $p =~ tr{A-Za-z0-9./_-}{}c;
	VIM::DoCommand("let path = '$p'")
EOM
	return path
endfunction

function! s:ModulePath(module)
	if has("perl")
		return s:ModulePathPerl(a:module)
	endif
	return ''
endfunction

function! s:ToggleExecutable()
	if has("perl")
		setl ar
		perl <<EOM
		my $file = VIM::Eval('expand("%")');
		my $mode = (stat($file))[2] & 07777;
		$mode ^= (00111 & ~umask);
		chmod($mode, $file);
EOM
		exe "checktime " . bufnr("%")
		set ar<
	endif
endfunction

"" Miscellaneous variables.
" Make sh highlighting POSIXy.
let g:is_posix=1

" Better just to leave POD as a big comment block.
let g:perl_include_pod = 0

" Allow subroutine signatures.
let g:perl_sub_signatures = 1

" Show us the real contents of the file.
let g:vim_json_syntax_conceal = 0

" Make editing git repositories of Perl modules easier.
let g:syntastic_perl_lib_path = ['./lib', './t/lib', './build-tools']

" Allow running perl -wc on Perl files.
let g:syntastic_enable_perl_checker = 1

" Populate the location list to make finding errors easier.
let g:syntastic_always_populate_loc_list = 1

" Airline settings.
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_symbols = {}
let g:airline_symbols.branch = '⚡'
let g:airline_symbols.readonly = '☓'
let g:airline_symbols.linenr = '⁋'
let g:airline_detect_spell = 0
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = '\vmarkdown|rst|org|help|text|asciidoc'
if has("gui_running") || &t_Co > 16
	let g:airline_theme = 'powerlineish'
else
	let g:airline_theme = 'base16_solarized'
endif

" Ctrl-P settings.
let g:ctrlp_max_files = 60000
let g:ctrlp_match_window = 'results:75'

" Ctrl-P settings.  Regenerating the cache is expensive on large repos.
let g:ctrlp_extensions = ['buffertag']
let g:ctrlp_clear_cache_on_exit = 0

" EditorConfig settings.
let g:EditorConfig_max_line_indicator = 'none'

"" Print settings.
if filereadable('/etc/papersize')
	let s:papersize = matchstr(readfile('/etc/papersize', '', 1), '\p*')
	if strlen(s:papersize)
		exe "set printoptions+=paper:" . s:papersize
	endif
	unlet! s:papersize
endif

"" Other language-specific setup.
call s:SetUpLanguageHooks()

" vim: set ts=2 sw=2 sts=2 noet:
