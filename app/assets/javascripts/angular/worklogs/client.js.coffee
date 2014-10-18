app = angular.module("app")

app.factory "Client", ["$http", ($http)->
  class Client
    constructor: (opts)->
      defaultOpts =
        hourly_rate_cents: 0
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

    hourlyRate: ->
      @hourly_rate_cents / 100

    secondlyRate: ->
      @hourlyRate() / 3600

  Client
]
