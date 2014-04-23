var emailExistence = require("email-existence")

emailExistence.check('nettoer@yahoo.com', function(err,res){
    console.log('res: '+res);
});