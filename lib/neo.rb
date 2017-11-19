require 'net/http'
require 'json'

module Neo
  def self.rpc(method, *params)
    uri = URI(Rails.configuration.neo_nodes.sample)
    uri.query = URI.encode_www_form({ jsonrpc: '2.0', method: method, params: params.to_s, id: 1 })
    response = Net::HTTP.get(uri)
    JSON.parse(response)['result']
  end
end
