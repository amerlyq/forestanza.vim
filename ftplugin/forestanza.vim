if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1
let b:undo_ftplugin = "setl ts< sw<"

" Line-format has no sense for widechar lines, being treated as one long word
setl autoindent nocindent indentexpr=
setl tabstop=2 shiftwidth=2 softtabstop=2

setl foldmethod=syntax
setl wrap textwidth=80 colorcolumn&
setl formatoptions-=tc
setl formatoptions+=roqmMj
" FIND how to comment out only part of line?
" BUG nested comment indention don't work
setl comments=s:#,e:#,b:#,b::,b:~,:\|,
setl commentstring=#\ %s


"" Key-maps
nnoremap ga :Tabularize /<bar>\<bar>:\<bar>>/l1l1r1c1l1<CR>
nnoremap g; 0f:<Left>
nnoremap g\ 0f<bar><Right>
