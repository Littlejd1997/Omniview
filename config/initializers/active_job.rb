require 'sidekiq/api'
if Rails.env.test?
  ActiveJob::Base.queue_adapter = :inline
else
  ActiveJob::Base.queue_adapter = :sidekiq
end
Sidekiq::Queue.new("infinity").clear
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear