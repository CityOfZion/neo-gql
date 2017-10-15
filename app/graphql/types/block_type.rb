require_relative '../helper'

Types::BlockType = GraphQL::ObjectType.define do
  name "Block"
  description "A block in the blockchain"

  field :hash, Types::HexType, "The hash of the block's contents" do
    resolve -> (obj, args, ctx) { obj.block_hash }
  end

  field :index, types.Int, "The index (height) of the block in the blockchain"

  field :merkleRoot, Types::HexType, "Root hash of a transaction list" do
    resolve -> (obj, args, ctx) { obj.merkle_root }
  end

  field :nextConsensus, Types::HexType, "Contract address of next miner"

  field :nextHash, Types::HexType, "Hash value of the next block" do
    resolve -> (obj, args, ctx) { obj.next_block_hash }
  end

  field :nonce, Types::HexType, "Random number, concensus data"

  field :previousHash, Types::HexType, "Hash value of the previous block" do
    resolve -> (obj, args, ctx) { obj.prev_block_hash }
  end

  field :script, Types::ScriptType, "Script used to validate the block"

  field :size, types.Int, "The size of the block data (in bytes)"

  field :transactions, types[Types::TransactionType], "Transactions list"

  field :time, Types::TimeType, "Time the block was created"

  field :version, types.Int, "The block version (0 for now)"
end
