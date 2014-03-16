express = require("express")
http = require("http")
cors = require("cors")
profiles = require("./routes/profiles") # Hook up to Mongo 

app = express()
app.use(cors())

# Rest API Implimentation
app.get "/profiles", profiles.findAll
app.get "/profiles/:id", profiles.findById
app.post "/profiles", profiles.addProfile
app.put "/profiles/:id", profiles.updateProfile
app.delete "/wines/:id", profiles.deleteProfile

# Listen on port 3000 ;)
app.listen 3000
console.log "Listening on port 3000 ;)"