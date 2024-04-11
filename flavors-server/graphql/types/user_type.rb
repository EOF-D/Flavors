module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :username, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :saved_recipes, [String], null: false
  end
end
