var dashboardApp = angular.module('dashboardApp', ['ngResource', 'highcharts-ng']);

dashboardApp.controller('EntriesCtrl', ['$scope', '$http', 'Incomes', 'Income', 'Expenses', 'Expense', function($scope, $http, Incomes, Income, Expenses, Expense) {
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
      $scope.updateChart();
      $scope.newIncome = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.createExpense = function() {
    Expenses.save($scope.newExpense, function(resource) {
      $scope.expenses.push(resource);
      $scope.updateChart();
      $scope.newExpense = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyIncome = function(id) {
    Income.delete({id: id}, function(resource) {
      $scope.incomes = Incomes.query();
      $scope.updateChart();
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyExpense = function(id) {
    Expense.delete({id: id}, function(resource) {
      $scope.expenses = Expenses.query();
      $scope.updateChart();
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.updateChart = function() {
    $http.get('/chart_data').success(function(response) {
      angular.forEach(response, function(x) {
        x[1] = parseFloat(x[1]);
      });
      $scope.chartConfig.series = [];
      $scope.chartConfig.series.push({data: response});
    });
  }

  $scope.chartConfig = {
    options: {
      chart: {
        type: 'pie'
      }
    },
    title: {
      text: 'Current balance'
    },
    credits: {
      enabled: false
    }
  };

  angular.element(document).on('ready page:load', function() {
    $scope.updateChart();
  });
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
  return $resource('/expenses/:id.json');
}]);
