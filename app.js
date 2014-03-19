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

    // Pagination
    $scope.filteredTodos = []
    ,$scope.currentPage = 1
    ,$scope.numPerPage = 10
    ,$scope.maxSize = 5;

    $scope.numPages = function () {
    return Math.ceil(app.people.length / $scope.numPerPage);
    };

    $scope.$watch('currentPage + numPerPage', function() {
    var begin = (($scope.currentPage - 1) * $scope.numPerPage)
    , end = begin + $scope.numPerPage;

    $scope.filteredPeople = app.people.slice(begin, end);
    });
    
})
