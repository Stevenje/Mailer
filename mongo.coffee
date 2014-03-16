mongo = require("mongodb")
Server = mongo.Server
Db = mongo.Db
BSON = mongo.BSONPure
server = new Server("localhost", 27017,
  auto_reconnect: true
)

db = new Db("githubdb", server)
db.open (err, db) ->
  unless err
    console.log "Connected to 'githubdb' database"

db.collection "profiles", (err, collection) ->
  collection.insert wines,
    safe: true
  , (err, result) ->