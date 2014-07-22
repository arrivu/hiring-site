config = {
  :backend => 'active_record',
}.merge((Setting.from_config('delayed_jobs') || {}).symbolize_keys)

case config[:backend]
when 'active_record'
  Delayed::Job = Delayed::Backend::ActiveRecord::Job
when 'redis'
  if Rails.env.production?
    raise "Redis Jobs are not yet ready for production"
  end
  Delayed::Job = Delayed::Backend::Redis::Job
  Delayed::Backend::Redis::Job.redis = if config[:redis]
    Canvas.redis_from_config(config[:redis])
  else
    Canvas.redis
  end
else
  raise "Unknown Delayed Jobs backend: `#{config[:backend]}`"
end

# If there is a sub-hash under the 'queue' key for the database config, use that
# as the connection for the job queue. The migration that creates the
# delayed_jobs table is smart enough to use this connection as well.
db_queue_config = ActiveRecord::Base.configurations[Rails.env]['queue']
if db_queue_config
  Delayed::Backend::ActiveRecord::Job.establish_connection(db_queue_config)
end

Delayed::Worker.on_max_failures = proc do |job, err|
  # We don't want to keep around max_attempts failed jobs that failed because the
  # underlying AR object was destroyed.
  # All other failures are kept for inspection.
  err.is_a?(Delayed::Backend::RecordNotFound)
end

Delayed::Worker.lifecycle.around(:perform) do |worker, job, &block|
  starting_mem = Canvas.sample_memory()
  starting_cpu = Process.times()
  begin
    block.call(worker, job)
  ensure
    ending_cpu = Process.times()
    ending_mem = Canvas.sample_memory()
    user_cpu = ending_cpu.utime - starting_cpu.utime
    system_cpu = ending_cpu.stime - starting_cpu.stime

    Rails.logger.info "[STAT] #{starting_mem} #{ending_mem} #{ending_mem - starting_mem} #{user_cpu} #{system_cpu}"
  end
end

if Rails.env.development?
  Rails.logger.info "Delayed::Job is executed synchronously in #{Rails.env} mode."
  Delayed::Job.class_eval do
    def self.enqueue(obj,xyz)
      Rails.logger.info "Delayed::Job:SYNC START"
      #obj[:payload_object].perform
      obj.perform
      Rails.logger.info "Delayed::Job:SYNC END"
    end
  end
end
