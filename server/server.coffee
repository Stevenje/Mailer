express = require("express")
bodyParser = require("body-parser")
http = require("http")
cors = require("cors")
logger = require("morgan")

profiles = require("./routes/profiles2")
email = require("./routes/email")

app = express()

app.use logger("dev") # 'default', 'short', 'tiny', 'dev'
app.use bodyParser() #read body of responses
app.use cors() #all cross-site requests

# Rest API Implementation
app.get "/profiles", profiles.findAll
app.get "/profiles/:id", profiles.findById
#app.post "/profiles", profiles.addProfile
app.put "/profiles/:id", profiles.updateProfile
app.delete "/profiles/:id", profiles.deleteProfile
app.post "/email", email.sendEmail
app.post "/search", profiles.search
app.post "/comp", profiles.comp
app.get "/templates", email.findAll
app.post "/templates", email.addTemplate


# Listen on port 3000 ;)
app.listen 3000
console.log "Listening on port 3000 ;)"
