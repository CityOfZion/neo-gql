Types::ScriptType = GraphQL::ObjectType.define do
    name "Script"
    description "A list of scripts used in validation"

    field :invocation, Types::HexType, "Invocation Script" do
      resolve -> (obj, args, ctx) {
        puts obj
        obj['invocation']
      }
    end

    field :verification, Types::HexType, "Verification Script" do
      resolve -> (obj, args, ctx) { obj['verification'] }
    end
end
