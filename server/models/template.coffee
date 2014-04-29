mongoose = require("mongoose")

templateSchema = new mongoose.Schema
  client: String
  role: String
  subject: String
  html: String

Template = mongoose.model('Template', templateSchema)

exports = module.exports = Template