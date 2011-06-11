config = require './config.coffee'
_ = require "underscore"
require("drews-mixins") _
fs = require 'fs'

{wait, s} = _

log = (args...) -> console.log args... 

# reconnect 1 second after the connection closes

express = require('express')

drewsSignIn = (req, res, next) ->
  req.isSignedIn = () ->
    req.session.email isnt null
  next()

app = module.exports = express.createServer()
app.configure () ->
  app.use(express.bodyParser())
  app.use express.cookieParser()
  app.use express.session secret: "boom shaka laka"
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
  app.use drewsSignIn

app.configure 'development', () ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })) 

app.configure 'production', () ->
  app.use(express.errorHandler()) 

places = null
#user = null
loadPlaces = (d=->)->
  fs.readFile "places.js", (err, file) ->
    file = file.toString()
    log file
    places = eval file
    d null, places 
fs.watchFile "places.js", loadPlaces
loadPlaces ()->

#TODO: think of diff between socket model
# and http model.

pg = (p, f) ->
  app.post p, f
  app.get p, f

handleWhereAmI = (req, res) ->
  if !req.session.user
    req.session.user = 
      place: places.start 
      inventory: ["keys"]
  res.send req.session.user

pg "/whereami", handleWhereAmI
  
handleCommand = (req, res) ->
  command = req.params.command || ""
  if command of req.session.user.place.commands
    newPlace = req.session.user.place.commands[command] 
    req.session.user.place = places[newPlace]
    res.send req.session.user
  else
    err = message: "say what?" 
    res.send err, 401

pg "/commands/", handleWhereAmI
pg "/commands/:command", handleCommand

  
  
  
# Routes

app.get "/drew", (req, res) ->
  res.send "aguzate, hazte valer"


pg "/p", (req, res) ->
  req.session.poo = "gotta"
  res.send "that is all"

pg "/whoami", (req, res) ->
  res.send req.session
  
exports.app = app

if (!module.parent) 
  app.listen config.server.port || 8001
  console.log("Express server listening on port %d", app.address().port)

