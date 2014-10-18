app = angular.module("app")

app.factory "Worklog", ["RailsResource", "Timeframe", (RailsResource, Timeframe)->
  class Worklog extends RailsResource
    constructor: (opts = {})->
      defaultOpts =
        timeframes: []
        clients: []
        clientId: null
        client: null
        hourlyRate: 0
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val
    addNewTimeframe: (timeframe)->
      @timeframes.push timeframe

    addBlankTimeframe: ->
      t = new Timeframe
      if @timeframes.length
        t.started = new Date(_.last(@timeframes).started)
        t.ended = new Date(_.last(@timeframes).ended)
      @addNewTimeframe t

    calcTotal: ->
      totals = _.map @timeframes, (t)=>
        t.calcTotal(if @client then @client.secondlyRate() else 0)
      _.inject(totals, (memo, num)->
          nemo + num
        , 0)

    clientChanged: ->
      @hourlyRate = @client.hourly_rate_cents / 100
    removeTimeframe: (timeframe)->
      @timeframes = _.reject(@timeframes, (tf)-> tf == timeframe)
  Worklog
]
