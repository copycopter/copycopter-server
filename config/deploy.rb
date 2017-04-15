require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain, 'exchang.es'
set :repository, 'git@github.com/tandp/exchanges_copycopter.git'
set :branch, 'master'
set :user, 'dev'

set :forward_agent, true
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :rails_env, 'production'
set :deploy_to, '/home/dev/apps/exchanges_copycopter'
set :pid_file, "#{deploy_to}/shared/pids/puma.pid"
set :shared_paths, ['config/database.yml', 'log']

set :abs_current_path, "#{deploy_to}/current"
set :abs_shared_path, "#{deploy_to}/shared"

set :bin_path, "#{rbenv_path}/shims"
set :bundle_exec, "#{bin_path}/bundle exec"
# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{abs_shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{abs_shared_path}/log"]

  queue! %[mkdir -p "#{abs_shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{abs_shared_path}/pids"]

  queue! %[mkdir -p "#{abs_shared_path}/sockets"]
  queue! %[chmod g+rx,u+rwx "#{abs_shared_path}/sockets"]

  queue! %[mkdir -p "#{abs_shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{abs_shared_path}/config"]

  queue! %[touch "#{abs_shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{abs_shared_path}/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile:force'

    to :launch do
      invoke 'puma:restart'
    end
  end
end


namespace :puma do
  desc 'Start puma'
  task :start do
    queue 'echo "-----> Starting puma"'
    queue! %{
      cd #{deploy_to}/current
      #{bundle_exec} pumactl -S #{deploy_to}/shared/sockets/puma.state --config config/puma.rb start
    }
  end
 
  desc 'Stop puma'
  task :stop do 
    queue 'echo "-----> Stopping puma"'
    queue! %{
      pumactl -S #{deploy_to}/shared/sockets/puma.state stop && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    } 
  end
 
  desc "Restart puma gracefully"
  task :restart => :environment do
    queue 'echo "-----> Restarting puma"'
    queue! %{
      echo `cat "#{puma_pid}"`
      pumactl -S #{deploy_to}/shared/sockets/puma.state phased-restart && echo "Restart Ok" && exit 0
      echo >&2 "Restarted."
    } 
  end
end
