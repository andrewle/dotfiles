#!/bin/bash

function gitroot {
  if [ "$(pwd)" != "$(git rev-parse --show-toplevel)" ]; then
    go-to-git-root
  elif [ $(cd .. && git rev-parse --is-inside-work-tree &> /dev/null; echo $?) -eq 0 ]; then
    cd .. && go-to-git-root
  fi
}

function go-to-git-root {
  cd $(git rev-parse --show-toplevel)
}

function git-last-branch {
  current_branch=$(git branch | grep -v '(no branch)' | grep "\*" |
  awk '{print $2}')

  # support when running this from a detached head
  if [ "${current_branch}" == "" ]; then
    current_branch=$(git rev-list --max-count=1 HEAD)
  fi;

  git reflog | \
    grep -m 1 "checkout:.*to ${current_branch}$" | \
    sed 's/.*from \([^ ]*\).*/\1/'
}

function git-checkout-last-branch {
  git checkout $(git-last-branch)
}

function git-merge-last-branch {
  git merge --no-ff $(git-last-branch)
}

