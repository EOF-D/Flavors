require "openssl"

# Generate RSA private key if it's not set in the environment
def generate
  unless ENV["RSA_PRIVATE_KEY"]
    rsa_private = OpenSSL::PKey::RSA.generate(2048)
    ENV["RSA_PRIVATE_KEY"] = rsa_private.to_pem
  end

  rsa_private = OpenSSL::PKey::RSA.new(ENV["RSA_PRIVATE_KEY"])
  rsa_public = rsa_private.public_key

  File.write("public.pem", rsa_public.to_pem)
end