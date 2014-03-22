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
request = require("request-json")
frequest = require("request")
client = request.newClient 'https://api.github.com/'

getFullProfile = (profile, callback) ->
    options =
      url: profile.url
      headers:
        'User-Agent': 'Kontak'
      json : true

    frequest options, (error, responce, body) ->
      if error
        console.log error
      else if body.email == null
        null
      else if body.email == ""
        null
      else if body.site_admin == true
        null
      else
        console.log "getFullProfile: #{body}"
        callback(body)

addRepositories = (user, callback) ->
  options =
    url: user.repos_url
    headers: 'User-Agent': 'Kontak'
    json : true

  frequest options, (error, responce, body) ->
    if error
      console.log error
    else
      user.repos = body
      console.log "User: #{user}"
      callback(user)

addToDB = (item) ->
  db.collection "profiles", (err, collection) ->
    console.log "Adding GitHub user #{item.login} to the DB"
    collection.insert item,
      console.log item
      safe: true
      , (err, result) ->

getData = (lang, location, page) ->
  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=' + page, (err, res, body) ->
      console.log 'Total Users found: ' + body.total_count
      profilearray = body.items

      for profile in profilearray
        getFullProfile profile, (body) ->
          addRepositories body, (item) ->
            addToDB(item)



getData("python", "London", 1)
