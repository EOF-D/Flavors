# This class represents a recipe with its ingredients, steps, and other details.
class Recipe
  # @return [String] the unique identifier of the recipe
  attr_reader :id

  # @return [String] the URL of the recipe
  attr_reader :url

  # @return [String] the name of the recipe
  attr_reader :name

  # @return [String] the author of the recipe
  attr_reader :author

  # @return [Array<Int>] the ratings of the recipe
  attr_reader :ratings

  # @return [String] the description of the recipe
  attr_reader :description

  # @return [Array<Ingredient>] the list of ingredients in the recipe
  attr_reader :ingredients

  # @return [Array<String>] the steps to prepare the recipe
  attr_reader :steps

  # @return [Hash] a hash containing the preparation time and cooking time
  attr_reader :times

  # @return [Integer] the number of servings the recipe yields
  attr_reader :serves

  # @return [String] the difficulty level of the recipe
  attr_reader :difficult

  # Initializes a new instance of the Recipe class.
  #
  # @param data [Hash] a hash containing the recipe data
  # @option data [String] 'id' the unique identifier of the recipe
  # @option data [String] 'url' the URL of the recipe
  # @option data [String] 'name' the name of the recipe
  # @option data [String] 'author' the author of the recipe
  # @option data [Array<Float>] 'ratings' the ratings of the recipe
  # @option data [String] 'description' the description of the recipe
  # @option data [Array<Hash>] 'ingredients' the list of ingredient data
  # @option data [Array<String>] 'steps' the steps to prepare the recipe
  # @option data [Hash] 'times' a hash containing the preparation time and cooking time
  # @option data [Integer] 'serves' the number of servings the recipe yields
  # @option data [String] 'difficult' the difficulty level of the recipe
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
