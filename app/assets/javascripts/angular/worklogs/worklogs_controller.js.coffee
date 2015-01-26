app = angular.module("app")

app.controller "WorklogsController", ["$scope", "$q", "Worklog", "Client", ($scope, $q, Worklog, Client)->
  $scope.init = ->
    $scope.hstep = 1
    $scope.mstep = 10
    $scope.clients = []
    $scope.dateOptions =
      formatYear: "yy"
      startingDay: 1
    idPresent = gon? && gon && gon.worklog_id

    # Only fetch worklog if it is present
    query = _.select [
      Client.query({}),
      if idPresent then Worklog.get(gon.worklog_id) else null
    ], (e)->
      e

    $q.all(query).then (results)->
      $scope.clients = results[0]
      $scope.worklog = if idPresent then results[1] else new Worklog

      # All loaded, start watching.
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

  $scope.open = ($event, timeframe)->
    $event.preventDefault()
    $event.stopPropagation()
    timeframe.opened = true

  $scope.openEnded = ($event, timeframe)->
    $event.preventDefault()
    $event.stopPropagation()
    timeframe.openedEnded = true

  $scope.init()

]
