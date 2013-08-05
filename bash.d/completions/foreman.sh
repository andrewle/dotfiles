#!/bin/bash

_foreman()
{
  local cur prev opts base
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  #
  #  The basic options we'll complete.
  #
  opts="start check export help run start version -d -f --procfile --root"

  case "${prev}" in
    -f)
      COMPREPLY=( $(compgen -f ${cur}) )
      return 0
      ;;
    *)
      ;;
  esac

  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
  return 0
}
complete -F _foreman foreman
