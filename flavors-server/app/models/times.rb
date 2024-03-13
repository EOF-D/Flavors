class Times
  # @return [String] The properation time of the recipe.
  attr_reader :preparation

  # @return [String] The cooking time of the recipe.
  attr_reader :cooking

  # Initializes a new instance of the Times class.
  #
  # @param data [Hash] a hash containing the ingredient data
  # @option data [String] 'preparation_time' the preparation time of the recipe
  # @option data [String] 'cooking_time' the cooking time of the recipe
  def initialize(data)
    @preparation = data['preparation_time']
    @cooking = data['cooking_time']
  end
end
