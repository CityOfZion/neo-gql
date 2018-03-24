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
    argument :limit, types.Int, default_value: 20, prepare: ->(limit, ctx) {[limit, 50].min}
    argument :offset, types.Int, default_value: 0
    resolve -> (obj, args, ctx) { Account.limit(args[:limit]).offset(args[:offset]) }
  end

  # TODO: Implement find by name
  field :asset do
    type Types::AssetType
    argument :id, Types::HexType
    argument :name, types.String
    description "Find an Asset by it's name or id"
    resolve -> (obj, args, ctx) {
      Asset.find_by_asset_id(args[:id])
    }
  end

  field :assets, !types[Types::AssetType] do
    argument :limit, types.Int, default_value: 20, prepare: ->(limit, ctx) {[limit, 50].min}
    argument :offset, types.Int, default_value: 0
    resolve -> (obj, args, ctx) { Asset.limit(args[:limit]).offset(args[:offset]) }
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
    argument :limit, types.Int, default_value: 20, prepare: ->(limit, ctx) {[limit, 50].min}
    argument :offset, types.Int, default_value: 0
    resolve -> (obj, args, ctx) { Block.limit(args[:limit]).offset(args[:offset]).order('index DESC') }
  end

  field :transaction do
    type Types::TransactionType
    argument :id, !types.String
    description "Find a transaction by it's id"
    resolve -> (obj, args, ctx) { Transaction.find_by_txid('0x' + args["id"]) }
  end

  field :transactions, !types[Types::TransactionType] do
    argument :limit, types.Int, default_value: 20, prepare: ->(limit, ctx) {[limit, 50].min}
    argument :offset, types.Int, default_value: 0
    argument :types, types[types.String]
    resolve -> (obj, args, ctx) {
      scope = Transaction.limit(args[:limit]).offset(args[:offset]).includes(:block).order('blocks.index DESC')
      scope = scope.where(tx_type: args[:types]) if args[:types]
      scope
    }
  end
end
