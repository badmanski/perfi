var dashboardApp = angular.module('dashboardApp', ['ngResource']);

dashboardApp.controller('EntriesCtrl', ['$scope', 'Income', 'Expense', function($scope, Income, Expense) {
  $scope.incomes = Income.query();
  $scope.expenses = Expense.query();

  $scope.totalIncome = function() {
    var sum = 0;
    angular.forEach($scope.incomes, function(x) {
      sum += parseFloat(x.amount);
    });
    return sum;
  }

  $scope.totalExpense = function() {
    var sum = 0;
    angular.forEach($scope.expenses, function(x) {
      sum += parseFloat(x.amount);
    });
    return sum;
  }

  $scope.createIncome = function() {
    Income.save($scope.newIncome, function(resource) {
      $scope.incomes.push(resource);
      $scope.newIncome = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.createExpense = function() {
    Expense.save($scope.newExpense, function(resource) {
      $scope.expenses.push(resource);
      $scope.newExpense = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }
}]);

dashboardApp.factory('Income', ['$resource', function($resource) {
  return $resource('/incomes.json');
}]);

dashboardApp.factory('Expense', ['$resource', function($resource) {
  return $resource('/expenses.json');
}]);
