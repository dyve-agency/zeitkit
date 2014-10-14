app = angular.module("app")

app.factory "worklogData", ["Worklog", "Timeframe", "$http", (Worklog, Timeframe, $http)->
  loadClients = ->
    $http.get("/users/#{gon.current_user_id}/clients").success((data)->
      wl.clients = data
    )
  if gon? && gon && gon.worklog_id
    # TODO implement edit action
  else
    wl = new Worklog
    wl.timeframes = []
    wl.timeframes = []
    loadClients()

  wl
]
