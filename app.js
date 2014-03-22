var app = angular.module("app", ['ui.bootstrap']);

app.controller("AppCtrl", function($scope, $http) {
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

   app.repoDistribution = function(repos) {
      var dist, repo, _i, _len;
      dist = {};
      for (_i = 0, _len = repos.length; _i < _len; _i++) {
        repo = repos[_i];
        if (dist[repo.language] === undefined) {
          dist[repo.language] = 1;
        } else {
          dist[repo.language] += 1;
        }
      }
      // console.log(dist);
      return dist;
    };

    app.total = function(dist) {
        var total = 0;

        for (var lang in dist) {
            total += lang;
        }
        console.log(total)
    }

    $scope.isCollapsed = true;

    // // Pagination
    // $scope.filteredTodos = []
    // ,$scope.currentPage = 1
    // ,$scope.numPerPage = 10
    // ,$scope.maxSize = 5;

    // $scope.numPages = function () {
    //     return Math.ceil(app.people.length / $scope.numPerPage);
    // };

    // $scope.$watch('currentPage + numPerPage', function() {
    //     var begin = (($scope.currentPage - 1) * $scope.numPerPage), end = begin + $scope.numPerPage;

    // $scope.filteredPeople = app.people.slice(begin, end);
    // });
    
})
