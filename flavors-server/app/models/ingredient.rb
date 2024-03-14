module Flavors
  # Represents an ingredient for a recipe.
  class Ingredient
    # @return [String] The name of the ingredient.
    attr_reader :name

    # @return [Float] The quantity of the ingredient.
    attr_reader :quantity

    # @return [String] The unit of measurement for the ingredient.
    attr_reader :unit

    # @return [String] The preparation instructions for the ingredient.
    attr_reader :preparation

    # Initializes a new instance of the Ingredient class with ingredient data.
    #
    # @param [Hash] data A Hash containing the ingredient data.
    def initialize(data)
      @name = data["name"]
      @quantity = data["quantity"]
      @unit = data["unit"]
      @preparation = data["preparation"]
    end
  end
end
