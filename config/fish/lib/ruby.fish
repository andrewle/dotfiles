function r
  if test -S .zeus.sock -a (count $argv) -gt 0
    switch $argv[1]
      case g d c
        echo "Running in Zeus"
        zeus $argv
      case '*'
        rails $argv
    end
  else
    rails $argv
  end
end

function __ruby_run_in_zeus
  if test -S .zeus.sock
    zeus $argv
  else
    command $argv
  end
end

function rspec
  __ruby_run_in_zeus 'rspec' $argv
end

function testrb
  __ruby_run_in_zeus 'testrb' $argv
end

function rake
  __ruby_run_in_zeus 'rake' $argv
end
