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

function rspec
  if test -S .zeus.sock
    zeus $argv
  else
    command rspec $argv
  end
end

function testrb
  if test -S .zeus.sock
    zeus $argv
  else
    command testrb $argv
  end
end

function rake
  if test -S .zeus.sock
    zeus $argv
  else
    command rake $argv
  end
end
