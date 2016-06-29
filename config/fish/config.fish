# Environment #############################
set fish_greeting ""
set -xg JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
set -xg GOBIN "~/Projects/golang/bin"
set -xg NPM_BIN /usr/local/share/npm/bin
set -xg POSTGRESAPP /Applications/Postgres.app/Contents/Versions/9.4/bin
set -xg PATH ~/bin $POSTGRESAPP $PATH $NPM_BIN $JAVA_HOME
set -xg PATH /Users/andrewle/.cargo/bin $PATH
set -xg CLICOLOR true
set -xg LSCOLORS "exfxcxdxbxegedabagacad"
set -xg PAGER less
set -xg LESS "-RSXF --tabs=4"
set -xg EDITOR vim
set -xg CDPATH $CDPATH . ~/Work

# Command Aliases ##########################
alias photoshop="open -a /Applications/Adobe\ Creative\ Suite\ 3/Adobe\ Photoshop\ CS3/Adobe\ Photoshop\ CS3.app/"
alias preview="open -a preview"
alias dotfiles="cd ~/.dotfiles"
alias gr=gitroot
alias g=git
alias tmr="tmux attach-session"
alias md5sum=md5
alias h=heroku
alias be="bundle exec"

# Load rbenv shims and autocompletion
status --is-interactive; and . (rbenv init -|psub)

# Load up lib files
for i in (ls ~/.config/fish/lib/*.fish)
  source $i
end
