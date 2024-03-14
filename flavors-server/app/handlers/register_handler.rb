module Flavors
  # Handles user registration by generating a JWT token with the provided email and expiration time.
  class RegisterHandler
    # Handles the incoming request for user registration.
    #
    # @param env [Hash] The environment hash representing the incoming request.
    # @return [Array] A Rack response triplet with the generated JWT token or an error message.
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
      [200, {}, [token]]
    end
  end
end
