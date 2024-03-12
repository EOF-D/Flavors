# This middleware is responsible for authenticating requests using JSON Web Tokens (JWT)
# with the RS256 algorithm and public key encryption.
class JWTMiddleware
  # Initializes the middleware by loading the public key from the 'public.pem' file.
  #
  # @param app [Object] The Rack application or middleware.
  def initialize(app)
    @rsa_public = OpenSSL::PKey::RSA.new(File.read("public.pem"))
    @app = app
  end

  # Authenticates the incoming request by verifying the JWT token in the 'Authorization' header.
  #
  # @param env [Hash] The Rack environment hash.
  # @return [Array] An array containing the HTTP status code, headers, and response body.
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

# This method validates the JWT token in the 'Authorization' header.
#
# @param req [Object] The request object.
# @raise [RuntimeError] If the 'Authorization' header is missing or the token is invalid or expired.
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
