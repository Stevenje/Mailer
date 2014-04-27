mongoose = require("mongoose")
textSearch = require("mongoose-text-search")
Profile = require("../models/profile")
request = require("request-json")

#Mongoose Settings
mongoose.connect "mongodb://localhost/githubdb"
db = mongoose.connection

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

