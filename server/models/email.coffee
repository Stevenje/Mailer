mongoose = require("mongoose")

emailSchema = new mongoose.Schema
  client: String
  role: String
  html: String

Profile = mongoose.model('Email', profileSchema)

exports = module.exports = Email