var app = angular.module('app', ['ui.bootstrap', 'ui.router']);

app.factory('profiles', function ($http) {
    'use strict';
    return {
        search: function (queryTerm) {
            return $http.post('http://localhost:3000/search', {
                "query": queryTerm
            });
        }
    };
});

app.controller('AppCtrl', function ($scope, $http) {
    'use strict';
    $http.get('http://localhost:3000/profiles')
        .success(function (data) {
            $scope.people = data;
//            $scope.filteredPeople = [];
//            $scope.currentPage = 1;
//            $scope.numPerPage = 10;
//            $scope.maxSize = 5;
//
//            $scope.numPages = function () {
//                return Math.ceil($scope.people.length / $scope.numPerPage);
//            };
//
//            $scope.$watch('currentPage + numPerPage', function () {
//                var begin = (($scope.currentPage - 1) * $scope.numPerPage), end = begin + $scope.numPerPage;
//                $scope.filteredPeople = $scope.people.slice(begin, end);
//            });
        });

    $scope.sendEmail = function (person) {
        console.log('in function, data: ' + person);
        $http.post('http://localhost:3000/email', person)
            .success(function (data) {
                console.log(data);
            });
    };
});

app.controller('SearchCtrl', function ($scope, $http, $location, profiles) {
    'use strict';

    $scope.filteredPeople = [];
    $scope.currentPage = 1;
    $scope.itemsPerPage = 10;

    $scope.numPages = function () {
        return Math.ceil($scope.results.results.length / $scope.itemsPerPage);
    };

    $http.get('http://localhost:3000/templates')
        .success(function (data) {
            console.log(data);
            $scope.templates = data;
            $scope.selectedTemplate = $scope.templates[0];
        });

    $scope.search = function () {
        $scope.loading = true;
        profiles.search($scope.queryTerm)
            .success(function (data) {
                $scope.results = data;
                $scope.loading = false;

                $scope.$watch('currentPage + numPerPage', function () {
                    var begin = (($scope.currentPage - 1) * $scope.itemsPerPage), end = begin + $scope.itemsPerPage;
                    $scope.filteredPeople = $scope.results.results.slice(begin, end);
                });
            });
    };



    $scope.sendEmail = function (person) {
        console.log('Emailing: ' + person.name);
        $http.post('http://localhost:3000/email', person)
            .success(function (data) {
                console.log(data);
            });
    };

    $scope.deleteProfile = function (person) {
        console.log('in function, data: ' + person);
        $http.delete('http://localhost:3000/profiles/' + person._id)
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
            });
    };

});

app.controller('TempCtrl', function ($scope, $http) {
    'use strict';
    $scope.addTemplate = function () {
        $http.post('http://localhost:3000/templates', {
            'client': $scope.client,
            'role': $scope.role,
            'subject': $scope.subject,
            'html': $scope.html })
            .success(function (data) {
                console.log(data);
            });
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
        });
});
