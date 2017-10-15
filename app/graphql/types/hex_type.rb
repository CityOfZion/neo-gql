Types::HexType = GraphQL::ScalarType.define do
  name "Hex"
  description "Binary number as a hexadecimal string"

  coerce_input ->(value, ctx) { /^0x/ =~ value ? value : '0x' + value }
  coerce_result ->(value, ctx) { value.split('0x').last }
end
