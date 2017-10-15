require_relative '../helper'

Types::TransactionType = GraphQL::ObjectType.define do
  name "Transaction"
  description "A transaction on the blockchain"

  # TODO: field :attributes

  field :block, -> { Types::BlockType }

  # TODO: field :data, types..., "Data specific to transaction types"

  field :id, Types::HexType, "The transaction's id" do
    resolve -> (obj, args, ctx) { obj.txid }
  end

  field :inputs, types[Types::OutputType], "Spent outputs of previous transactions" do
    resolve -> (obj, args, ctx) { obj.vin.map { |input|
      Transaction.find_by_txid(input['txid']).outputs.find_by_index(input['vout'])
    } }
  end

  field :networkFee, types.String, "Fee paid to bookkeeping nodes for this transaction" do
    resolve -> (obj, args, ctx) { obj.net_fee }
  end

  field :outputs, types[Types::OutputType], "This transaction's outputs"

  field :scripts, types[Types::ScriptType], "Scripts used to validate the transaction"

  field :size, types.Int, "The size of the transaction data (in bytes)"

  field :systemFee, types.String, "Fee charged by system for this transaction" do
    resolve -> (obj, args, ctx) { obj.sys_fee }
  end

  field :type, types.String, "The transaction type" do
    resolve -> (obj, args, ctx) { obj.tx_type }
  end

  field :version, types.Int, "Trading version, currently 0"
end
