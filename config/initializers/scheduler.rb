require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

if Rails.const_defined? "Server"
  CheckSeedsJob.perform_now

  scheduler.every '5s' do
    SyncJob.perform_later
  end

  scheduler.every '30s' do
    CheckSeedsJob.perform_later
  end
end
