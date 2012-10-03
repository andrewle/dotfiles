#!/bin/bash

_bundle()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
    opts="install update check"

   COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
   return 0
}
complete -F _bundle bundle
