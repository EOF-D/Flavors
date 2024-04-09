require './app'
require './middleware/authenticate'

use Authenticate
run FlavorsApp
