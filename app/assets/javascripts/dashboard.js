var dashboardApp = angular.module('dashboardApp', ['ngResource']);

dashboardApp.controller('EntriesCtrl', ['$scope', 'Incomes', 'Income', 'Expenses', 'Expense', function($scope, Incomes, Income, Expenses, Expense) {
  $scope.incomes = Incomes.query();
  $scope.expenses = Expenses.query();

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
    Incomes.save($scope.newIncome, function(resource) {
      $scope.incomes.push(resource);
      $scope.newIncome = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.createExpense = function() {
    Expenses.save($scope.newExpense, function(resource) {
      $scope.expenses.push(resource);
      $scope.newExpense = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyExpense = function(id) {
    Expense.delete({id: id}, function(resource) {
       $scope.expenses = Expenses.query();
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyIncome = function(id) {
    Income.delete({id: id}, function(resource) {
       $scope.incomes = Incomes.query();
    }, function(response) {
      alert('Error ' + response.status);
    });
  }
}]);

dashboardApp.factory('Incomes', ['$resource', function($resource) {
  return $resource('/incomes.json');
}]);

dashboardApp.factory('Income', ['$resource', function($resource) {
  return $resource('/incomes/:id.json')
}]);

dashboardApp.factory('Expenses', ['$resource', function($resource) {
  return $resource('/expenses.json');
}]);

dashboardApp.factory('Expense', ['$resource', function($resource) {
  return $resource('/expenses/:id.json')
}]);
