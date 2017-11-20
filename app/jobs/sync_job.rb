class SyncJob < ApplicationJob
  queue_as :default

  around_perform do |job, block|
    if !running?
      lock!
      block.call
      unlock!
    end
  end

  rescue_from(StandardError) do |exception|
    unlock! if running?
    raise exception
  end

  def perform(*args)
    chain_height = Node.rpc 'getblockcount'
    while (index = Block.height + 1) < chain_height
      data = Node.rpc 'getblock', index, true
      Block.import(data)
      puts "Imported Block: #{index}"
    end
  end

  private

  def lockfile
    Rails.root.join('tmp', 'pids', 'sync_job.lock')
  end

  def lock!
    `touch #{lockfile}`
  end

  def unlock!
    `rm #{lockfile}`
  end

  def running?
    File.exists?(lockfile)
  end
end
