" Running Ruby Tests
" Stolen directly from Gary Bernhardt
" with some modifications to support test unit as well
"
let g:current_spec_file = ""

function! InTestFile()
  return match(expand("%"), '_test.rb$') != -1
endfunction

function! InSpecFile()
  return match(expand("%"), '_spec.rb$') != -1
endfunction

function! SelectRubyCompiler(spec)
  let in_spec_file = match(a:spec, '_spec.rb$') != -1

  if in_spec_file
    compiler rspec
  else
    compiler rubyunit
  end
endfunction

function! ALERunNearestSpec()
  if s:InSpecFile()
    let l:spec = "-l " . line(".") . " " . @%
    call SetLastSpecCommand(l:spec)

    call SelectRubyCompiler(l:spec)
    call MakeGreen(l:spec)
  endif
endfunction

function! RunTestFile(...)
  if s:InSpecFile() || InTestFile()
    let l:spec = @%
    let g:last_spec_file = l:spec
  else
    let l:spec = g:last_spec_file
  endif

  call SelectRubyCompiler(l:spec)
  call MakeGreen(l:spec)
endfunction

function! s:InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

augroup ruby
  autocmd BufNewFile,BufRead *.rb      compiler ruby
  autocmd BufNewFile,BufRead *_spec.rb compiler rspec
  autocmd BufNewFile,BufRead *_test.rb compiler rubyunit
augroup end

map <leader>] :call RunTestFile()<cr>
map <leader>s :call ALERunNearestSpec()<cr>
map <silent> <leader>makegreen :call MakeGreen()<cr>
