nodemailer = require("nodemailer")
mongoose = require("mongoose")
textSearch = require("mongoose-text-search")
fs = require ("fs")
request = require("request-json")
emailer = require("../emailer")


#Nodemailer Settings
smtpTransport = nodemailer.createTransport("SMTP",
  host: "secure.emailsrvr.com" # hostname
  secureConnection: true # use SSL
  port: 465 # port for secure SMTP
  auth:
    user: "user@bridgenoble.com"
    pass: "password"

#Mongoose Settings
mongoose.connect "mongodb://localhost/githubdb"

db = mongoose.connection

profileSchema = new mongoose.Schema
  avatar_url : String
  html_url : String
  repos_url : String
  name : String
  company : String
  blog: String
  location: String
  hireable: Boolean
  bio: String
  email: { type: String, required: true, index: true }
  repos : [
    name: String,
    html_url: String,
    language: []
  ]
  messages: [
    author: String
    body: String
    date: { type: Date, default: Date.now }
  ]
  comments: [
    author: String
    body: String
    date: { type: Date, default: Date.now }
  ]

profileSchema.plugin textSearch

Profile = mongoose.model('Profile', profileSchema)

exports.findAll = (req, res) ->
  Profile.find (err, profiles) ->
    if err
      console.log err
    else
      res.send(profiles)

exports.search = (req, res) ->
  searchTerm = req.body.query
  Profile.textSearch searchTerm, (err, profiles) ->
    if err
      console.log err
    else
      res.send profiles

exports.comp = (req, res) ->
  searchTerm = req.body.query
  client = request.newClient 'http://api.crunchbase.com/v/1/'
  client.get "search.js?query=#{searchTerm}&entity=company&api_key=sxpx4ehymgj83ksgk7qbzmzc", (err, resp, body) ->
    if err
      console.log err
    else
      res.send body.results


exports.updateProfile = (req, res) ->
  id = req.params.id
  update = req.body
  console.log "id: " + id
  console.log "update: #{update}"

  Profile.findById id, (err, profile) ->
    profile.author = "steven"
    profile.save (err) ->
      if err
        console.log err
      res.send profile

#exports.deleteProfile = (req, res) ->
#  id = req.body
#
#  Profile.findById id, (err, profile) ->
#    profile.author = "steven"
#    profile.save (err) ->
#      if err
#        console.log err
#      res.send profile

exports.sendEmail = (req, res) ->
  profile = req.body
  console.log "Emailing: " + JSON.stringify(profile.name)

  fs.readFile __dirname + '/../email_templates/test.html', (err, template) ->
    if err
      console.log err
    else
      mailOptions =
        from: "steven.evans@bridgenoble.com"
        to: "snevets@gmail.com"
        bcc: "steven.evans@bridgenoble.com"
        subject: "FAO: #{profile.name} - Award Winning Financial Tech Startup - London"
        Html: template

      smtpTransport.sendMail mailOptions, (error, response) ->
        if error
          console.log error
          smtpTransport.close()
        else
          smtpTransport.close()
          console.log "Message sent: " + response.message
          res.send "Email sent to: #{profile.name} id:#{profile._id}"

          Profile.update
            _id: profile._id
          ,
            $push:
              messages: { author: 'Steven', body: mailOptions.Html }
          ,
            upsert: true
          , (err, data) ->)