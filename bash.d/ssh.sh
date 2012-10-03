# Copyright (c) 2007, Roberto Aguilar <berto at chamaco dot org>
# All rights reserved.
#
# Redistribution and use of this software in source and binary forms, with or
# without modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name, "Roberto Aguilar", nor the names of its contributors may
#   be used to endorse or promote products derived from this software without
#   specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

[ -z ${SSH_AGENT_FILE} ] && SSH_AGENT_FILE=${HOME}/.ssh/agent_info
[ -z ${SSHPW_TIME} ] && SSHPW_TIME=32400;

alias ssh-agent-reload="eval \$(cat ${SSH_AGENT_FILE})"

# internal function that sources the ssh agent into the current shell
function _source_ssh_agent
{
    . ${SSH_AGENT_FILE} >> /dev/null

    # link the ssh auth socket to ${USER}-ssh-auth-sock
    socket_symlink="/tmp/${USER}-ssh-auth-sock"
    if [ -h ${socket_symlink} ]; then
        socket_dest=$(readlink ${socket_symlink})
        if [ "${SSH_AUTH_SOCK}" != "${socket_dest}" ]; then
            rm -f ${socket_symlink}
            ln -s ${SSH_AUTH_SOCK} ${socket_symlink}
        fi;
    else
        ln -s ${SSH_AUTH_SOCK} ${socket_symlink}
    fi;
}

# internal function that starts up the ssh agent and writes the ssh agent file
function _start_ssh_agent
{
    [ -e ${SSH_AGENT_FILE} ] && rm ${SSH_AGENT_FILE}

    ssh-agent -s > ${SSH_AGENT_FILE}
    _source_ssh_agent
}

# Checks to see if ssh-agent is running, and links it to the shell.
# If it is not, start up a new agent.  Once the ssh agent is linked
# to the shell, run ssh-add to add your key's password to memory
function check_ssh_agent
{
    # link to an existing SSH agent, or create a new one.  Sleep a random
    # amount between 0 and 0.25 seconds, which should prevent multiple
    # ssh agents from being created when multiple terminals are launched
    # simultaneously.
    # $RANDOM is a random integer from 0 - 32767; 32767 * 4 gives a number
    # from 0 - 0.25.
    sleep $(echo "scale=2; ($RANDOM / 131068)" | bc)

    # if the authentication socket already exists, the variable was likely
    # setup by ssh -A from the client (ForwardAgent yes in the config).  so,
    # don't do anything.
    if [ "${SSH_AUTH_SOCK}" != "" ]; then
        base=$(basename ${SSH_AUTH_SOCK})

        if [ "${base}" != "Listeners" ]; then
            return;
        fi;
    fi;

    if [ -e ${SSH_AGENT_FILE} ]; then
        _source_ssh_agent
    else
        _start_ssh_agent
    fi;

    # test to make sure the agent started (the agent file may be stale), or
    # else do so here.
    ps aux | grep 'ssh-agent' | grep ${SSH_AGENT_PID} | \
      awk '{print $2}' | grep -q ${SSH_AGENT_PID}

    if [ $? -ne 0 ]; then
        _start_ssh_agent
    fi;
}

# check to see if an ssh agent lists keys.  If not, prompt for a passphrase
function sshpw()
{
    identities=$(ssh-add -l 2>/dev/null)
    status=$?

    # if exit status 2 is given, the ssh agent was not found, try to
    # relocate the agent
    if [ ${status} -eq 2 ]; then
        check_ssh_agent
        identities=$(ssh-add -l)
    fi;

    echo ${identities} | grep 'no identities' > /dev/null
    status=$?

    if [ ${status} -eq 0 ]; then
      echo "no identities found, please add your ssh key passphrase"
      ssh-add -t ${SSHPW_TIME} \
        $(find ${HOME}/.ssh -name '*.pub' | grep -v _keys | sed -e 's/.pub//g');
    fi;

    SSHPW_COMMAND=${SSHPW_COMMAND:-$(which ssh)}

    [ ! -z "$1" ] && ${SSHPW_COMMAND} "$@"
}

# run an ssh session in the background.  This is useful for connection sharing
function sshb()
{
    ssh -f -N "$@"
}

# kill the background ssh session that matches the given argument
function sshbk()
{
    pid=$(ps -efww | grep -v grep | \
        grep -e ".*ssh.*-N.*$1" | awk '{print $2}')

    if [ "${pid}" != "" ]; then
        echo "killing pid: $pid"
        kill ${pid}
    fi;
}

function sshid
{
    [ -z $1 ] && echo "No server given" && return -1

    SSH_ID_KEY=${SSH_ID_KEY:-${HOME}/.ssh/id_rsa.pub}

    cat ${SSH_ID_KEY} | ssh "$@" 'chmod g-w,o-w .; [ ! -e .ssh ] && mkdir .ssh && chmod 0700 .ssh && touch .ssh/authorized_keys && chmod 0600 .ssh/authorized_keys; cat >> .ssh/authorized_keys'

    return $?;
}
