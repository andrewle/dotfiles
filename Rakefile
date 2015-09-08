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
  "dotjs"         => "~/.js",
  "config"        => "~/.config",
  ".irbrc"        => "~/.irbrc",
}

desc 'Install symlinks to dotfiles in the home directory'
task :install do
  pwd = `pwd`.strip

  mappings.each_pair do |src, dest|
    if !File.exist?(File.expand_path(dest))
      sh "ln -s #{pwd}/#{src} #{dest}"
    end
  end

  if /darwin/ =~ RUBY_PLATFORM
    puts "Installing Divvy preferences"
    plist_name = "com.mizage.direct.Divvy.plist"
    divvy_prefs = File.join(File.dirname(__FILE__), "mac", "preferences", plist_name)
    sh "rm ~/Library/Preferences/#{plist_name} || true"
    sh "ln -s #{divvy_prefs} ~/Library/Preferences/#{plist_name}"
  end

  sh "git submodule update --init"
end

desc 'Uninstall installed dotfile symlinks'
task :uninstall do
  mappings.values.each { |f| sh "rm #{f}" }
end
