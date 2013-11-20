# 
# The artist page found at /artist/:id.
# 

express = require 'express'
routes = require './routes'

app = module.exports = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'
app.get '/artist/:id', routes.index