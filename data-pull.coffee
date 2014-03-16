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
frequest = require("request")
client = request.newClient 'https://api.github.com/'

#Options for GitHub Search
lang = 'ruby'
location = 'london'
page = 7

gitdata = (lang, location, page) ->
  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=' + page, (err, res, body) ->
    console.log 'Total Users found: ' + body.total_count
    profilearray = body.items
    #    console.log profilearray

    for profile in profilearray
      db.collection "profiles", (err, collection) ->
        options =
          url: profile.url
          headers:
            'User-Agent': 'Kontak'
          json : true

        frequest options, (error, responce, body) ->
          if body.email == null
            null
          else if body.email == ""
            null
          else if body.site_admin == true
            null
          else
            collection.insert body,
              safe: true
              , (err, result) ->
#      console.log "Added GitHub user #{profile.login} to the DB"

gitdata(lang, location, page)