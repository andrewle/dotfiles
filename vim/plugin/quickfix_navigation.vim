if exists("g:loaded_quickfix_navigation")
  finish
endif

" Maps Quickfix Navigation to the rewind, play/pause, and fast-forward keys
" on a Mac keyboard
noremap <F8> :call ToggleList('Quickfix List', 'c')<cr>
noremap <F9> :cnext<cr>
noremap <F7> :cprev<cr>
noremap <S-F7> :cfirst<cr>
noremap <S-F9> :clast<cr>

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction
