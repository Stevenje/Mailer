// Generated by CoffeeScript 1.7.1
var Profile, callback, md, mongoose, request, textSearch;

mongoose = require("mongoose");

textSearch = require("mongoose-text-search");

Profile = require("../models/profile");

request = require("request-json");

mongoose.connect("mongodb://localhost/githubdb");

md = mongoose.connection;

md.on("error", console.error.bind(console, "connection error:"));

md.once("open", callback = function() {
  return console.log("Mongoose - connected");
});

exports.findAll = function(req, res) {
  return Profile.find(function(err, profiles) {
    if (err) {
      return console.log(err);
    } else {
      return res.send(profiles);
    }
  });
};

exports.findById = function(req, res) {
  var id;
  id = req.params.id;
  return Profile.findById(id, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      res.send(data);
      return console.log("Find By Id: " + data._id);
    }
  });
};

exports.search = function(req, res) {
  var options, searchTerm;
  searchTerm = req.body.query;
  options = {
    limit: 100
  };
  return Profile.textSearch(searchTerm, options, function(err, profiles) {
    if (err) {
      return console.log(err);
    } else {
      return res.send(profiles);
    }
  });
};

exports.comp = function(req, res) {
  var client, searchTerm;
  searchTerm = req.body.query;
  client = request.newClient('http://api.crunchbase.com/v/1/');
  return client.get("search.js?query=" + searchTerm + "&entity=company&api_key=sxpx4ehymgj83ksgk7qbzmzc", function(err, resp, body) {
    if (err) {
      return console.log(err);
    } else {
      return res.send(body.results);
    }
  });
};

exports.updateProfile = function(req, res) {
  var id, update;
  id = req.params.id;
  update = req.body;
  console.log("id: " + id);
  console.log("update: " + update);
  return Profile.findById(id, function(err, profile) {
    profile.author = "steven";
    return profile.save(function(err) {
      if (err) {
        console.log(err);
      }
      return res.send(profile);
    });
  });
};

exports.deleteProfile = function(req, res) {
  var id;
  id = req.params.id;
  return Profile.findByIdAndRemove(id, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      res.send(data);
      return console.log(data);
    }
  });
};
