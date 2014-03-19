var app = angular.module("app", []);

app.controller("AppCtrl", function($http) {
    var  app = this;
    $http.get("http://localhost:3000/profiles")
        .success(function(data) {
            app.people = data;
        })

    app.sendEmail = function(person){
        console.log("in function, data: " + person)
        $http.post("http://localhost:3000/email", person)
            .success(function(data){
                console.log(data)
            })
    }
    
})
