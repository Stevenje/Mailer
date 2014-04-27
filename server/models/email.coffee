mongoose = require("mongoose")

emailSchema = new mongoose.Schema
  client: String
  role: String
  title: String
  html: String

Email = mongoose.model('Email', emailSchema)

exports = module.exports = Email