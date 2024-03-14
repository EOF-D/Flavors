require_relative "../../utils/rsa"

module Flavors
  # @!group Classes

  # Represents a middleware for JWT authentication.
  #
  # This middleware checks for the presence of an 'Authorization' header in incoming requests.
  # If the header is present, it verifies the JWT token using the public key and RS256 algorithm.
  # If the token is valid, it allows the request to proceed to the next middleware.
  # If the token is invalid or missing, it returns a 401 Unauthorized error.
  #
  # @!macro [new] middleware_init
  #   @param app The Rack application object.
  class JWTMiddleware
    # Initializes a new instance of the JWTMiddleware class.
    #
    # @param app [Object] The Rack application object.
    def initialize(app)
      generate
      @rsa_public = OpenSSL::PKey::RSA.new(File.read("public.pem"))
      @app = app
    end

    # Handles incoming requests by verifying the JWT token and passing the request
    # to the next middleware if the token is valid.
    #
    # @param env [Hash] The environment hash representing the incoming request.
    # @return [Array] A Rack response triplet.
    def call(env)
      # If the request is a POST to '/register', skip authentication
      return @app.call(env) if env["REQUEST_METHOD"] == "POST" && env["PATH_INFO"] == "/register"

      # Hijack the request to access headers
      request = env["rack.hijack"]

      # If the 'Authorization' header is missing, return a 401 Unauthorized error
      return [401, {}, ["Authorization header is required"]] unless request.headers.key?("HTTP_AUTHORIZATION")

      # Extract the token from the 'Authorization' header
      auth_header = request.headers["HTTP_AUTHORIZATION"]
      token = auth_header.split(" ").last

      begin
        # Decode and verify the token using the public key and RS256 algorithm
        JWT.decode(token, @rsa_public, true, algorithm: "RS256")
      rescue JWT::DecodeError => e
        # If the token is invalid, return a 401 Unauthorized error with the error message
        return [401, {}, ["Invalid token: #{e.message}"]]
      end

      # If the token is valid, call the next middleware
      @app.call(env)
    end
  end
end
