app = angular.module("app")

app.factory "worklogData", ["Worklog", "Timeframe", "$http", "Client", (Worklog, Timeframe, $http, Client)->
  loadClients = ->
    $http.get("/users/#{gon.current_user_id}/clients").success((data)->
      wl.clients = _.map data, (d)-> new Client(d)
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
