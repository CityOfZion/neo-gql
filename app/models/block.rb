class Block < ApplicationRecord
  has_many :transactions

  def self.height
    order(index: :desc).first&.index || -1
  end

  def self.import(data)
    data['block_hash'] = data.delete 'hash'
    data['prev_block_hash'] = data.delete 'previousblockhash'
    data['next_block_hash'] = data.delete 'nextblockhash'
    data['merkle_root'] = data.delete 'merkleroot'
    data['next_consensus'] = data.delete 'nextconsensus'
    data.delete 'confirmations'
    transaction { create!(data).import_transactions }
  end

  def import_transactions
    tx.each { |tx| transactions.import(tx.deep_dup) }
  end
end
