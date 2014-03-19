mongo = require("mongodb")
nodemailer = require("nodemailer")

Server = mongo.Server
Db = mongo.Db
BSON = mongo.BSONPure
server = new Server("localhost", 27017,
  auto_reconnect: true
)

smtpTransport = nodemailer.createTransport "SMTP",
  service: "Gmail"
  auth:
    user: "snevets@gmail.com"
    pass: "hashtaggeneral123gmail"

db = new Db("githubdb", server)
db.open (err, db) ->
  unless err
    console.log "Connected to 'githubdb' database"
    db.collection "profiles",
      strict: true
    , (err, collection) ->
      if err
        console.log "The 'profiles' collection doesn't exist. Hungry for DATA! nom nom..."



exports.findById = (req, res) ->
  id = req.params.id
  console.log "Retrieving profile: " + id
  db.collection "profiles", (err, collection) ->
    collection.findOne
      _id: new BSON.ObjectID(id)
    , (err, item) ->
      res.send item


exports.findAll = (req, res) ->
  db.collection "profiles", (err, collection) ->
    collection.find().toArray (err, items) ->
      res.send items


exports.addProfile = (req, res) ->
  profile = req.body
  console.log "Adding profile: " + JSON.stringify(profile)
  db.collection "profiles", (err, collection) ->
    collection.insert profile,
      safe: true
    , (err, result) ->
      if err
        res.send error: "An error has occurred"
      else
        console.log "Success: " + JSON.stringify(result[0])
        res.send result[0]


exports.updateProfile = (req, res) ->
  id = req.params.id
  profile = req.body
  console.log "Updating profile: " + id
  console.log JSON.stringify(profile)
  db.collection "profiles", (err, collection) ->
    collection.update
      _id: new BSON.ObjectID(id)
    , wine,
      safe: true
    , (err, result) ->
      if err
        console.log "Error updating profile: " + err
        res.send error: "An error has occurred"
      else
        console.log "" + result + " document(s) updated"
        res.send profile


exports.deleteProfile = (req, res) ->
  id = req.params.id
  console.log "Deleting profile: " + id
  db.collection "profiles", (err, collection) ->
    collection.remove
      _id: new BSON.ObjectID(id)
    ,
      safe: true
    , (err, result) ->
      if err
        res.send error: "An error has occurred - " + err
      else
        console.log "" + result + " document(s) deleted"
        res.send req.body

exports.sendEmail = (req, res) ->
  profile = req.body
  console.log "Emailing profile: " + JSON.stringify(profile)

  mailOptions =
    from: "snevets@gmail.com"
    to: "snevets@gmail.com"
    subject: profile.login
    text: "Hi" + profile.name

  smtpTransport.sendMail mailOptions, (error, response) ->
    if error
      console.log error
    else
      console.log "Message sent: " + response.message
      res.send response.message

  smtpTransport.close()


#  db.collection "profiles", (err, collection) ->
#    collection.insert profile,
#      safe: true
#    , (err, result) ->
#      if err
#        res.send error: "An error has occurred"
#      else
#        console.log "Success: " + JSON.stringify(result[0])
#        res.send result[0]