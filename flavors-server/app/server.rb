require "agoo"

# Configuring Agoo
Agoo::Log.configure(dir: "",
  console: true,
  classic: true,
  colorize: true,
  states: {
    DEBUG: true,
    request: false,
    response: false,
    eval: false,
    push: false
  })

Agoo::Server.init(6464, "root", thread_count: 1, graphql: "/api")

# Loading middleware and handlers.
Agoo::Server.use(Flavors::JWTMiddleware)
Agoo::Server.handle(:POST, "/register", Flavors::RegisterHandler)

# Loading Schema.
Agoo::GraphQL.schema(Flavors::Schema.new) { Agoo::GraphQL.load_file(__dir__ + "/../assets/schema.gql") }

# Setting CORS headers.
Agoo::GraphQL.build_headers = proc { |req|
  origin = req.headers["HTTP_ORIGIN"] || "*"
  {
    "Access-Control-Allow-Origin" => origin,
    "Access-Control-Allow-Headers" => "*",
    "Access-Control-Allow-Credentials" => true,
    "Access-Control-Max-Age" => 3600
  }
}
