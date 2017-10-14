require 'net/http'
require 'json'

SEEDS = YAML.load_file("#{Rails.root}/config/seed_list.yml")[ENV['NEO_NET'] || 'test']

module Neo
  def self.rpc(method, *params)
    uri = URI(SEEDS.sample)
    uri.query = URI.encode_www_form({ jsonrpc: '2.0', method: method, params: params.to_s, id: 1 })
    response = Net::HTTP.get(uri)
    JSON.parse(response)['result']
  end
end
