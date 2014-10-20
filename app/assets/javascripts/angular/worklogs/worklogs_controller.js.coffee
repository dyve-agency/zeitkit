app = angular.module("app")

app.controller "WorklogsController", ["$scope", "worklogData", ($scope, worklogData)->
  $scope.worklog = worklogData

  $scope.$watch("worklog.client", (newValue, oldValue)->
    t = $scope.worklog.calcTotal()
    $scope.worklog.total = t
  )
  $scope.$watch("worklog.hourlyRate", (newValue, oldValue)->
    t = $scope.worklog.calcTotal()
    $scope.worklog.total = t
  )
  $scope.$watch("worklog.timeframes", (newValue, oldValue)->
    t = $scope.worklog.calcTotal()
    $scope.worklog.total = t
  , true)
]
