# Environment #############################
set fish_greeting ""
set -xg JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_60.jdk/Contents/Home
set -xg GOBIN "~/Projects/golang/bin"
set -xg NPM_BIN /usr/local/share/npm/bin
set -xg POSTGRESAPP /Applications/Postgres.app/Contents/Versions/9.6/bin
set -xg PATH ~/bin $POSTGRESAPP $PATH $NPM_BIN $JAVA_HOME
set -xg PATH /Users/andrewle/.cargo/bin $PATH
set -xg CLICOLOR true
set -xg LSCOLORS "exfxcxdxbxegedabagacad"
set -xg PAGER less
set -xg LESS "-RSXF --tabs=4"
set -xg EDITOR vim
set -xg CDPATH $CDPATH . ~/Work

# Command Aliases ##########################
alias preview="open -a preview"
alias dotfiles="cd ~/.dotfiles"
alias gr=gitroot
alias g=git
alias tmr="tmux attach-session"
alias md5sum=md5
alias h=heroku
alias be="bundle exec"
alias wip="git aa; git ci -m 'WIP'"
alias unwip="git reset head^"

# Load rbenv shims and autocompletion
status --is-interactive; and . (rbenv init -|psub)

# Load up lib files
for i in (ls ~/.config/fish/lib/*.fish)
  source $i
end
source ~/.asdf/asdf.fish
source ~/.asdf/asdf.fish
source ~/.asdf/asdf.fish

if test -f "/Users/andrewle/.shopify-app-cli/shopify.fish"
  source "/Users/andrewle/.shopify-app-cli/shopify.fish"
end
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths
