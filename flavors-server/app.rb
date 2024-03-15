require "rake"
require "sinatra"
require "sinatra/json"

require "sinatra/activerecord"
require "sinatra/activerecord/rake"

require_relative "models/recipe"
require_relative "models/recipe_time"
require_relative "models/ingredient"
require_relative "models/step"

require_relative "graphql/schema"

class FlavorsApp < Sinatra::Base
  set :database_file, "./config/database.yml"

  post "/graphql" do
    request_data = JSON.parse(request.body.read)

    query = request_data["query"]
    variables = request_data["variables"] || {}
    context = request_data["context"] || {}

    result = Types::Schema.execute(query, variables: variables, context: context)
    json result
  end
end
