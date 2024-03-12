# This class represents the GraphQL query root for recipes.
class Query
  # @return [Array<Recipe>] the list of recipes
  attr_reader :recipes

  # Initializes a new instance of the Query class.
  #
  # @param recipes [Array<Recipe>] the list of recipes
  def initialize(recipes)
    @recipes = recipes
  end

  # Retrieves a recipe by its ID.
  #
  # @param args [Hash] a hash containing the recipe ID
  # @option args [String] 'id' the ID of the recipe to retrieve
  # @return [Recipe] the recipe with the specified ID
  # @raise [ArgumentError] if no recipe is found with the specified ID
  def getRecipe(args)
    recipe = @recipes.find { |r| r.id == args["id"] }
    return recipe if recipe

    raise ArgumentError, "Recipe not found for ID: #{args["id"]}"
  end
end

# This class represents the GraphQL mutation root.
class Mutation
  # @return [Array<Recipe>] the list of recipes
  attr_reader :recipes

  # Initializes a new instance of the Mutation class.
  #
  # @param recipes [Array<Recipe>] the list of recipes
  def initialize(recipes)
    @recipes = recipes
  end
end

# This class represents the GraphQL schema.
class Schema
  # @return [Query] the query root
  attr_reader :query
  # @return [Mutation] the mutation root
  attr_reader :mutation

  # Initializes a new instance of the Schema class.
  def initialize
    recipes = []

    # Load recipes from a JSON file
    # TODO: Replace with redis
    JSON.parse(File.read(__dir__ + "/../assets/raw/recipes.json")).each do |recipe|
      recipes << Recipe.new(recipe)
    end

    @query = Query.new(recipes)
    @mutation = Mutation.new(recipes)
  end

  def query(_, req)
    return @query if req.nil?

    validate(req)
    @query
  end
end
