emailer = require("nodemailer")
fs      = require("fs")
_       = require("underscore")

class Emailer

  options: {}

  data: {}

  constructor: (@options, @data)->

  send: (callback)->
    html = @getHtml(@options.template, @data)
    messageData =
      to: @options.to.email
      from: "Steven Evans <steven.evans@bridgenoble.com>>"
      subject: @options.subject
      html: html
      generateTextFromHTML: true
    transport = @getTransport()
    transport.sendMail messageData, callback

  getTransport: ()->
    emailer.createTransport "SMTP",
      host: "secure.emailsrvr.com" # hostname
      secureConnection: true # use SSL
      port: 465 # port for secure SMTP
      auth:
        user: "steven.evans@bridgenoble.com"
        pass: "sebnemail01"

  getHtml: (templateName, data)->
    templatePath = "../test.html"
    templateContent = fs.readFileSync(templatePath, encoding="utf8")
    _.template templateContent, data, {interpolate: /\{\{(.+?)\}\}/g}

exports = module.exports = Emailer