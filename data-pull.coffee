request = require('request-json')
client = request.newClient 'https://api.github.com/'

lang = 'ruby'
location = 'london'
page = 1

gitdata = (lang, location, page) ->
  client.get 'search/users?q=location:' + location + '+language:' + lang + '&page=' + page, (err, res, body) ->
    console.log 'Total Users found: ' + body.total_count
    console.log body.items[0]


gitdata(lang, location, page)
