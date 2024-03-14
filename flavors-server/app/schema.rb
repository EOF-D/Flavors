require "pg"

# @title Recipe Query and Schema
#
# @description This module contains classes for querying recipe data from a PostgreSQL database
#   and managing the schema for queries and mutations.
module Flavors
  # @!group Classes

  # @!macro [new] query_class
  #   @param [String] dbname The name of the PostgreSQL database to connect to.
  #
  # Represents a query object that interacts with a PostgreSQL database to fetch recipe data.
  class Query
    # @param [String] dbname The name of the PostgreSQL database to connect to.
    def initialize(dbname: "flavors-db")
      @conn = PG.connect(dbname: dbname)
    end

    # Retrieves a recipe from the database based on the provided ID.
    #
    # @param [Hash] args A Hash containing the recipe ID as a string.
    # @return [Recipe] A Recipe object containing the recipe data.
    # @raise [ArgumentError] If no recipe is found for the provided ID.
    def getRecipe(args)
      id = args["id"]
      recipe_result = @conn.exec_params("SELECT * FROM recipes WHERE id = $1", [id])

      if recipe_result.ntuples.zero?
        raise ArgumentError, "Recipe not found for ID: #{args["id"]}"
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
    # @param [Integer] recipe_id The ID of the recipe.
    # @return [Array<Ingredient>] An array of Ingredient objects representing the recipe's ingredients.
    def fetch_ingredients(recipe_id)
      ingredients = []
      result = @conn.exec_params("SELECT * FROM ingredients WHERE recipe_id = $1", [recipe_id])

      result.each do |row|
        ingredients << Ingredient.new(row)
      end

      ingredients
    end

    # Fetches the steps for a given recipe ID from the database.
    #
    # @param [Integer] recipe_id The ID of the recipe.
    # @return [Array<String>] An array of strings representing the recipe's steps.
    def fetch_steps(recipe_id)
      steps = []
      result = @conn.exec_params("SELECT * FROM steps WHERE recipe_id = $1 ORDER BY step_number", [recipe_id])

      result.each do |row|
        steps << row["step_text"]
      end

      steps
    end

    # Fetches the preparation and cooking times for a given recipe ID from the database.
    #
    # @param [Integer] recipe_id The ID of the recipe.
    # @return [Times, Hash] A Times object containing the recipe's preparation and cooking times, or
    #   a Hash with nil values if no times are found.
    def fetch_times(recipe_id)
      times_result = @conn.exec_params("SELECT * FROM times WHERE recipe_id = $1", [recipe_id])

      if times_result.ntuples.zero?
        return {"preparation" => nil, "cooking" => nil}
      end

      Times.new(times_result.first)
    end

    # Closes the database connection.
    def close
      @conn&.close
    end
  end

  # An empty class for handling mutations (not documented).
  class Mutation
  end

  # Represents a schema that contains query and mutation objects.
  class Schema
    # @return [Query] The query object associated with the schema.
    attr_reader :query

    # @return [Mutation] The mutation object associated with the schema.
    attr_reader :mutation

    # Initializes a new instance of the Schema class with a Query and Mutation object.
    def initialize
      @query = Query.new
      @mutation = Mutation.new
    end

    def query(_, req)
      return @query if req.nil?

      validate(req)
      @query
    end

    # Validates a given request by verifying the JWT token using the public key and RS256 algorithm.
    #
    # @param req [Object] The request object.
    # @raise [RuntimeError] If the 'Authorization' header is missing, the token has expired, or the token is invalid.
    def validate(req)
      # Raise an error if the 'Authorization' header is missing
      raise "Authorization header is required" unless req.headers["HTTP_AUTHORIZATION"]

      # Extract the token from the 'Authorization' header
      token = req.headers["HTTP_AUTHORIZATION"].split(" ").last

      # Load the public key from the 'public.pem' file
      rsa_public = OpenSSL::PKey::RSA.new(File.read("public.pem"))

      begin
        # Decode and verify the token using the public key and RS256 algorithm
        JWT.decode(token, rsa_public, true, algorithm: "RS256")
      rescue JWT::ExpiredSignature
        # Raise an error if the token has expired
        raise "Token has expired"
      rescue JWT::DecodeError
        # Raise an error if the token is invalid
        raise "Invalid token"
      end
    end
  end
end
