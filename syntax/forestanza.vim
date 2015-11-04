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


sy sync fromstart
"" USE as common for separate *.fjp, *.fkr
" runtime! syntax/forestanza.vim

""" Lexems
" sy keyword fzaMarks  NOT contained
" hi def link fzaMarks  Underlined

sy match  fzaTable    '|'
" sy match  fzaBrace1   '[()]'   contained
sy match  fzaBrace2   '[\[\]]' contained
sy match  fzaBrace3   '[{}]'   contained
""" Styles -- ignore if already specified
hi def link fzaTable  Structure
" hi def link fzaBrace1 Normal
hi def link fzaBrace2 Statement
hi def link fzaBrace3 Function

"" Highlights three levels of parentheses
sy region fzaPars1 matchgroup=fzaPars1 start="(" end=")" contains=fzaPars2
sy region fzaPars2 matchgroup=fzaPars2 start="(" end=")" contains=fzaPars3 contained
sy region fzaPars3 matchgroup=fzaPars3 start="(" end=")" contains=fzaPars1 contained
hi def link fzaPars1 Statement
hi def link fzaPars2 Structure
hi def link fzaPars3 Special

"" USE for jap numbers
sy match  fzaNumber   '[0-9]\+'
hi def link fzaNumber Number


""" Regions
sy region fzaOrigin
      \ start="\v^\_s*[^:~|<]" end="\v^\_s*[:~|<]"me=e-1
      \ keepend contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
sy region fzaPhonetics
      \ start="\v^\_s*:" end="\v^\_s*[^:]"me=e-1
      \ keepend contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3
sy region fzaTranslation
      \ start="\v^\_s*\~" end="\v^\_s*[^\~]"me=e-1
      \ keepend contains=fzaPars1,fzaBrace1,fzaBrace2,fzaBrace3

sy region fzaSynonyms start="|\@1<=[^|]\+$" end="$" keepend

hi def link fzaOrigin Normal
hi def link fzaPhonetics Comment
hi def link fzaTranslation Statement
hi def link fzaSynonyms Comment


""" Footer
let b:current_syntax = 'forestanza'
let &cpo = s:save_cpo
unlet s:save_cpo

""" Test
" :so $VIMRUNTIME/syntax/hitest.vim
" :syntax reset -- only 'matches' not 'colors'
"" Profile
" :syntime on
" [ redraw the text at least once with CTRL-L ]
" :syntime report
