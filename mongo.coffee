mongoose = require('mongoose')

mongoose.connect('mongodb://localhost/mailer') #connect to mailer db

Schema = mongoose.Schema

profile = new Schema
  username:  String
  userimage: String
  body:   String
  comments: [
    body: String
    date: Date
  ]
  date:
    type: Date
    default: Date.now()
  hidden: Boolean
  meta:
    votes: Number
    favs: Number