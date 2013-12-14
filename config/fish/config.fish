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
