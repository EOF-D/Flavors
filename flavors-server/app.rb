require "rake"
require "sinatra"
require "sinatra/json"

require "sinatra/activerecord"
require "sinatra/activerecord/rake"

require_relative "models/recipe"
require_relative "models/ingredient"
require_relative "models/step"
require_relative "models/times"

class FlavorsApp < Sinatra::Base
  set :database_file, "./config/database.yml"
end
