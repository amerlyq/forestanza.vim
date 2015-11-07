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


""" Parentheses
" DEV: switch pars modes by cmd: monochrome, rainbow_delim, rainbow_content
" THINK use concealends -- to hide Pars when not current line
" THINK is it possible to increase color number from innermost instead outermost?
" IDEA: inherit color from lexem before closing parenthesis, like: ( -no)
let quots = [[ 'fzaPars', '(', ')'], [ 'fzaBrks', '\[', '\]'], [ 'fzaBrcs', '{', '}']]
let clrs = ['Special', 'Structure', 'Statement']
let grp_l = 'contained contains='.join(['@fzaLxmOriginG', '@fzaLxmPhoneticG'], ',')
let def_r = 'syn region %s matchgroup=%s containedin=%s '.grp_l.' start="%s" end="%s"'
for [nm, s, e] in quots
  let others = []
  for oth in filter(map(copy(quots), 'v:val[0]'), 'v:val !~ "'.nm.'"')
    " BUG: can't derive right index composition for [],{} inside (), etc
    for i in range(len(clrs)) | call add(others, oth.i) | endfor
  endfor
  exe printf('syn cluster %s contains=%s', nm.'G', join(others, ','))
  for lvl in range(len(clrs))
    let icont = (lvl + len(clrs) - 1) % len(clrs)
    exe printf(def_r, nm.lvl, nm.lvl.'s', nm.icont.',@'.nm.'G', s, e)
    exe printf('hi def link %s %s', nm.lvl.'s', clrs[lvl])
  endfor
endfor


""" Common
syn match  fzaNumber '[0-9]\+'
syn match  fzaNumberEnc '[0-9]\+' contained containedin=fzaEnclosed
hi def link fzaNumber Number
hi def link fzaNumberEnc Tag

"" Keywords has sense only as separate objs. USE in comments for notes?
" syn keyword fzaMarks  NOT contained
" hi def link fzaMarks  Underlined
syn region fzaComment start="#" end="#" end="$" keepend oneline
hi def link fzaComment Comment

syn region fzaEnclosed start="<" end=">" end="$" keepend oneline
hi def link fzaEnclosed Underlined

syn cluster fzaMarkupG contains=fzaComment,
      \ fzaPars0,fzaBrks0,fzaBrcs0


""" Main
" WARNING \zs can be possibly slow -- due to similarity with (..)@<=
syn region fzaOrigin contains=@fzaLxmOriginG,@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs[^:~|<[:space:]])" skip="\z1" end="$" "me=s-1
syn region fzaPhonetic contains=@fzaLxmPhoneticG,@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs:)" skip="\z1" end="$"
syn region fzaTranslation contains=@fzaMarkupG keepend fold
      \ start="\v\z(^\_s*\zs\~)" skip="\z1" end="$"
hi def link fzaOrigin Normal
hi def link fzaPhonetic Comment
hi def link fzaTranslation Constant


""" Table
syn cluster fzaTableG contains=@fzaLxmOriginG,fzaComment,
      \ fzaTableRow,fzaTableCell,fzaSynMain,fzaSynonyms

" syn region fzaTable fold transparent matchgroup=fzaTable
"       \ contains=fzaTablePar,@fzaTableG
"       \ start="^\s\{-}|" skip="\_$\_s\{-}|" end="$"
syn region fzaTablePar fold transparent
      \ contains=fzaTableSub,@fzaTableG
      \ start="^\s\{-}|" skip="\_$\n\s\{-}|" end="$"
syn region fzaTableSub contained fold transparent
      \ contains=@fzaTableG
      \ start="^\s\{-1,}|" skip="\_$\n\s\{-1,}|" end="$"

syn match  fzaTableRow    "|\|-\+" contained containedin=fzaTable
hi def link fzaTableRow  Structure
" syn region fzaTableCell contained oneline
"       \ start="|" end="|"  " contains=fzaTableRow
" hi def link fzaTableCell  Structure

" NOTE transparent may be useful for highlighting first word in list of syns
" DISABLED: because distracts attention from other meanings
" syn region fzaSynMain  contained keepend oneline
"       \ start=":"ms=s+1  end=",\|#"me=e-1 end="$"
" hi def link fzaSynMain Keyword
" syn region fzaSynonyms start="\v\|@1<=%([^|]+$)@=" end="$" keepend contains=fzaSynMain
" hi def link fzaSynonyms Comment


""" Lexems
" ATTENTION THINK one file is logically inconvinient -- as you need
"   different specific terms for different books, read at the same time
let lang_groups = [
      \ ['syn include @%s %s', 'fzaLxmOriginG', 'origin'],
      \ ['syn include @%s %s', 'fzaLxmPhoneticG', 'phonetic'],
      \ ['source %s%s', '', 'colors'],
      \]  " <sfile>:p:h/fza_jap.vim
for [fmt, grp, nm] in lang_groups
  let path=expand('~/.cache/forestanza/'.nm.'.vim')
  if filereadable(path)
    exe printf(fmt, grp, path)
  endif
endfor



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

"" USE 'display' for jap lexems (oneliners/words only)
"" USE 'nextgroup' for jap composite words -- highlight <1> only if after <2>

"" NOTE contains= --  allows to start inside, recursivly extend,
" ALL | ALLBUT,{gr-nm},.. | TOP | TOP,{gr-nm},..  CONTAINED | CONTAINED,{gr-nm},..
" Can use patt for all already defined groups =Comment.*,Keyw[0-3] OR ALLBUT,<patt>
" USE: patt/list after other rules, no necessary for 'contains' in them,
" syn keyword myword HELP containedin=cComment contained

"" NOTE matchgroup=  -- different highlight for matches
" syn region String matchgroup=Quote start=+"+  skip=+\\"+	end=+"+
" NOTE -- you can use several matchgroup=, start= and end= in one :syn

"" NOTE External back-ref grouping -- can't refer multiline matches
" syn region hereDoc start="<<\z(\I\i*\)" end="^\z1$"
" syn region foo start="start \(\I\i*\)" skip="not end \z1" end="end \z1"

"" NOTE 'oneline' -- end of start patt and start of end patt -- within one line.
" -- This can't be changed by a skip pattern that matches a line break.

"" NOTE cluster order
" syn keyword A aaa
" syn keyword B bbb
" syn cluster SmallGroup contains=B
" syn cluster BigGroup contains=A,@SmallGroup
" syn match Stuff "( aaa bbb )" contains=@BigGroup
" syn cluster BigGroup remove=B	" no effect, since B isn't in BigGroup
" syn cluster SmallGroup remove=B	" now bbb isn't matched within Stuff

" WARNING
" The contained groups will also match in the start and end patterns of a
" region.  If this is not wanted, the "matchgroup" argument can be used
" |:syn-matchgroup|.  The "ms=" and "me=" offsets can be used to change the
" region where contained items do match.	Note that this may also limit the
" area that is highlighted
