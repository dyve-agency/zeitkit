app = angular.module("app")

app.factory "Client", ["RailsResource", (RailsResource)->
  class Client extends RailsResource
    @configure url: '/clients', name: 'client'
    constructor: (opts = {})->
      defaultOpts =
        hourly_rate_cents: 0
        shared: false
        companyName: ""
        name: ""
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

    nameOrCompanyName: ->
      if @name.length
        "#{@name} [#{@user.username}]"
      else
        "#{@companyName} [#{@user.username}]"
  Client
]
