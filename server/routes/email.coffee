mongoose = require("mongoose")
Profile = require("../models/profile")

exports.sendEmail = (req, res) ->
  profile = req.body
  console.log "Emailing: " + JSON.stringify(profile.name)

  options =
    to:
      email: "snevets@gmail.com"
      name: profile.name
      subject: "FAO:  - Award Winning Financial Tech Startup - London"
      template: "test"

  data =
    name: profile.name.split(" ")[0]
    url: profile.html_url

  Emailer = require "../../lib/emailer"
  emailer = new Emailer options, data

  emailer.send (err, result)->
    if err
      console.log err
    else
      console.log result
      res.send "Email sent to: #{options.to.name} email:#{options.to.email}"
      Profile.update
        _id: profile._id
      ,
        $push:
          messages: { author: 'Steven', body: options.to.template }
      ,
        upsert: true
      , (err, data) ->