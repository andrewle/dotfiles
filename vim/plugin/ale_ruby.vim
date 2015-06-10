if exists("g:loaded_ale_ruby")
  finish
endif

if !has("ruby")
  echohl ErrorMsg
  echon "Sorry, ALE Ruby requires ruby support."
  finish
endif

let g:loaded_ale_ruby = "true"

function! ALERubyClassName()
  let l:output = ""
  ruby ruby_class_name_from_path
  return l:output
endfunction

function! ALERubyNestedModuleDef()
  let l:output = ""
  ruby ruby_nested_module_def_from_path
  return l:output
endfunction

function! ALERubyNestedModuleEnd()
  let l:output = ""
  ruby ruby_nested_module_end_from_path
  return l:output
endfunction

function! ALERSpecDescribe()
  let l:output = ""
  ruby rspec_describe_from_path
  return l:output
endfunction

function! ALERSpecFeature()
  let l:output = ""
  ruby rspec_feature_from_path
  return l:output
endfunction

ruby << EOF
require 'pathname'

def ruby_class_name_from_path
  full_path = VIM.evaluate("expand('%:p')")
  pwd = Pathname.pwd.to_s + "/"
  path = full_path.gsub(pwd, '')

  case path
  when /^test\/unit\/.*?_test.rb/
    template = "%s < ActiveSupport::TestCase"
  when /^test\/functional\/.*?_test.rb/
    template = "%s < ActionController::TestCase"
  when /^test\/integration\/.*?_test.rb/
    template = "%s < ActionDispatch::IntegrationTest"
  else
    template = "%s"
  end

  klass  = classify(strip_head_paths(path.gsub(/\.rb$/, '')))
  output = template % klass
  VIM.command('let l:output = "%s"' % output)
end

def ruby_nested_module_def_from_path
  with_class_name do |klass|
    klass_parts = klass.split("::")

    if klass_parts.count > 1
      output = <<CLASS
module #{klass_parts.first}
  class #{klass_parts[1..-1].join("::")}
    
CLASS
    else
      output = <<CLASS
module #{klass_parts.first}
  
CLASS
    end

    output
  end
end

def ruby_nested_module_end_from_path
  with_class_name do |klass|
    klass_parts = klass.split("::")

    if klass_parts.count > 1
      output = ""
      1.downto(0) do |i|
        output << ("  " * i) + "end\n"
      end
    else
      output = "end"
    end

    output
  end
end

def rspec_describe_from_path
  full_path = VIM.evaluate("expand('%:p')")
  pwd  = Pathname.pwd.to_s + "/"
  path = full_path.gsub(pwd, '')
  num  = VIM::Buffer.current.line_number

  if num == 1 && path =~ /^spec\/(.*?\/)*.*?_spec.rb/
    template = "%s"
  else
    template = ""
  end

  klass  = classify(strip_head_paths(path.gsub(/_spec\.rb$/, '')))
  output = template % klass
  VIM.command('let l:output = "%s"' % output)
end

def rspec_feature_from_path
  full_path = VIM.evaluate("expand('%:p')")
  pwd  = Pathname.pwd.to_s + "/"
  path = full_path.gsub(pwd, '')
  num  = VIM::Buffer.current.line_number

  if num == 1 && path =~ /^spec\/(.*?\/)*.*?_spec.rb/
    template = "%s"
  else
    template = ""
  end

  name  = strip_head_paths(path.gsub(/_spec\.rb$/, ''))
  name  = name.gsub("_", " ")
  name  = titleize(name)
  output = template % name
  VIM.command('let l:output = "%s"' % output)
end

def with_class_name(&block)
  full_path = VIM.evaluate("expand('%:p')")
  pwd = Pathname.pwd.to_s + "/"
  path = full_path.gsub(pwd, '')
  klass  = classify(strip_head_paths(path.gsub(/\.rb$/, '')))
  output = yield klass
  VIM.command('let l:output = "%s"' % output)
end

def strip_head_paths(path)
  path.gsub(/^(app(\/(\w+))|spec(\/(\w+))|lib|test(\/(\w+)))\//, '')
end

def classify(path)
  camelize(path.to_s.sub(/.*\./, ''))
end

def camelize(term)
  string = term.to_s.sub(/^[a-z\d]*/) { $&.capitalize }
  string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
end

def titleize(str)
  str.gsub(/\b[a-z]/) { $&.capitalize }
end
EOF
