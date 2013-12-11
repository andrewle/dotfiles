#!/bin/bash

_zeus()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we'll complete.
    #
    opts="start cucumber test generate rake destroy init commands"

   COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
   return 0
}
complete -F _zeus zeus
