Types::TimeType = GraphQL::ScalarType.define do
  name "Time"
  description "Timestamp"

  coerce_input ->(value, ctx) { value.to_i }
  coerce_result ->(value, ctx) { Time.at(value) }
end
