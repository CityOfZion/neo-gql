# TODO: Filtering & Pagination for all
Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  # TODO: Implement find by script hash
  field :account do
    type Types::AccountType
    argument :address, types.String
    argument :scriptHash, Types::HexType
    description "Find an Asset by it's address or script hash"
    resolve -> (obj, args, ctx) { Account.find_by_address(args[:address]) }
  end

  field :accounts do
    type !types[Types::AccountType]
    argument :limit, types.Int
    resolve -> (obj, args, ctx) { Account.limit(args[:limit] || 10) }
  end

  # TODO: Implement find by name
  field :asset do
    type Types::BlockType
    argument :id, Types::HexType
    argument :name, types.String
    description "Find an Asset by it's name or id"
    resolve -> (obj, args, ctx) {
      Asset.find_by_asset_id(args[:id])
    }
  end

  field :assets, !types[Types::AssetType] do
    resolve -> (obj, args, ctx) { Asset.all }
  end

  # TODO: Needs offset
  field :block do
    type Types::BlockType
    argument :index, !types.Int
    description "Find a Block by it's index"
    resolve -> (obj, args, ctx) {
      Block.find_by_index(args[:index])
    }
  end

  field :blocks, !types[Types::BlockType] do
    resolve -> (obj, args, ctx) { Block.all }
  end

  field :transaction do
    type Types::TransactionType
    argument :id, !types.String
    description "Find a transaction by it's id"
    resolve -> (obj, args, ctx) { Transaction.find_by_txid('0x' + args["id"]) }
  end

  field :transactions, !types[Types::TransactionType] do
    resolve -> (obj, args, ctx) { Transaction.all }
  end
end
