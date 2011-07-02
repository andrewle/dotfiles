" Running Ruby Tests
" Stolen directly from Gary Bernhardt
" with some modifications to support test unit as well
"
function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo
    if filereadable("script/test")
        exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
        exec ":!bundle exec rspec " . a:filename
    else
        exec ":!rspec " . a:filename
    end
endfunction

" Set the spec file that tests will be run for.
function! SetTestFile()
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    let in_test_file = match(expand("%"), '_test.rb$') != -1
    if in_spec_file || in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

nmap <leader>] :call RunTestFile()<cr>
nmap <leader>t :call SetTestFile()<cr>
