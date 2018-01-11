threads_count = ENV.fetch('RAILS_MAX_THREADS') {5}
threads threads_count, threads_count
environment ENV.fetch('RAILS_ENV') {'development'}
plugin :tmp_restart

if ENV.fetch('RAILS_ENV') {'development'}.to_s == 'production'
  directory '/home/ec2-user/coinkarasu_api'
  daemonize true
  pidfile '/tmp/puma.pid'
  state_path '/tmp/puma.state'
  bind 'unix:///tmp/puma.sock'
  stdout_redirect 'log/puma.log', 'log/puma.error.log', true
else
  port ENV.fetch('PORT') {3000}
end
