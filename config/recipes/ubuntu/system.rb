namespace :ubuntu do
  namespace :os do
    desc <<-DESC
      Upgrade packages.
      Install python-software-properties zsh vim curl git-core.
      Setup non root user and give it sudo rights.
      Lock root.
      Variables:
        -S current_user to set user to be created, default is '#{ENV['USER']}'.
    DESC
    task :setup, :roles => :server do
      logger.important "Please provide your root password."
      set :user, "root"

      # Hostname.
      put host, "/etc/hostname"
      run "sed -i 's/127.0.0.1 localhost/127.0.0.1 #{host} localhost/' /etc/hosts"
      service :hostname, :restart

      # User.
      account_add current_user, true
      run "gpasswd -a #{current_user} sudo"

      # Packages.
      packages_upgrade
      package_install 'python-software-properties zsh vim curl git-core'
      run "update-alternatives --set editor /usr/bin/vim.basic"
      run "update-alternatives --set vim /usr/bin/vim.basic"

      # Lock root.
      account_lock "root"
      logger.important "Disable root ssh."
      run "sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config"
      service :ssh, :reload
    end
  end
end
