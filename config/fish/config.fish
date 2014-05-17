# Environment #############################
set fish_greeting ""
set -xg JAVA_HOME /System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home
set -xg GOBIN "~/Projects/golang/bin"
set -xg NPM_BIN /usr/local/share/npm/bin
set -xg POSTGRESAPP /Applications/Postgres.app/Contents/MacOS/bin
set -xg PATH ~/bin $POSTGRESAPP $PATH $NPM_BIN
set -xg CLICOLOR true
set -xg LSCOLORS "exfxcxdxbxegedabagacad"
set -xg PAGER less
set -xg LESS "-RSXF --tabs=4"
set -xg EDITOR vim

# Command Aliases ##########################
alias photoshop="open -a /Applications/Adobe\ Creative\ Suite\ 3/Adobe\ Photoshop\ CS3/Adobe\ Photoshop\ CS3.app/"
alias preview="open -a preview"
alias dotfiles="cd ~/.dotfiles"
alias gr=gitroot
alias g=git
alias tmr="tmux attach-session"
alias md5sum=md5

# Load up lib files
for i in (ls ~/.config/fish/lib/*.fish)
  source $i
end
