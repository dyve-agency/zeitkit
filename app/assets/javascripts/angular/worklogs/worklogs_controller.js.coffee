app = angular.module("app")

app.controller "WorklogsController", ["$scope", "$q", "Worklog", "Client", "User", ($scope, $q, Worklog, Client, User)->
  $scope.init = ->
    $scope.hstep = 1
    $scope.mstep = 10
    $scope.clients = []
    $scope.currentUser = null
    $scope.dateOptions =
      formatYear: "yy"
      startingDay: 1
    idPresent = gon? && gon && gon.worklog_id

    # Only fetch worklog if it is present
    query = _.select [
      Client.query({}),
      User.get(gon.current_user_id),
      if idPresent then Worklog.get(gon.worklog_id) else null
    ], (e)->
      e

    $q.all(query).then (results)->
      $scope.clients = results[0]
      $scope.currentUser = results[1]

      if idPresent
        $scope.worklog = results[2]
      else
        $scope.worklog = new Worklog

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
        duration = $scope.worklog.calcTotalDuration()
        $scope.worklog.total = t
        $scope.worklog.totalDuration = moment.duration(duration, 'seconds')
      , true)

      if gon.client_id
        getSelectedClient = ->
          _.select($scope.clients, (c)-> c.id == gon.client_id)[0]
        $scope.worklog.client = getSelectedClient()

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
