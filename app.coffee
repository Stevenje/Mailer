app = angular.module "app", []

app.controller "AppCtrl", ($http) ->
  app = @
  $http.get "http//localhost:3000/profiles"
    .success (data) ->
      app.profiles = data