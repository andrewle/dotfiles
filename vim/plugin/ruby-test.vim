" Running Ruby Tests
" Stolen directly from Gary Bernhardt
" with some modifications to support test unit as well
"
function! SetTestFile()
    let g:grb_test_file=expand("%:p")
endfunction

function! SelectRubyCompiler()
    let in_spec_file = match(g:grb_test_file, '_spec.rb$') != -1
    if in_spec_file
      compiler rspec
    else
      compiler rubyunit
    end
endfunction

function! RunTestFile(...)
    let command_suffix = a:0 ? a:1 : ""
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    let in_test_file = match(expand("%"), '_test.rb$') != -1

    if in_spec_file || in_test_file
        call SetTestFile()
    elseif !exists("g:grb_test_file")
        echo "No test file marked to run"
        return
    end

    call SelectRubyCompiler()
    call MakeGreen(g:grb_test_file . command_suffix)
endfunction

augroup ruby
    autocmd BufNewFile,BufRead *.rb      compiler ruby
    autocmd BufNewFile,BufRead *_spec.rb compiler rspec
    autocmd BufNewFile,BufRead *_test.rb compiler rubyunit
augroup end

nmap <leader>] :call RunTestFile()<cr>
map <silent> <leader>makegreen :call MakeGreen()<cr>

