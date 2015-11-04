" Vim syntax file
" Language:     Forestanza (Translation assistant)

""" Header
" ATTENTION: wasn't and won't be adapted (by me) for old vim versions
if version < 600 | finish | endif
if version < 700
  syntax clear
elseif exists('b:current_syntax')
  " finish
  echo "hi"
endif
let s:save_cpo = &cpo
set cpo&vim


sy sync fromstart
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
" sy keyword fzaMarks  NOT contained
" hi def link fzaMarks  Underlined

" " sy match  fzaBrace1   '[()]'   contained
" sy match  fzaBrace2   '[\[\]]' contained
" sy match  fzaBrace3   '[{}]'   contained
" """ Styles -- ignore if already specified
" " hi def link fzaBrace1 Normal
" hi def link fzaBrace2 Statement
" hi def link fzaBrace3 Function

"" USE concealends -- to hide Pars when not current line
" "" Highlights three levels of parentheses
" sy region fzaPars1 matchgroup=fzaPars1 start="(" end=")" contains=fzaPars2
" sy region fzaPars2 matchgroup=fzaPars2 start="(" end=")" contains=fzaPars3 contained
" sy region fzaPars3 matchgroup=fzaPars3 start="(" end=")" contains=fzaPars1 contained
" hi def link fzaPars1 Statement
" hi def link fzaPars2 Structure
" hi def link fzaPars3 Special

" "" USE for jap numbers
" sy match  fzaNumber   '[0-9]\+'
" hi def link fzaNumber Number

" "\v^\S@=[^:~|<]" -- no space

""" External back-ref grouping -- can't refer multiline matches
" sy region hereDoc start="<<\z(\I\i*\)" end="^\z1$"
" sy region foo start="start \(\I\i*\)" skip="not end \z1" end="end \z1"


""" Main
"" NOTE contains= --  allows to start inside, recursivly extend,
" ALL | ALLBUT,{gr-nm},.. | TOP | TOP,{gr-nm},..  CONTAINED | CONTAINED,{gr-nm},..
" Can use patt for all already defined groups =Comment.*,Keyw[0-3] OR ALLBUT,<patt>
" ALT use cluster to combine:
" sy match Thing "# [^#]\+ #" contains=@ThingMembers
" sy cluster ThingMembers contains=ThingMember1,ThingMember2
" OR
" sy keyword A aaa
" sy keyword B bbb
" sy cluster SmallGroup contains=B
" sy cluster BigGroup contains=A,@SmallGroup
" sy match Stuff "( aaa bbb )" contains=@BigGroup
" sy cluster BigGroup remove=B	" no effect, since B isn't in BigGroup
" sy cluster SmallGroup remove=B	" now bbb isn't matched within Stuff


"" NOTE matchgroup=  -- different highlight for matches
" sy region String matchgroup=Quote start=+"+  skip=+\\"+	end=+"+
" NOTE -- you can use several matchgroup=, start= and end= in one :sy

" WARNING
" The contained groups will also match in the start and end patterns of a
" region.  If this is not wanted, the "matchgroup" argument can be used
" |:syn-matchgroup|.  The "ms=" and "me=" offsets can be used to change the
" region where contained items do match.	Note that this may also limit the
" area that is highlighted

" USE: patt/list after other rules, no necessary for 'contains' in them,
" sy keyword myword HELP containedin=cComment contained

"  skip="\v^\_s*[^:~|<]"
sy region fzaOrigin keepend
      \ start="\v^\_s*[^:~|<]" end="\v^\_s*[:~|<]" "me=e-1
      " \ contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
" sy region fzaPhonetics keepend
"       \ start="\v^\_s*:" skip="\v^\_s*:" end="\v^\_s*[^:]"me=e-1
"       \ contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
" sy region fzaTranslation keepend
"       \ start="\v^\_s*\~" skip="\v^\_s*\~" end="\v^\_s*[^\~]"me=e-1
"       \ contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
hi def link fzaOrigin Special
" hi def link fzaPhonetics Comment
" hi def link fzaTranslation Statement

"" NOTE
"oneline" -- end of start patt and start of end patt must be within one line.
"This can't be changed by a skip pattern that matches a line break.

""" Table -- TODO fold
" NOTE transparent may be useful for highlighting first word in list of syns

" sy region fzaTable keepend transparent fold
"       \ start="\v^\_s*[|]" end="\v^\_s*[^|]"me=e-1
"       \ contains=fzaTableRow,fzaTableCell,fzaSynMain,fzaSynonyms
" sy match  fzaTableRow    '|\|-\+' contained containedin=fzaTable
" sy region fzaTableCell
"       \ start="|" end="|" contains=fzaTableRow
" hi def link fzaTableRow  Structure

" sy region fzaSynMain  start=":" end="," keepend contained
" sy region fzaSynonyms start="\v\|@1<=%([^|]+$)@=" end="$" keepend contains=fzaSynMain
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
