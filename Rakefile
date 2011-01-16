desc 'Install symlinks to dotfiles in the home directory'
task :install do
  pwd = `pwd`.strip

  `ln -s #{pwd}/bash_login ~/.bash_login`
  `ln -s #{pwd}/ackrc ~/.ackrc`

  # Vim
  `ln -s #{pwd}/vim ~/.vim`
  `ln -s #{pwd}/vim/vimrc ~/.vimrc`
end

desc 'Uninstall installed dotfile symlinks'
task :uninstall do
  syms = %w{ .bash_login .ackrc .vim .vimrc }
  syms.each { |f| `rm ~/#{f}` }
end
