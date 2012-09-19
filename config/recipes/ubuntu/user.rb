namespace :ubuntu do
  namespace :user do
    desc <<-DESC
      Setup .vimrc, shell, oh-my-zsh, zsh theme, .zshrc.
      Variables:
        -S current_user to set user to be created, default is '#{ENV['USER']}'.
    DESC
    task :setup, :roles => :server do
      set :user, current_user
      password = Capistrano::CLI.password_prompt("#{current_user}'s password:")

      # Set default shell.
      run "chsh -s /bin/zsh"  do |ch, stream, out|
        if out =~ /Password:/
          ch.send_data password + "\n"
        end
      end

      # Vim.
      template "vimrc.erb", ".vimrc"

      # Oh my zsh.
      run "if [[ -d .oh-my-zsh ]] ; then rm -rf .oh-my-zsh ; fi"
      run "hash git >/dev/null && /usr/bin/env git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
      template "zshrc.erb", ".zshrc"
      template "rich.zsh-theme.erb", ".oh-my-zsh/themes/rich.zsh-theme"
      run 'echo "export PATH=$PATH" >> ~/.zshrc'
    end
  end
end
