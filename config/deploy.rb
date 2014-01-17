# config valid only for Capistrano 3.1
lock '3.1.0'

set :stages, %w(production staging)
set :default_stage, "production"
# require 'capistrano/ext/multistage'
set :scm, :git
set :application, "soapBox"
set :repo_url, "git@github.com:sahilbathlavinsol/soapbox.git"

set :ssh_options, {
  user: 'sahil'
  # forward_agent: true,
  # keys: ["home/sahil/Downloads/soapBox-alpha.pem"]
}


set :deploy_to, "/var/www/soapBox"

desc "check production task"

task :check_production do
  puts " \n Are you REALLY sure you want to deploy to production?"
  puts " \n Enter the password to continue\n "
  password = STDIN.gets.chomp rescue nil
  if password != 'sahil123'
    puts "\n !!! WRONG PASSWORD !!!"
    exit
  end
end

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

before "deploy", "check_production"
# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
