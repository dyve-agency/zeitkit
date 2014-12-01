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

  $scope.dateOptions =
    formatYear: "yy"
    startingDay: 1

  $scope.open = ($event, timeframe)->
    timeframe.opened = true
    $event.preventDefault()
    $event.stopPropagation()

  $scope.hstep = 1
  $scope.mstep = 10

]
