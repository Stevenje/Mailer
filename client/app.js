var app = angular.module('app', ['ui.bootstrap', 'ui.router']);

app.controller('AppCtrl', function ($scope, $http) {
    'use strict';
    $http.get('http://localhost:3000/profiles')
        .success(function (data) {
            $scope.people = data;
            $scope.filteredPeople = [];
            $scope.currentPage = 1;
            $scope.numPerPage = 10;
            $scope.maxSize = 5;

            $scope.numPages = function () {
                return Math.ceil($scope.people.length / $scope.numPerPage);
            };

            $scope.$watch('currentPage + numPerPage', function () {
                var begin = (($scope.currentPage - 1) * $scope.numPerPage), end = begin + $scope.numPerPage;

                $scope.filteredPeople = $scope.people.slice(begin, end);
            });
        });

    $scope.sendEmail = function (person) {
        console.log('in function, data: ' + person);
        $http.post('http://localhost:3000/email', person)
            .success(function (data) {
                console.log(data);
            });
    };
});

app.controller('SearchCtrl', function ($scope, $http) {

    $scope.search = function () {
        $http.post('http://localhost:3000/search', {'query': $scope.queryTerm })
            .success(function (data) {
                $scope.results = data;
            })
    };

    $scope.sendEmail = function (person) {
        console.log('in function, data: ' + person);
        $http.post('http://localhost:3000/email', person)
            .success(function (data) {
                console.log(data);
            });
    };


});

app.controller('CompCtrl', function ($scope, $http) {

    $scope.search = function () {
        $http.post('http://localhost:3000/comp', {'query': $scope.queryTerm })
            .success(function (data) {
                $scope.results = data;
            })
    };

});
// UI-ROUTER =======================================
app.config(function ($stateProvider, $urlRouterProvider) {
    'use strict';
    $urlRouterProvider.otherwise('/');

    $stateProvider
        // HOME STATES AND NESTED VIEWS ========================================
        .state('index', {
            url: '/',
            templateUrl: 'templates/partial-home.html'
        })

        // ABOUT PAGE AND MULTIPLE NAMED VIEWS =================================
        .state('profiles', {
            url: '/profiles',
            templateUrl: 'templates/partial-search.html'
        })
        .state('comp', {
            url: '/comp',
            templateUrl: 'templates/partial-comp.html'
        })
        .state('template', {
            url: '/template',
            templateUrl: 'templates/partial-template.html'
        })
});
