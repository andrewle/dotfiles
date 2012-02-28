" Based on
runtime bundle/solarized/colors/solarized.vim

let g:colors_name = "ale_solarized_dark"

hi! link rubyClass             Keyword
hi! link rubyModule            Keyword
hi! link rubyKeyword           Keyword
hi! link rubyDefine            Keyword
hi! link rubyOperator          Operator
hi! link rubyIdentifier        Identifier
hi! link rubyInstanceVariable  Identifier
hi! link rubyGlobalVariable    Identifier
hi! link rubyClassVariable     Identifier
hi! link rubyConstant          Type

hi visual     ctermfg=none ctermbg=235  cterm=none
hi SignColumn ctermfg=none ctermbg=none cterm=none

hi NonText    ctermfg=235 ctermbg=none
hi SpecialKey ctermfg=235 ctermbg=none

hi clear SpellBad
hi SpellBad ctermfg=88 cterm=underline
hi ErrorLine ctermbg=52 ctermfg=white

" Highlight presence of trailing whitespace
hi ExtraWhitespace ctermbg=52 guibg=#5f0000
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Textile Syntax Highlighting
hi! link txtHeader Title
hi! link txtHeader2 Title
hi! link txtHeader3 Title
hi! link txtBlockquote Comment
hi! link txtBlockquote2 Comment
hi! link txtListBullet Operator
hi! link txtListBullet2 Constant
hi! link txtListNumber Operator
hi! link txtListNumber2 Constant
hi! link txtLink String
hi! link txtCode Identifier
hi! link txtBold Type
hi txtEmphasis term=underline cterm=underline gui=italic

