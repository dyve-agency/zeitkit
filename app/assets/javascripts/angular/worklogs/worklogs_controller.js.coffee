app = angular.module("app")

app.controller "WorklogsController", ["$scope", "$q", "Worklog", "Client", ($scope, $q, Worklog, Client)->
  idPresent = gon? && gon && gon.worklog_id
  $q.all([
    Client.query({})
    Worklog.get(gon.worklog_id) if idPresent
  ]).then (results)->
    $scope.clients = results[0]
    $scope.worklog = if idPresent then results[1] else new Worklog

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
    $event.preventDefault()
    $event.stopPropagation()
    timeframe.opened = true

  $scope.openEnded = ($event, timeframe)->
    $event.preventDefault()
    $event.stopPropagation()
    timeframe.openedEnded = true

  $scope.hstep = 1
  $scope.mstep = 10

]
