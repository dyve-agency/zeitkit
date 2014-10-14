app = angular.module("app")

app.factory "worklogData", ["Worklog", "Timeframe", (Worklog, Timeframe)->
  if gon? && gon && gon.worklog_id
    # TODO implement edit action
  else
    wl = new Worklog
    wl.timeframes = []
    wl.timeframes = []
  wl
]
