class CheckSeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.configuration.neo_nodes.each do |node_url|
      begin
        node = Node.find_or_create_by(url: node_url)
        height = nil
        time = Benchmark.measure {
          height = Node.rpc 'getblockcount', url: node_url
        }
        node.update_attributes({
          status: true,
          block_height: height,
          time: "%.4fs" % time.real
        })
      rescue StandardError => e
        raise e
        node.update_attributes({ status: false })
      end
    end
  end
end
