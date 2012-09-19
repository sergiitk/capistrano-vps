namespace :ubuntu do

  desc "Upgrade packages."
  task :packages_upgrade, :roles => :server do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y upgrade"
    run "#{sudo} apt-get -y autoremove"
    run "#{sudo} apt-get -y autoclean"
  end

  def package_install(name)
    run "#{sudo} apt-get -y install #{name}"
  end

  def account_add(name, copy_ssh_key = false)
    run "#{sudo} useradd -m -s /bin/bash #{name}"

    password   = Capistrano::CLI.password_prompt("Enter new password for #{name}:")
    password_c = Capistrano::CLI.password_prompt("Retype new password for #{name}:")
    run "#{sudo} passwd #{name}" do |ch, stream, out|
      if out =~ /Enter new UNIX password:/
        ch.send_data password + "\n"
      end
      if out =~ /Retype new UNIX password:/
        ch.send_data password_c + "\n"
      end
    end

    if copy_ssh_key
      run "/opt/local/bin/ssh-copy-id #{current_user}@#{host}", :roles => :local do |ch, stream, out|
        if out =~ /The authenticity of host/
          ch.send_data "yes" + "\n"
        end
        if out =~ /password:/
          ch.send_data password + "\n"
        end
      end
    end
  end

  def account_lock(name)
    logger.important "Lock '#{name}' account."
    run "usermod -L #{name}"
  end

  def service(name, action)
    run "#{sudo} service #{name.to_s} #{action.to_s}"
  end

  def template(from, to)
    erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
    put ERB.new(erb).result(binding), to
  end

end
