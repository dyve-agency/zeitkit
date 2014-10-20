app = angular.module("app")

app.factory "Client", ["$http", ($http)->
  class Client
    constructor: (opts)->
      defaultOpts =
        hourly_rate_cents: 0
        shared: false
        companyName: ""
        name: ""
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

    hourlyRate: ->
      @hourlyRateCents / 100

    nameOrCompanyName: ->
      if @name.length
        @name
      else
        @companyName

  Client
]
