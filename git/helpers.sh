#!/bin/bash

gitroot() {
  if [ "$(pwd)" != "$(git rev-parse --show-toplevel)" ]; then
    go_to_git_root
  elif [ $(cd .. && git rev-parse --is-inside-work-tree &> /dev/null; echo $?) -eq 0 ]; then
    cd .. && go_to_git_root
  fi
}

go_to_git_root() {
  cd $(git rev-parse --show-toplevel)
}
