// Generated by CoffeeScript 1.7.1
var app, express, profiles;

express = require("express");

profiles = require("./routes/profiles");

app = express();

app.get("/profiles", profiles.findAll);

app.get("/profiles/:id", profiles.findById);

app.post("/profiles", profiles.addProfile);

app.put("/profiles/:id", profiles.updateProfile);

app["delete"]("/wines/:id", profiles.deleteProfile);

app.listen(3000);

console.log("Listening on port 3000...");