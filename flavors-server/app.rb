require 'json'
require 'rake'
require 'sinatra'
require 'sinatra/json'

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

require_relative 'models/recipe'
require_relative 'models/recipe_time'
require_relative 'models/ingredient'
require_relative 'models/step'
require_relative 'models/user'

require_relative 'graphql/schema'
require_relative 'lib/auth'

class FlavorsApp < Sinatra::Application
  set :database_file, './config/database.yml'

  post '/graphql' do
    request_data = JSON.parse(request.body.read)
    token = request.env['HTTP_AUTHORIZATION'][7..]

    query = request_data['query']
    variables = request_data['variables'] || {}
    context = request_data['context'] || {}
    context[:token] = token

    result = Types::Schema.execute(query, variables: variables, context: context)
    json result
  end

  post '/register' do
    body = request.body.read
    params = JSON.parse(body)

    username = params['username']
    password = params['password']

    user = User.new(username: username, password: password)
    if user.save
      status 201
      user.to_json
    else
      status 400
      { error: user.errors.full_messages.join(', ') }.to_json
    end
  end

  post '/login' do
    body = request.body.read
    params = JSON.parse(body)

    username = params['username']
    password = params['password']

    user = User.find_by(username: username)
    if user&.authenticate(password)
      token = Auth.encode({ username: username, user_id: user.id })
      { token: token }.to_json
    else
      status 401
      { error: 'Invalid username or password' }.to_json
    end
  end
end
