mongo = require("mongodb")
nodemailer = require("nodemailer")
mongoose = require("mongoose")

#Mongoose Settings
mongoose.connect "mongodb://localhost/test"

mdb = mongoose.connection
mdb.on "error", console.error.bind(console, "connection error:")
mdb.once "open", callback = ->
  console.log "Mongoose: connected"

#Mongodb Settings
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
    db.collection "profiles",
      strict: true
    , (err, collection) ->
      if err
        console.log "The 'profiles' collection doesn't exist. Hungry for DATA!"

#Nodemailer Settings
smtpTransport = nodemailer.createTransport("SMTP",
  host: "secure.emailsrvr.com" # hostname
  secureConnection: true # use SSL
  port: 465 # port for secure SMTP
  auth:
    user: ""
    pass: ""
)

#REST API's
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
    , profile,
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
  console.log "Emailing: " + JSON.stringify(profile.name)

  mailOptions =
    from: "steven.evans@bridgenoble.com"
    to: "snevets@gmail.com"
    bcc: "steven.evans@bridgenoble.com"
    subject: "FAO: #{profile.name} - Award Winning Financial Tech Startup - London"
    html: "Hi #{profile.name.split(" ")[0]},<br><br>

        I hope this message finds you well, I came across your GitHub Profile (#{profile.html_url}) with great interest as I noticed you had made several significant Python focused open-source contributions.<br><br>

        I was just looking to touch base with you regarding an Award Winning Financial UK Tech Startup called Funding Options. They are revolutionising the online Financial market with their unique and innovative ideas on financial risk and stock management.<br><br>

        Their dev teams are usually split up into smaller teams (4 or 5 devs), working in a very lean Agile way practising Scrum & TDD. They use Python and Pyramid extensively, however they are keen on attracting the best Python developers in the market who have experience with frameworks such as Django, Flask or Pyramid.<br><br>

        They are VC backed by several very renowned figures when it comes to successful entrepreneurs, including board members of one of Europe’s Top 10 Startups, Funding Circle and two of Bank Of America most successful VP’s of engineering. They are looking to rapidly expand their development team with now multiple strong back end python developers. They are considering Mid-Level, Senior and Lead Developers and are paying very attractive salaries, with potential stock options. They have recently secured stunning offices in the Centre of London overlooking the Thames, near tower bridge.<br><br>

        Please let me know if you would be interested in finding out more regarding this excellent opportunity to work for one of the most talked about Startups in London, or if you know anyone else who may be interested, we offer a generous referral fee.<br><br>

        If you aren't interested #{profile.name.split(" ")[0]} for whatever reason, it’s still worth getting back to me as I have a number of other exciting Python Development positions that may catch your eye.<br><br>

        I look forward to your response,<br><br>
        Best regards,<br>
        <b>Steven Evans</b><br><br>
        <b>T:</b> +44 (0) 207 953 1141<br>
        <b>E:</b> Steven.Evans@BridgeNoble.com<br><br>
        BRIDGE NOBLE LTD<br>
        Coppergate House<br>
        Brune Street<br>
        London<br>
        E1 7NJ<br><br>
        *********************************************************************************************<br>
        This email is sent for and on behalf of BRIDGE NOBLE LTD.<br>
        CONFIDENTIALITY<br>
        This email is intended only for the use of the addressee named above and may be confidential or legally privileged. If you are not the addressee you must not read it and must not use any information contained in nor copy it nor inform any person other than BRIDGE NOBLE LTD or the addressee of its existence or contents. If you have received this email in error please delete it and notify BRIDGE NOBLE LTD on +44 (0) 207 953 1137."

  smtpTransport.sendMail mailOptions, (error, response) ->
    if error
      console.log error
      smtpTransport.close()
    else
      console.log "Message sent: " + response.message
      res.send "Email sent to: #{profile.name}, id:#{profile._id}"
      smtpTransport.close()
      messages =
        message : mailOptions.text

      db.collection "profiles", (err, collection) ->
        collection.update
          _id: new BSON.ObjectID()
        , messages,
          safe: true
        , (err, result) ->
          if err
            console.log "Error updating profile: " + err
            res.send error: "An error has occurred"
          else
            console.log "" + result + " document(s) updated"
            res.send profile

