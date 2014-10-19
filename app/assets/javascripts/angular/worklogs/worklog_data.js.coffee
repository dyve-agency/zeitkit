app = angular.module("app")

app.factory "worklogData", ["Worklog", "Timeframe", "$http", "Client", (Worklog, Timeframe, $http, Client)->

  loadClients = (worklog)->
    $http.get("/users/#{gon.current_user_id}/clients").success((data)->
      worklog.clients = _.map data, (d)-> new Client(d)
    )

  wl = new Worklog()
  wl = new Worklog
  wl.timeframes = []
  wl.timeframes = []
  if gon? && gon && gon.worklog_id
    Worklog.get(gon.worklog_id).then((worklog)->
      wl.applyDataFromWorklog(worklog)
    )
  else
    loadClients(wl)

  wl
]
