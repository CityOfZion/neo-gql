Types::AccountType = GraphQL::ObjectType.define do
  name "Account"
  description "A location on the blockchain holding assets"

  field :address, types.String, "The script hash of the account in base 58 encoding"

  field :balances, types[Types::BalanceType], "Current balances for this account"

  field :scriptHash, Types::HexType, "A hex encoded hash of the verification script" do
    resolve -> (obj, args, ctx) { obj.script_hash }
  end
end
