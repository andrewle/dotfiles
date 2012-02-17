mappings = {
  "bash_login"    => "~/.bash_login",
  "ackrc"         => "~/.ackrc",
  "tmux.conf"     => "~/.tmux.conf",
  "secure/gemrc"  => "~/.gemrc",
  "git/gitignore" => "~/.gitignore",
  "git/gitconfig" => "~/.gitconfig",
  "psqlrc"        => "~/.psqlrc",
  "vim"           => "~/.vim",
  "vim/vimrc"     => "~/.vimrc",
}

desc 'Install symlinks to dotfiles in the home directory'
task :install do
  pwd = `pwd`.strip

  mappings.each_pair do |src, dest|
    if !File.exist?(File.expand_path(dest))
      sh "ln -s #{pwd}/#{src} #{dest}"
    end
  end

  sh "git submodule update --init"
end

desc 'Uninstall installed dotfile symlinks'
task :uninstall do
  mappings.values.each { |f| sh "rm #{f}" }
end

