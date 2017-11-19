require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

if Rails.const_defined? "Server"
  scheduler.every '20s' do
    SyncJob.perform_later
  end
end
