app = angular.module("app", [])

app.controller "AppCtrl", ($http) ->
  that = this
  $http.get("http://localhost:3000/profiles").success (data) ->
    that.people = data