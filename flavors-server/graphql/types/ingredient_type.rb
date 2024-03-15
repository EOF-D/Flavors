module Types
  class IngredientType < GraphQL::Schema::Object
    field :name, String, null: false
    field :unit, String, null: false
    field :quantity, String, null: false
    field :preparation, String, null: true
  end
end
