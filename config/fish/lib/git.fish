function __go-to-git-root
  cd (git rev-parse --show-toplevel)
end

function gitroot
  if pwd != (git rev-parse --show-toplevel)
    __go-to-git-root
  else if test (cd ..; and git rev-parse --is-inside-work-tree > /dev/null ^&1; echo $status) -eq 0
    cd ..; and __go-to-git-root
  end
end
