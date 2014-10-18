app = angular.module("app")

app.factory "Timeframe", ["$http", ($http)->
  class Timeframe
    constructor: (opts)->
      defaultOpts =
        started: null
        ended: null
        client: null
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

    calcTotal: (ratePerSecond)->
      if ratePerSecond && @started && @ended
        ((@ended - @started) / 1000) * ratePerSecond
      else
        0
    setEndedNow: ->
      @ended = new Date()

    setStartedNow: ->
      @started = new Date()

  Timeframe
]
