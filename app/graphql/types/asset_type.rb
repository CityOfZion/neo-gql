ASSET_NAMES = {
  'AntShare' => 'NEO',
  'AntCoin' => 'GAS',
}

Types::AssetType = GraphQL::ObjectType.define do
  name "Asset"
  description "Assets registered on the blockchain"

  field :admin, Types::AccountType do
    resolve -> (obj, args, ctx) { Account.find_by_address(obj.admin) }
  end

  field :amount, types.String

  field :balances, types[Types::BalanceType]

  field :id, Types::HexType, "Asset id (id of the RegisterTransaction that created this asset)" do
    resolve -> (obj, args, ctx) { obj.asset_id }
  end

  field :name, types.String, "Name of this asset" do
    resolve -> (obj, args, ctx) {
      en_name = obj.name.find { |n| n['lang'] == 'en' }['name']
      ASSET_NAMES[en_name] || en_name
    }
  end

  field :owner, types.String

  field :precision, types.Int

  field :type, types.String, "Type of this asset" do
    resolve -> (obj, args, ctx) { obj.asset_type }
  end
end
