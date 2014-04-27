mongoose = require("mongoose")
textSearch = require("mongoose-text-search")

profileSchema = new mongoose.Schema
  avatar_url: String
  html_url: String
  repos_url: String
  name: String
  company: String
  blog: String
  location: String
  hireable: Boolean
  bio: String
  email: { type: String, required: true, index: true }
  repos: [
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

exports = module.exports = Profile