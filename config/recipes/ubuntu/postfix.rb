namespace :ubuntu do
  namespace :postfix do
    desc <<-DESC
      Setup mail system.
    DESC
    task :install, :roles => :server do
      set :user, current_user
      run "#{sudo} DEBIAN_FRONTEND='noninteractive' apt-get install postfix"
    end
  end
end
