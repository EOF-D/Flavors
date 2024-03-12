# This class handles the registration process for new users.
# It generates a JSON Web Token (JWT) with the user's email and an expiration time of one week.
class RegisterHandler
  # Generates a JWT token for the provided email address.
  #
  # @param env [Hash] The Rack environment hash.
  # @return [Array] An array containing the HTTP status code, headers, and response body.
  def self.call(env)
    body = env["rack.hijack"].body

    # Check if the email is provided in the request body
    return [400, {}, ["Email is required to register."]] if body["email"].nil?

    # Generate the JWT payload with the email and expiration time (one week from now)
    payload = {
      email: body["email"],
      exp: Time.now.to_i + 604_800 # 604_800 seconds = 1 week
    }

    # Load the private key from the environment variable
    rsa_private = OpenSSL::PKey::RSA.new(ENV["RSA_PRIVATE_KEY"])

    # Generate the JWT token using the payload and private key
    token = JWT.encode(payload, rsa_private, "RS256")

    # Return a successful response with the generated token
    [200, {}, ["Token: #{token}"]]
  end
end
