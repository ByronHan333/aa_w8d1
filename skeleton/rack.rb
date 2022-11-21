require 'rack'
require 'byebug'

# a rack compliant app respond to #call
# returns a basic response array with status, header_hash, and body
Rack::Server.start({
  app: blah,
  Port:
})
