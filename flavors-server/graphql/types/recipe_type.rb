module Types
  class RecipeType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :url, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :author, String, null: false
    field :ratings, Int, null: false
    field :ingredients, [Types::IngredientType], null: false
    field :steps, [String], null: false
    field :times, Types::RecipeTimeType, null: false
    field :serves, Int, null: false
    field :difficult, String, null: false

    def times
      RecipeTime.find_by(recipe_id: object.id)
    end
  end
end
