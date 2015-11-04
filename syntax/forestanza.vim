" Vim syntax file
" Language:     Forestanza (Translation assistant)

""" Header
" ATTENTION: wasn't and won't be adapted (by me) for old vim versions
if version < 600 | finish | endif
if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif
let s:save_cpo = &cpo
set cpo&vim


syn sync fromstart
"" USE as common for separate *.fjp, *.fkr
" runtime! syntax/forestanza.vim

"" Including:
" In cpp.vim:
" runtime! syntax/c.vim
" unlet b:current_syntax
" In perl.vim:
" :syntax include @Pod <sfile>:p:h/pod.vim
" :syntax region perlPOD start="^=head" end="^=cut" contains=@Pod


""" Lexems
"" USE 'display' for jap lexems (oneliners/words only)
"" USE 'nextgroup' for jap composite words -- highlight <1> only if after <2>
" syn keyword fzaMarks  NOT contained
" hi def link fzaMarks  Underlined

" " syn match  fzaBrace1   '[()]'   contained
" syn match  fzaBrace2   '[\[\]]' contained
" syn match  fzaBrace3   '[{}]'   contained
" """ Styles -- ignore if already specified
" " hi def link fzaBrace1 Normal
" hi def link fzaBrace2 Statement
" hi def link fzaBrace3 Function

"" USE concealends -- to hide Pars when not current line
" "" Highlights three levels of parentheses
" syn region fzaPars1 matchgroup=fzaPars1 start="(" end=")" contains=fzaPars2
" syn region fzaPars2 matchgroup=fzaPars2 start="(" end=")" contains=fzaPars3 contained
" syn region fzaPars3 matchgroup=fzaPars3 start="(" end=")" contains=fzaPars1 contained
" hi def link fzaPars1 Statement
" hi def link fzaPars2 Structure
" hi def link fzaPars3 Special


"" NOTE matchgroup=  -- different highlight for matches
" syn region String matchgroup=Quote start=+"+  skip=+\\"+	end=+"+
" NOTE -- you can use several matchgroup=, start= and end= in one :syn

" WARNING
" The contained groups will also match in the start and end patterns of a
" region.  If this is not wanted, the "matchgroup" argument can be used
" |:syn-matchgroup|.  The "ms=" and "me=" offsets can be used to change the
" region where contained items do match.	Note that this may also limit the
" area that is highlighted

" USE: patt/list after other rules, no necessary for 'contains' in them,
" syn keyword myword HELP containedin=cComment contained


"" USE also for jap numbers
syn match  fzaNumber   '[0-9]\+'
hi def link fzaNumber Number

" 'oneline' -- end of start patt and start of end patt -- within one line.
" -- This can't be changed by a skip pattern that matches a line break.
syn region fzaComment start="#" end="$" oneline keepend
hi def link fzaComment Comment

syn cluster fzaMarkupG contains=fzaComment,
      \ fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
" OR
" syn keyword A aaa
" syn keyword B bbb
" syn cluster SmallGroup contains=B
" syn cluster BigGroup contains=A,@SmallGroup
" syn match Stuff "( aaa bbb )" contains=@BigGroup
" syn cluster BigGroup remove=B	" no effect, since B isn't in BigGroup
" syn cluster SmallGroup remove=B	" now bbb isn't matched within Stuff


""" Main
"" NOTE External back-ref grouping -- can't refer multiline matches
" syn region hereDoc start="<<\z(\I\i*\)" end="^\z1$"
" syn region foo start="start \(\I\i*\)" skip="not end \z1" end="end \z1"

" WARNING \zs can be possibly slow -- due to similarity with (..)@<=
syn region fzaOrigin contains=@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs[^:~|<[:space:]])" skip="\z1" end="$" "me=s-1
syn region fzaPhonetics contains=@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs:)" skip="\z1" end="$"
syn region fzaTranslation contains=@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs\~)" skip="\z1" end="$"
hi def link fzaOrigin Special
hi def link fzaPhonetics Comment
hi def link fzaTranslation Statement

"" NOTE contains= --  allows to start inside, recursivly extend,
" ALL | ALLBUT,{gr-nm},.. | TOP | TOP,{gr-nm},..  CONTAINED | CONTAINED,{gr-nm},..
" Can use patt for all already defined groups =Comment.*,Keyw[0-3] OR ALLBUT,<patt>

" USE:
" set foldmethod=syntax

""" Table -- TODO fold
"" IDEA: all table -- one fold, each same indent inside region -- nested fold
" NOTE transparent may be useful for highlighting first word in list of syns
syn cluster fzaTableG contains=fzaComment,
      " \ fzaTableRow,fzaTableCell,fzaSynMain,fzaSynonyms

" transparent
" syn region fzaTable matchgroup=fzaTable fold transparent
"       \ start="\v^\s{-}\|" skip="\v\_$\_s{-}\|" end="$"
"       \ contains=fzaTable ",@fzaTableG
      " \ start="\v^\_s*\zs\|" skip="$\_s*|" end="$"
" hi def link fzaTable  Structure

" SEE
"   http://stackoverflow.com/questions/8443218/syntax-highlighting-of-nested-comment-folds-in-vim

hi documentation ctermfg=darkcyan
" syn region genericdoc start="|{" end="|}" transparent
" syn region collection start="|{" end="|}"
syn region documentation matchgroup=documentation fold
      \ start="|{" end="|}" contains=documentation

" syn match  fzaTableRow    '|\|-\+' contained containedin=fzaTable
" syn region fzaTableCell
"       \ start="|" end="|" contains=fzaTableRow
" hi def link fzaTableRow  Structure

" syn region fzaSynMain  start=":" end="," keepend contained
" syn region fzaSynonyms start="\v\|@1<=%([^|]+$)@=" end="$" keepend contains=fzaSynMain
" hi def link fzaSynMain Special
" hi def link fzaSynonyms Comment


""" Footer
let b:current_syntax = 'forestanza'
let &cpo = s:save_cpo
unlet s:save_cpo

"" TODO
" After all setted up -- see '10. Synchronizing'
" Also '4. Syntax file remarks' for highlighting export

"" Profile
" :syntime on
" [ redraw the text at least once with CTRL-L ]
" :syntime report
"" Hack -- different syntax for windows of the same file, like in bash
" :ownsyntax awk
