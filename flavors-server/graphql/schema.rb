require "graphql"

require_relative "types/recipe_type"
require_relative "types/ingredient_type"
require_relative "types/times_type"

module Types
  class QueryType < GraphQL::Schema::Object
    field :get_recipe, Types::RecipeType, null: true do
      description "Get a recipe by ID"
      argument :id, ID, required: true
    end

    def get_recipe(id:)
      puts id
    end
  end

  class MutationType < GraphQL::Schema::Object
    # TODO: Add mutations
  end

  class Schema < GraphQL::Schema
    query QueryType
    mutation MutationType
  end
end
