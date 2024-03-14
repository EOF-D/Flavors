require "jwt"

require "./app/handlers/register_handler"
require "./app/middlewares/jwt_middleware"
require "./app/models/ingredient"
require "./app/models/recipe"
require "./app/models/times"
require "./app/schema"
require "./app/server"

# Start the server
Agoo::Server.start
sleep
