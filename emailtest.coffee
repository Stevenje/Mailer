dns = require("dns")
net = require("net")

module.exports = (email, callback, timeout) ->
  timeout = timeout or 5000
  unless /^\S+@\S+$/.test(email)
    callback null, false

  dns.resolveMx email.split("@")[1], (err, addresses) ->
    if err or addresses.length is 0
      callback err, false

    conn = net.createConnection(25, addresses[0].exchange)
    commands = [
        "helo " + addresses[0].exchange
        "mail from: <steven.evans@bridgenoble.com>"
        "rcpt to: <#{email}>"
    ]
    i = 0
    conn.setEncoding "ascii"
    conn.setTimeout timeout
    conn.on "error", ->
      conn.emit "false"

    conn.on "false", ->
      callback err, false
      conn.removeAllListeners()

    conn.on "connect", ->
      conn.on "prompt", ->
        if i < 3
          conn.write commands[i]
          conn.write "\n"
          i++
        else
          callback err, true
          conn.removeAllListeners()

      conn.on "undetermined", ->
        #in case of an unrecognisable response tell the callback we're not sure
        callback err, false, true
        conn.removeAllListeners()

      conn.on "timeout", ->
        conn.emit "undetermined"

      conn.on "data", (data) ->
        console.log data
        if data.indexOf("220") isnt -1 or data.indexOf("250") isnt -1
          conn.emit "prompt"
        else unless data.indexOf("550") is -1
          conn.emit "false"
        else
          conn.emit "undetermined"

# compatibility
module.exports.check = module.exports