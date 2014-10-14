app = angular.module("app")

app.factory "Timeframe", ["$http", ($http)->
  class Timeframe
    constructor: (opts)->
      defaultOpts =
        started: null
        ended: null
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

  Timeframe
]
