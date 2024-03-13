require "pg"

# This class represents the GraphQL query root for recipes.
class Query
  # Initializes a new instance of the Query class.
  def initialize
    @conn = PG.connect(dbname: "flavors-db")
  end

  # Retrieves a recipe by its ID.
  #
  # @param args [Hash] a hash containing the recipe ID
  # @option args [String] 'id' the ID of the recipe to retrieve
  # @return [Recipe] the recipe with the specified ID
  # @raise [ArgumentError] if no recipe is found with the specified ID
  def getRecipe(args)
    id = args["id"]
    recipe_result = @conn.exec_params("SELECT * FROM recipes WHERE id = $1", [id])

    if recipe_result.ntuples.zero?
      raise ArgumentError, "Recipe not found for ID: #{args["id"]}" if recipe_result.ntuples.zero?
    end

    recipe_row = recipe_result.first
    ingredients = fetch_ingredients(id)
    steps = fetch_steps(id)
    times = fetch_times(id)

    data = {
      "id" => recipe_row["id"],
      "url" => recipe_row["url"],
      "name" => recipe_row["name"],
      "author" => recipe_row["author"],
      "ratings" => recipe_row["ratings"].to_i,
      "description" => recipe_row["description"],
      "ingredients" => ingredients,
      "steps" => steps,
      "times" => times,
      "serves" => recipe_row["serves"].to_i,
      "difficult" => recipe_row["difficulty"]
    }

    Recipe.new(data)
  end

  # Fetches the ingredients for a given recipe ID from the database.
  #
  # @param recipe_id [String] the ID of the recipe
  # @return [Array<Hash>] an array of ingredient data
  def fetch_ingredients(recipe_id)
    ingredients = []
    result = @conn.exec_params("SELECT * FROM ingredients WHERE recipe_id = $1", [recipe_id])

    result.each do |row|
      ingredients << {
        "name" => row["name"],
        "quantity" => row["quantity"],
        "unit" => row["unit"],
        "preparation" => row["preparation"]
      }
    end

    ingredients
  end

  # Fetches the steps for a given recipe ID from the database.
  #
  # @param recipe_id [String] the ID of the recipe
  # @return [Array<String>] an array of strings
  def fetch_steps(recipe_id)
    steps = []
    result = @conn.exec_params("SELECT * FROM steps WHERE recipe_id = $1 ORDER BY step_number", [recipe_id])

    result.each do |row|
      steps[row["step_number"].to_i] = row["step_text"]
    end

    steps
  end

  # Fetches the times for a given recipe ID from the database.
  #
  # @param recipe_id [String] the ID of the recipe
  # @return [Times] a Times instance containing the preparation time and cooking time
  def fetch_times(recipe_id)
    times_result = @conn.exec_params("SELECT * FROM times WHERE recipe_id = $1", [recipe_id])

    if times_result.ntuples.zero?
      return {"preparation_time" => nil, "cooking_time" => nil}
    end

    Times.new(times_result.first)
  end

  # Closes the database connection.
  def close
    @conn&.close
  end
end

# This class represents the GraphQL mutation root.
class Mutation
end

# This class represents the GraphQL schema.
class Schema
  # @return [Query] the query root
  attr_reader :query

  # @return [Mutation] the mutation root
  attr_reader :mutation

  # Initializes a new instance of the Schema class.
  def initialize
    @query = Query.new
    @mutation = Mutation.new
  end

  def query(_, req)
    return @query if req.nil?

    validate(req)
    @query
  end
end
