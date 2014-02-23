var dashboardApp = angular.module('dashboardApp', ['ngResource', 'highcharts-ng']);

dashboardApp.controller('EntriesCtrl', ['$scope', '$http', 'Incomes','Expenses', 'Entries', 'Entry', function($scope, $http, Incomes, Expenses, Entries, Entry) {
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

  $scope.spareAmount = function() {
    return $scope.totalIncome() - $scope.totalExpense();
  }

  $scope.createIncome = function() {
    Entries.save($scope.newIncome, function(resource) {
      $scope.incomes.unshift(resource);
      $scope.updateChart();
      $scope.newIncome = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.createExpense = function() {
    Entries.save($scope.newExpense, function(resource) {
      $scope.expenses.unshift(resource);
      $scope.updateChart();
      $scope.newExpense = {};
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyIncome = function(id) {
    Entry.delete({id: id}, function(resource) {
      $scope.incomes = Incomes.query();
      $scope.updateChart();
    }, function(response) {
      alert('Error ' + response.status);
    });
  }

  $scope.destroyExpense = function(id) {
    Entry.delete({id: id}, function(resource) {
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
      $scope.chartConfig.series.unshift({data: response});
    });
  }

  $scope.renderChart = function() {
    return !!($scope.totalIncome() > 0 || $scope.totalExpense() > 0)
  }

  $scope.currentEnv = function() {
    var envs = ["xs", "sm", "md", "lg"];
    $el = $('<div>');
    $el.appendTo($('body'));
    for (var i = envs.length - 1; i >= 0; i--) {
      var env = envs[i];
      $el.addClass('hidden-'+env);
      if ($el.is(':hidden')) {
        $el.remove();
        return env
      }
    };
  }

  $scope.entriesLimit = function() {
    if ($scope.currentEnv() == 'xs') {
      return 5;
    } else {
      return $scope.incomes.length + $scope.expenses.length;
    };
  };

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

  $scope.updateChart();
}]);

dashboardApp.factory('Incomes', ['$resource', function($resource) {
  return $resource('/entries/incomes');
}]);

dashboardApp.factory('Expenses', ['$resource', function($resource) {
  return $resource('/entries/expenses');
}]);

dashboardApp.factory('Entries', ['$resource', function($resource) {
  return $resource('/entries');
}]);

dashboardApp.factory('Entry', ['$resource', function($resource) {
  return $resource('/entries/:id');
}]);
