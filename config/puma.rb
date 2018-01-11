threads_count = ENV.fetch("RAILS_MAX_THREADS") {5}
threads threads_count, threads_count
environment ENV.fetch("RAILS_ENV") {"development"}
plugin :tmp_restart

if Rails.env.production?
  pidfile '/tmp/puma.pid'
  bind 'unix:///tmp/puma.sock'
  directory '/home/ec2-user/coinkarasu_api'
else
  port ENV.fetch("PORT") {3000}
end
