// Generated by CoffeeScript 1.7.1

var app = angular.module("app", []);

app.controller("AppCtrl", function($http) {
  var app = this;
  return $http.get("http//localhost:3000/profiles").success(function(data) {
    return app.profiles = data;
  });
});