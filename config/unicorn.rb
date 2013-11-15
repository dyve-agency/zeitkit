env = ENV["RAILS_ENV"] || "development"

pid "/tmp/unicorn.zeitkit.pid"
listen "/tmp/zeitkit.sock", :backlog => 64
preload_app true
timeout 20
# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "/home/zeitkit/apps/zeitkit"

# feel free to point this anywhere accessible on the filesystem
shared_path = "/home/zeitkit/apps/zeitkit"

stderr_path "#{shared_path}/log/unicorn.zeitkit.stderr.log"
stdout_path "#{shared_path}/log/unicorn.zeitkit.stdout.log"

if env == "production"
  # Production specific settings
  worker_processes 8
else
  worker_processes 4
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "tmp/unicorn.zeitkit.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
