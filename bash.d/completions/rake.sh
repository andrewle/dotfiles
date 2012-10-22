#!/bin/bash

_rake()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

   COMPREPLY=($(compgen -W "$(rake -T | awk '{print $2}')" -- ${cur}))
   return 0
}
complete -F _rake rake
