var app = angular.module("app", []);

app.controller("AppCtrl", function($http) {
    var  that = this;
    $http.get("http://localhost:3000/profiles")
        .success(function(data) {
            that.people = data;
        })

    app.sendEmail = function(person) {    
        $http.post("http://localhost:3000/email", person)
            .success(function() {
                console.log("success");
            })
	    


    }
})