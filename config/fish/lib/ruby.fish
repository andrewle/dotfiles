function r
  if test -f Gemfile
    bundle exec rails $argv
  else
    rails $argv
  end
end

function rspec
  if test -f Gemfile
    bundle exec rspec $argv
  else
    command rspec $argv
  end
end

function rake
  if test -f Gemfile
    bundle exec rake $argv
  else
    command rake $argv
  end
end
