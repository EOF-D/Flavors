require_relative '../lib/auth'

class Authenticate
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Check if the request is for user registration or login
    return @app.call(env) if (request.path_info == '/register' || request.path_info == '/login') && request.post?

    auth_header = env['HTTP_AUTHORIZATION']
    if auth_header.present?
      token = auth_header.split(' ').last
      begin
        payload = Auth.decode(token)
        env['user_id'] = payload['user_id']
      rescue JWT::DecodeError
        return [401, {}, ['Invalid token']]
      end
    end

    @app.call(env)
  end
end
