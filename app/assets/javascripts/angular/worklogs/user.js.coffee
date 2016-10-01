app = angular.module("app")

app.factory "User", ["RailsResource", (RailsResource)->
  class User extends RailsResource
    @configure url: '/users', name: 'user'
    constructor: (opts = {})->
      defaultOpts =
        username: ""
      _this = this
      useOpts = _.extend defaultOpts, opts
      _.each useOpts, (val, key) ->
        _this[key] = val

    usernameOrErrorString: ->
      if @user.username.length
        "#{@user.username}"
      else
        "No Username available"
  User
]
