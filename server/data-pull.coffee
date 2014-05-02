mongoose = require("mongoose")
Profile = require("./models/profile")
#Mongoose Settings
mongoose.connect "mongodb://localhost/githubdb"

db = mongoose.connection

# Make request to GitHub
request = require("request-json")
frequest = require("request")
client = request.newClient 'https://api.github.com/'

getFullProfile = (profile, callback) ->
    options =
      url: profile.url
      headers:
        'User-Agent': 'Kontak',
        'Authorization': 'token 6aad69a10231747228cf153b3ce96a79c695e210'
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
        console.log "Retrieved Full Profile of #{body.name}"
        callback(body)

addRepositories = (profile, callback) ->
  options =
    url: profile.repos_url
    headers:
      'User-Agent': 'Kontak',
      'Authorization': 'token 6aad69a10231747228cf153b3ce96a79c695e210'
    json : true

  frequest options, (err, responce, body) ->
    if err
      console.log err
    else
      for repo in body
        Profile.update
          _id: profile._id
        ,
          $push:
            repos: { name: repo.name, html_url: repo.html_url, lang: repo.language }
        ,
          upsert: true
        , (err, data) ->
            if err
              log err
            else
              console.log data
      callback(profile)

repoOverview = (profile, callback) ->
  Profile.findById profile.id, (err, profile) ->
    dist = {}
    for repo in profile.repos
      if repo.lang == "null"
        null
      else if repo.lang == null
        null
      else if dist[repo.lang] == undefined
        dist[repo.lang] = 1
      else
        dist[repo.lang] += 1
    callback(profile, dist)

addRepoOverview = (profile, dist) ->
  Profile.update
    _id: profile._id
  ,
    $push:
      repoOverview: dist
  ,
    upsert: true
  , (err, data) ->
      if err
        console.log err
  console.log "Finished with #{profile.name}"

addToDB = (item, callback) ->
  profile = new Profile
    avatar_url : item.avatar_url
    html_url : item.html_url
    repos_url : item.repos_url
    name : item.name
    company : item.company
    blog : item.blog
    location : item.location
    email : item.email
    hireable : item.hireable
    bio : item.bio
  
  profile.save (err)->
    if err
      console.log err
    else
      callback(profile)


#fullGrab = (lang, location) ->
#  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=1', (err, res, body) ->
#    console.log 'Total Users found: ' + body.total_count
#    pages = body.total_count / 30
#    console.log "Total pages: #{pages}"
#
#    for page in [1..pages]
#      console.log "Processing page: #{page}"
getData = (lang, location, page) ->
  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=' + page, (err, res, body) ->
    console.log 'Total Users found: ' + body.total_count
    profilearray = body.items
    for profile in profilearray
      getFullProfile profile, (item) ->
        addToDB item, (user) ->
          addRepositories user, (profile1)->
            repoOverview profile1, (profile2, dist) ->
              addRepoOverview profile2, dist


getData("R", "London", 2)
#fullGrab("Objective-C", "London")
