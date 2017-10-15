Types::BalanceType = GraphQL::ObjectType.define do
  name "Balance"

  field :account, -> { Types::AccountType }

  field :asset, -> { Types::AssetType }

  field :value, types.Int
end
