require 'openssl'
require 'jwt'

require './app/handlers/register_handler'
require './app/middlewares/jwt_middleware'
require './app/models/ingredient'
require './app/models/recipe'
require './app/models/times'
require './app/schema'
require './app/server'

# Generate RSA private key if it's not set in the environment
unless ENV['RSA_PRIVATE_KEY']
  rsa_private = OpenSSL::PKey::RSA.generate(2048)
  ENV['RSA_PRIVATE_KEY'] = rsa_private.to_pem
end

rsa_private = OpenSSL::PKey::RSA.new(ENV['RSA_PRIVATE_KEY'])
rsa_public = rsa_private.public_key

File.write('public.pem', rsa_public.to_pem)

# Start the server
Agoo::Server.start
sleep
