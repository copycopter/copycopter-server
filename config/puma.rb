app_dir = '/home/dev/apps/exchanges_copycopter'
shared_path = "#{app_dir}/shared"

directory "#{app_dir}/current"

environment 'production'
daemonize true

pidfile "#{shared_path}/pids/puma.pid"

state_path "#{shared_path}/pids/puma.state"

stdout_redirect '#{shared_path}/log/puma.stdout.log', '#{shared_path}/log/puma.stderr.log', true

threads 0, 16


bind "unix://#{shared_path}/sockets/puma.sock"

workers 2

activate_control_app "unix://#{shared_path}/sockets/pumactl.sock"

