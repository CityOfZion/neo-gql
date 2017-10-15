require 'neo/rpc'

desc 'Check the blockchain for new blocks and download them'
task sync: :environment do
  chain_height = 120 # Neo.rpc 'getblockcount'
  while (index = Block.height + 1) < chain_height
    data = Neo.rpc 'getblock', index, 1
    Block.import(data)
    puts "Imported Block: #{index}"
  end
end
