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

namespace :logs do
  desc 'tail -f log/env.log'
  task :tail do
    queue %Q[echo "-----> Tail for #{rails_env}.log"]
    queue echo_cmd %[cd #{deploy_to}/#{current_path}; tail -f log/#{rails_env}.log && exit]
  end

  task :show do
    n = ENV['n'] || 15
    queue %Q[echo "----->  Last #{n} lines of #{rails_env}.log"]
    queue echo_cmd %[cd #{deploy_to}/#{current_path}; tail -n#{n} log/#{rails_env}.log && exit]
  end
end

namespace :puma do
  desc 'Start puma'
  taks :start do
    queue 'excho "-----> Starting Puma"'
    queue! %{
      echo #{rails_env}
      echo #{release_path}
      cd #{deploy_to}/current
      #{bundle_exec} puma -C #{deploy_to}/current/config/puma.rb -E #{rails_env} -D
    }
  end

  desc 'Stop puma'
  task :stop do 
    queue 'echo "-----> Stopping Puma"'
    queue! %{
      test -s "#{pid_file}" && kill -QUIT `cat "#{pid_file}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
    } 
  end

  desc "Restart puma gracefully"
  task :restart => :environment do
    queue 'echo "-----> Restarting Puma"'
    queue! %{
      echo `cat "#{pid_file}"`
      test -s "#{pid_file}" && kill -USR2 `cat "#{pid_file}"` && echo "Restart Ok" && exit 0
      echo >&2 "Restarted."
    } 
  end
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

