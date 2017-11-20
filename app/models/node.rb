require 'net/http'

class Node < ApplicationRecord

  def self.best
    order(block_height: :desc, time: :asc).first
  end

  def self.rpc(method, *params, **options)
    uri = URI(options[:url] || Node.best.url)
    uri.query = URI.encode_www_form({ jsonrpc: '2.0', method: method, params: params.to_s, id: 1 })
    response = Net::HTTP.get(uri)
    JSON.parse(response)['result']
  end
end
