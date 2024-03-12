# This class represents an ingredient in a recipe.
class Ingredient
  # @return [String] the name of the ingredient
  attr_reader :name

  # @return [Float] the quantity of the ingredient
  attr_reader :quantity

  # @return [String] the unit of measurement for the ingredient quantity
  attr_reader :unit

  # @return [String] the preparation instructions for the ingredient
  attr_reader :preparation

  # Initializes a new instance of the Ingredient class.
  #
  # @param data [Hash] a hash containing the ingredient data
  # @option data [String] 'name' the name of the ingredient
  # @option data [Float] 'quantity' the quantity of the ingredient
  # @option data [String] 'unit' the unit of measurement for the ingredient quantity
  # @option data [String] 'preparation' the preparation instructions for the ingredient
  def initialize(data)
    @name = data["name"]
    @quantity = data["quantity"]
    @unit = data["unit"]
    @preparation = data["preparation"]
  end
end
