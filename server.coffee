express = require("express")
http = require("http")
cors = require("cors")
profiles = require("./routes/profiles") # Hook up to Mongo

app = express()

app.configure ->
  app.use express.logger("dev") # 'default', 'short', 'tiny', 'dev'
  app.use express.bodyParser() #read body of responces
  app.use(cors()) #all cross-site requests



# Rest API Implimentation
app.get "/profiles", profiles.findAll
app.get "/profiles/:id", profiles.findById
app.post "/profiles", profiles.addProfile
app.put "/profiles/:id", profiles.updateProfile
app.delete "/wines/:id", profiles.deleteProfile
app.post "/email", profiles.sendEmail

# Listen on port 3000 ;)
app.listen 3000
console.log "Listening on port 3000 ;)"