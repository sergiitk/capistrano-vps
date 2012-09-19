
require 'capistrano_colors'

unless exists?(:host)
  puts "Pleace specify host by providing -S host=you.server.ip.or.name."
  exit
end

system = "ubuntu"
load "config/recipes/#{system}/base"
load "config/recipes/#{system}/system"
load "config/recipes/#{system}/user"
load "config/recipes/#{system}/postfix"

role :server, host
role :local, "#{ENV['USER']}@localhost"

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash'
ssh_options[:forward_agent] = true

set :current_user, ENV['USER'] unless exists?(:current_user)
