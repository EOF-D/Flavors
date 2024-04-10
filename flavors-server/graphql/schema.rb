require 'graphql'

require_relative 'types/ingredient_type'
require_relative 'types/times_type'
require_relative 'types/recipe_type'
require_relative 'types/user_type'

require_relative 'types/inputs/times_type'
require_relative 'types/inputs/filter_type'

require_relative '../models/recipe'

module Types
  class QueryType < GraphQL::Schema::Object
    field :recipes, [Types::RecipeType], null: false do
      description 'Get all recipes'
    end

    field :get_recipe, Types::RecipeType, null: true do
      description 'Get a recipe by ID'
      argument :id, ID, required: true
    end

    field :filter_recipes, [Types::RecipeType], null: false do
      description 'Search recipes by filter'
      argument :filter, Types::Inputs::FilterType, required: true
    end

    field :get_user, Types::UserType, null: true do
      description 'Get the user by ID'
      argument :id, ID, required: true
    end

    def recipes
      Recipe.all
    end

    def get_recipe(id:)
      Recipe.find_by(id: id)
    end

    def filter_recipes(filter:)
      recipes = Recipe.all
      recipes = recipes.where('recipes.name ILIKE ?', "%#{filter.name}%") if filter.name.present?

      if filter.ingredients.present?
        recipes = recipes.joins(:ingredients)
                         .where('ingredients.name IN (?)', filter.ingredients)
                         .group('recipes.id')
                         .having('COUNT(DISTINCT ingredients.name) = ?', filter.ingredients.size)
      end

      recipes
    end

    def get_user(id:)
      User.find_by(id: id)
    end
  end

  class MutationType < GraphQL::Schema::Object
    field :toggle_recipe, Types::RecipeType, null: true do
      argument :user, Integer, required: true
      argument :id, ID, required: true
    end

    def toggle_recipe(user:, id:)
      recipe = Recipe.find_by(id: id)
      return if recipe.nil?

      user = User.find_by(id: user)

      if user.saved_recipes.include?(recipe.id)
        user.saved_recipes.delete(recipe.id)
        user.save

        return recipe
      end

      user.saved_recipes << recipe.id
      user.save

      recipe
    end
  end

  class Schema < GraphQL::Schema
    query QueryType
    mutation MutationType
  end
end
