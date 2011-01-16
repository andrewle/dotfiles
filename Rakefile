desc 'Install symlinks to dotfiles in the home directory'
task :install do
  pwd = `pwd`.strip

  # Vim
  `ln -s #{pwd}/vim ~/.vim`
  `ln -s #{pwd}/vim/vimrc ~/.vimrc`
end
