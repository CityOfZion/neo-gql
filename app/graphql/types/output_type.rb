Types::OutputType = GraphQL::ObjectType.define do
  name "Output"
  description "A transaction ouput"

  field :account, -> { Types::AccountType }, "Reciever for this transaction"

  field :asset, -> { Types::AssetType }, "The asset being spent"

  field :claimed, types.Boolean, "Whether this output has been spent yet"

  field :index, types.Int, "The index of this output in the transaction's vout list"

  field :transaction, -> { Types::TransactionType } do
    resolve -> (obj, args, ctx) { obj.spending_transaction }
  end

  field :value, types.Int, "The amount of this output"
end
