#!/bin/bash

function _tmux()
{
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  #
  #  The basic options we'll complete.
  #
  opts=$(tmux -q list-commands)

 COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
 return 0
}

complete -F _tmux tmux
