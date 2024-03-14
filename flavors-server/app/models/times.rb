module Flavors
  # Represents the preparation and cooking times for a recipe.
  class Times
    # @return [Integer, nil] The preparation time in minutes, or nil if not available.
    attr_reader :preparation

    # @return [Integer, nil] The cooking time in minutes, or nil if not available.
    attr_reader :cooking

    # Initializes a new instance of the Times class with preparation and cooking times.
    #
    # @param [Hash] data A Hash containing the preparation and cooking times.
    def initialize(data)
      @preparation = data["preparation_time"]
      @cooking = data["cooking_time"]
    end
  end
end
