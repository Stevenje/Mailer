nodemailer = require("nodemailer")

smtpTransport = nodemailer.createTransport "SMTP",
    service: "Gmail"
    auth: 
        user: "snevets@gmail.com"
        pass: "XXXX"

mailOptions =
	from: "Fred Foo <foo@blurdybloop.com>"
	to: "snevets@gmail.com"
	subject: "SUBJECT LINE"
	text: "THIS IS TEXT"
	html: "<b>THIS IS HTML</b>" 

# for num in [1..6]
smtpTransport.sendMail mailOptions, (error, response) ->
    if error 
        console.log error
    else
        console.log "Message sent: " + response.message

smtpTransport.close()  