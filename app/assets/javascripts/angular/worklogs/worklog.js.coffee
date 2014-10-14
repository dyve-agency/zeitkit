app = angular.module("app")

app.factory "Worklog", ["RailsResource", "Timeframe", (RailsResource, Timeframe)->
  class Worklog extends RailsResource
    constructor: (opts = {})->
      defaultOpts =
        timeframes: []
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val
    addNewTimeframe: (timeframe)->
      @timeframes.push timeframe

    addBlankTimeframe: ->
      t = new Timeframe
      @addNewTimeframe t
  Worklog
]
