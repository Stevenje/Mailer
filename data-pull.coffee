#Connect to Mongo Backend
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

# Make request to Github
request = require('request-json')
client = request.newClient 'https://api.github.com/'

lang = 'ruby'
location = 'london'
page = 1

gitdata = (lang, location, page) ->
  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=' + page, (err, res, body) ->
    console.log 'Total Users found: ' + body.total_count
    profilearray = body.items
    console.log profilearray
    
    for profile in profilearray
      db.collection "profiles", (err, collection) ->
        collection.insert profile,
        safe: true
        , (err, result) ->
    console.log profile

gitdata(lang, location, page)



