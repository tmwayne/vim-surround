" Description: Add single quotes to highlighted text
" Author: Tyler Wayne
" Last Modified: 2019-11-09

" {{{ Mappings ---------- 
"
let maplocalleader = '\'

" nnoremap <leader>' :set operatorfunc=<SID>Surround<cr>g@
vnoremap <silent> <localleader>a" :<c-u>call <sid>Surround(visualmode(), '"')<cr>
vnoremap <silent> <localleader>a' :<c-u>call <SID>Surround(visualmode(), "'")<cr>
vnoremap <silent> <localleader>a( :<c-u>call <SID>Surround(visualmode(), ["(", ")"])<cr>
vnoremap <silent> <localleader>a[ :<c-u>call <SID>Surround(visualmode(), ["[", "]"])<cr>
vnoremap <silent> <localleader>a{ :<c-u>call <SID>Surround(visualmode(), ["{", "}"])<cr>

nnoremap <silent> <localleader>a; :call Punctuate("char", ";")<cr>
vnoremap <silent> <localleader>a; :<c-u>call Punctuate(visualmode(), ";")<cr>

nnoremap <silent> <localleader>a, :call Punctuate("char", ",")<cr>
vnoremap <silent> <localleader>a, :<c-u>call Punctuate(visualmode(), ",")<cr>

" }}}

" {{{ Functions ----------

function! s:Surround(type, char)
  let saved_reg = @@
  if type(a:char) ==# v:t_string
    let char = [a:char, a:char]
  else
    let char = a:char
  endif

  " Test if surround marks are present
  normal! '<yl
  let start = @@
  normal! `>yl
  let end = @@

  if start ==# char[0] && end ==# char[1]
    let add_quote = 0
  else
    let add_quote = 1
  endif

  " Add surrounding marks
  if add_quote
    if a:type ==# 'v'
      execute "normal! `<i" . char[0] . "\<esc>`>la" . char[1] . "\<esc>"
    elseif a:type ==# 'V'
      execute "normal! '<i" . char[0] . "\<esc>`>a" . char[1] . "\<esc>"
    " elseif a:type ==# 'char'
      " normal! `[P`]lp
    endif

  " Remove the surroudning marks
  else
    normal! '<x`>x
  endif

  let @@ = saved_reg
endfunction

function! Punctuate(type, char)
  let saved_reg = @/  
  normal! mm

  if a:type ==# 'V'
    execute "'<,'>s/\\v^(.*)\\s*$/\\1" . a:char
  elseif a:type ==# 'char'
    execute "s/\\v^(.*)\\s*$/\\1" . a:char
  endif

  normal! `m
  let @/ = saved_reg
endfunction

" }}}

