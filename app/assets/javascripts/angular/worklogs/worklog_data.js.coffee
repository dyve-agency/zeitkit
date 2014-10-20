app = angular.module("app")

app.factory "worklogData", ["Worklog", "Timeframe", "$http", "Client", (Worklog, Timeframe, $http, Client)->

  loadClients = (worklog)->

    loadingSucces = (data, shared = false) ->
      converted = _.map data, (d)->
        c = new Client
        c.companyName = d.company_name
        c.hourlyRateCents = d.hourly_rate_cents
        c.id = d.id
        c.shared = shared
        c
      worklog.clients = worklog.clients.concat(converted)
      worklog.clientId = gon.client_id if gon.client_id
      worklog.selectClientById()

    $http.get("/users/#{gon.current_user_id}/clients").success((data)->
      loadingSucces(data, false)
    )

    $http.get("/users/#{gon.current_user_id}/shared_clients").success((data)->
      loadingSucces(data, true)
    )

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
