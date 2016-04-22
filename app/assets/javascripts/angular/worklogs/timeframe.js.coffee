app = angular.module("app")

app.factory "Timeframe", ["RailsResource", "railsSerializer", (RailsResource, railsSerializer)->
  class Timeframe extends RailsResource
    @configure url: '/timeframes', name: 'timeframe', serializer: railsSerializer(->
      @exclude("client")
      @resource "worklog", "Worklog"
    )
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
        @durationSeconds() * ratePerSecond
      else
        0
    durationSeconds: ->
      # For some reason the provided @ended and @started formats aren't working.
      # It's necessary to recreate a new Date, based on the dates provided.
      # Else the calculation causes a NaN
      return (((new Date(@ended)) - (new Date(@started))) / 1000)

    setEndedNow: ->
      @ended = new Date()

    setStartedNow: ->
      @started = new Date()

    checkForIssues: ->
      issues = []
      # TimeFrame more than 10 hours.
      tenHours = 3600 * 10
      if @started && @ended && @durationSeconds() >= tenHours
        issues.push "Duration is longer than 10 hours. Please double-check."
      if @started && @ended && @durationSeconds() < 0
        issues.push "Duration is smaller 0. Please check."
      issues

    issueDetected: ->
      @checkForIssues().length > 0

  Timeframe
]
