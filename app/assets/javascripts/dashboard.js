var dashboardApp = angular.module('dashboardApp', ['ngResource']);

dashboardApp.controller('IncomesCtrl', ['$scope', 'Income', function($scope, Income) {
  $scope.incomes = Income.query();
  $scope.total = function() {
    var sum = 0;
    for (var i = 0; i < $scope.incomes.length; i++) {
      sum += parseFloat($scope.incomes[i].amount);
    };
    return sum;
  }
  $scope.create = function() {
    Income.save($scope.newIncome, function(resource) {
      $scope.incomes.push(resource);
      $scope.newIncome = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }
}]);

dashboardApp.factory('Income', ['$resource', function($resource) {
  return $resource('/incomes.json');
}]);