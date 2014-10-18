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
        editingComment: false
        comment: ""
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val
    addNewTimeframe: (timeframe)->
      @timeframes.push timeframe

    addBlankTimeframe: ->
      t = new Timeframe
      if @timeframes.length
        last_started = _.last(@timeframes).started
        if last_started
          t.started = new Date(last_started)
        else
          t.started = new Date
        last_ended = _.last(@timeframes).ended
        if last_ended
          t.ended = new Date(last_ended)
        else
          t.ended = new Date
      else
        t.started = new Date
        t.ended = new Date
      @addNewTimeframe t

    calcTotal: ->
      totals = _.map @timeframes, (t)=>
        tTotal = t.calcTotal(if @client then @client.secondlyRate() else 0)
        tTotal
      _.inject(totals, (memo, num)->
          memo + num
        , 0)

    clientChanged: ->
      @hourlyRate = @client.hourly_rate_cents / 100
    removeTimeframe: (timeframe)->
      @timeframes = _.reject(@timeframes, (tf)-> tf == timeframe)
  Worklog
]
