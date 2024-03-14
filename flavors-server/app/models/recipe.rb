module Flavors
  # Represents a recipe with its associated data.
  class Recipe
    # @return [Integer] The ID of the recipe.
    attr_reader :id

    # @return [String] The URL of the recipe.
    attr_reader :url

    # @return [String] The name of the recipe.
    attr_reader :name

    # @return [String] The author of the recipe.
    attr_reader :author

    # @return [Integer] The rating of the recipe.
    attr_reader :ratings

    # @return [String] The description of the recipe.
    attr_reader :description

    # @return [Array<Ingredient>] An array of Ingredient objects representing the recipe's ingredients.
    attr_reader :ingredients

    # @return [Array<String>] An array of strings representing the recipe's steps.
    attr_reader :steps

    # @return [Times, Hash] A Times object containing the recipe's preparation and cooking times, or
    #   a Hash with nil values if no times are found.
    attr_reader :times

    # @return [Integer] The number of servings the recipe yields.
    attr_reader :serves

    # @return [String] The difficulty level of the recipe.
    attr_reader :difficult

    # Initializes a new instance of the Recipe class with recipe data.
    #
    # @param [Hash] data A Hash containing the recipe data.
    def initialize(data)
      @id = data["id"]
      @url = data["url"]
      @name = data["name"]
      @author = data["author"]
      @ratings = data["ratings"]
      @description = data["description"]
      @ingredients = data["ingredients"]
      @steps = data["steps"]
      @times = data["times"]
      @serves = data["serves"]
      @difficult = data["difficult"]
    end
  end
end
