function r()
{
  if [ ! -S .zeus.sock ]; then
    rails $*
  else
    case $1 in
      g|d|c)
        echo "Running in Zeus"
        zeus $*
        ;;
      *)
        rails $*
        ;;
    esac
  fi
}

function rspec()
{
  if [ -S .zeus.sock ]; then
    if [[ "$1" -eq "-I" ]]; then
      shift 2
    fi

    zeus rspec $*
  else
    command rspec $*
  fi
}

function testrb()
{
  if [ -S .zeus.sock ]; then
    if [[ "$1" -eq "-I" ]]; then
      shift 2
    fi

    zeus test $*
  else
    command testrb $*
  fi
}

function rake()
{
  if [ -S .zeus.sock ]; then
    zeus rake $*
  else
    command rake $*
  fi
}

