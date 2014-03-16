app = angular.module("app", [])

app.controller "AppCtrl", ($http, $scope) ->
  app = this
  $http.get("http://localhost:3000/profiles").success (data) ->
    app.people = data