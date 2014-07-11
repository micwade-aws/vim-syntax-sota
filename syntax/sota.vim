" Vim syntax file
" Language:	Sota
" Maintainer:	Michael Wade
" Last Change:	2014-7-4
" Credits:	Scott "BDFL of Sota" Idler 
"		Benjamin Esquivel
"
"		Basic file for sota syntax handling in vim.

" For version 5.x: Clear all syntax items.
" For version 6.x: Quit when a syntax file was already loaded.
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Keep sota keywords in alphabetical order
syn keyword sotaStatement	continue break
syn keyword sotaStatement	print debug trace
" syn keyword sotaStatement	False, None, True
" syn keyword sotaStatement	as assert break continue del exec global
" syn keyword sotaStatement	lambda nonlocal pass print return with yield
" syn keyword sotaStatement	class def nextgroup=sotaFunction skipwhite
syn keyword sotaConditional	if then elif else
syn keyword sotaRepeat		do foreach while
syn keyword sotaOperator	and in is not or
syn keyword sotaException	except finally raise try
syn keyword sotaInclude		from import

" Decorators
syn match   sotaDecorator	"@" display nextgroup=sotaFunction skipwhite
" The zero-length non-grouping match before the function name is
" extremely important in sotaFunction.  Without it, everything is
" interpreted as a function inside the contained environment of
" doctests.
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   sotaFunction
      \ "\%(\%(def\s\|class\s\|@\)\s*\)\@<=\h\%(\w\|\.\)*" contained

syn match   sotaComment	"#.*$" contains=sotaTodo,@Spell
syn keyword sotaTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  sotaString
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=sotaEscape,@Spell
syn region  sotaString
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=sotaEscape,sotaSpaceError,sotaDoctest,@Spell
syn region  sotaRawString
      \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  sotaRawString
      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=sotaSpaceError,sotaDoctest,@Spell

syn match   sotaEscape	+\\[abfnrtv'"\\]+ contained
syn match   sotaEscape	"\\\o\{1,3}" contained
syn match   sotaEscape	"\\x\x\{2}" contained
syn match   sotaEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained
" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   sotaEscape	"\\N{\a\+\%(\s\a\+\)*}" contained
syn match   sotaEscape	"\\$"


" It is very important to understand all details before changing the
" regular expressions below or their order.
" The word boundaries are *not* the floating-point number boundaries
" because of a possible leading or trailing decimal point.
" The expressions below ensure that all valid number literals are
" highlighted, and invalid number literals are not.  For example,
"
" - a decimal point in '4.' at the end of a line is highlighted,
" - a second dot in 1.0.0 is not highlighted,
" - 08 is not highlighted,
" - 08e0 or 08j are highlighted,
"
" and so on...
" numbers (including longs and complex)
syn match   sotaNumber	"\<0[oO]\=\o\+[Ll]\=\>"
syn match   sotaNumber	"\<0[xX]\x\+[Ll]\=\>"
syn match   sotaNumber	"\<0[bB][01]\+[Ll]\=\>"
syn match   sotaNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
syn match   sotaNumber	"\<\d\+[jJ]\>"
syn match   sotaNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
syn match   sotaNumber
	\ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
syn match   sotaNumber
	\ "\%(^\|\W\)\@<=\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"

" Group the built-ins together
" built-in constants
syn keyword sotaBuiltin	False True None
syn keyword sotaBuiltin	NotImplemented Ellipsis __debug__
" built-in functions
syn keyword sotaBuiltin	abs all any bin bool chr classmethod foreach
syn keyword sotaBuiltin	compile complex delattr dict dir divmod
syn keyword sotaBuiltin	enumerate eval filter float format
syn keyword sotaBuiltin	frozenset getattr globals hasattr hash
syn keyword sotaBuiltin	help hex id input int isinstance

" builtin base exceptions (only used as base classes for other exceptions)
syn keyword sotaExceptions	BaseException Exception
syn keyword sotaExceptions	ArithmeticError EnvironmentError
syn keyword sotaExceptions	LookupError
" builtin base exception removed in Python 3.0
syn keyword sotaExceptions	StandardError
" builtin exceptions (actually raised)
syn keyword sotaExceptions	AssertionError AttributeError BufferError
syn keyword sotaExceptions	EOFError FloatingPointError GeneratorExit
syn keyword sotaExceptions	IOError ImportError IndentationError
syn keyword sotaExceptions	IndexError KeyError KeyboardInterrupt
syn keyword sotaExceptions	MemoryError NameError NotImplementedError
syn keyword sotaExceptions	OSError OverflowError ReferenceError
syn keyword sotaExceptions	RuntimeError StopIteration SyntaxError
syn keyword sotaExceptions	SystemError SystemExit TabError TypeError
syn keyword sotaExceptions	UnboundLocalError UnicodeError
syn keyword sotaExceptions	UnicodeDecodeError UnicodeEncodeError
syn keyword sotaExceptions	UnicodeTranslateError ValueError VMSError
syn keyword sotaExceptions	WindowsError ZeroDivisionError
" builtin warnings
syn keyword sotaExceptions	BytesWarning DeprecationWarning FutureWarning
syn keyword sotaExceptions	ImportWarning PendingDeprecationWarning
syn keyword sotaExceptions	RuntimeWarning SyntaxWarning UnicodeWarning
syn keyword sotaExceptions	UserWarning Warning

" trailing whitespace
syn match   sotaSpaceError	display excludenl "\s\+$"
" mixed tabs and spaces
syn match   sotaSpaceError	display " \+\t"
syn match   sotaSpaceError	display "\t\+ "

"" MJW: Deleted all the doctest code... did we need that?

" Sync at the beginning of class, function, or method definition.
syn sync match sotaSync grouphere NONE "^\s*\%(def\|class\)\s\+\h\w*\s*("

if version >= 508
  if version <= 508
    let did_sota_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default highlight links.  Can be overridden later.
  HiLink sotaStatement	Statement
  HiLink sotaConditional	Conditional
  HiLink sotaRepeat		Repeat
  HiLink sotaOperator		Operator
  HiLink sotaException	Exception
  HiLink sotaInclude		Include
  HiLink sotaDecorator	Define
  HiLink sotaFunction		Function
  HiLink sotaComment		Comment
  HiLink sotaTodo		Todo
  HiLink sotaString		String
  HiLink sotaRawString	String
  HiLink sotaEscape		Special
  HiLink sotaNumber		Number
  HiLink sotaBuiltin	Function
  HiLink sotaExceptions	Structure
  HiLink sotaSpaceError	Error
  HiLink sotaDoctest	Special
  HiLink sotaDoctestValue	Define
  
  delcommand HiLink
endif

let b:current_syntax = "sota"

" vim:set sw=2 sts=2 ts=8 noet:
