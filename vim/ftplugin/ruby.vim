fun! RubyComplete(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    ruby RubyCompletion.word_start
    return start
  else
    " find months matching with "a:base"
    ruby RubyCompletion.run
    return split(l:options)
  endif
endfun

if has("ruby")
  setlocal completefunc=RubyComplete
endif

ruby << EOF
class RubyCompletion
  def self.completions
    {
      "FactoryGirl" => ["FactoryGirl.create", "FactoryGirl.build", "FactoryGirl.build_stubbed"],
    }
  end

  def self.word_start
    line  = VIM.evaluate("line")
    start = VIM.evaluate("start").to_i - 1
    while line[start] =~ /[\w.]/ && start != 0
      start -= 1
    end
    VIM.command('let start = %s' % start)
  end

  def self.run
    word = VIM.evaluate("a:base")
    if word.include?(".")
      parts = word.split(".")
      if parts.count > 1
        options = Array(completions[parts[0]]).select { |e| e.include?(parts[1]) }
      else
        options = Array(completions[parts[0]])
      end
    else
      options = completions.keys.select { |e| e.start_with?(word) }
    end

    VIM.command('let l:options = "%s"' % options.join(" "))
  end
end
EOF
