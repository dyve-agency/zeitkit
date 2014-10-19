app = angular.module("app")

app.factory "Worklog", ["RailsResource", "Timeframe", "railsSerializer", "Client", "UiNotifier", (RailsResource, Timeframe, railsSerializer, Client, UiNotifier)->
  class Worklog extends RailsResource
    @configure url: '/worklogs', name: 'worklog', serializer: railsSerializer(->
      this.exclude("clients")
      this.exclude("client")
      this.exclude("loading")
      this.add("client_id", (wl)->
        if wl.client then wl.client.id else null
      )
    )
    constructor: (opts = {})->
      defaultOpts =
        timeframes: []
        clients: []
        clientId: null
        client: null
        hourlyRate: 0
        comment: ""
        id: null
        loading: false
        errors: []
        notifier: new UiNotifier
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
        tTotal = t.calcTotal(@secondlyRate())
        tTotal
      _.inject(totals, (memo, num)->
          memo + num
        , 0)

    clientChanged: ->
      @hourlyRate = @client.hourlyRate()

    removeTimeframe: (timeframe)->
      @timeframes = _.reject(@timeframes, (tf)-> tf == timeframe)

    isNew: ->
      !@id

    saveWrapper: ->
      return if @loading
      # Reset all errors
      @errors = []
      @loading = true
      callb = if @isNew() then @create() else @save()
      timeframes = @timeframes
      clients    = @clients
      client     = @client
      callb.then((new_worklog)=>
        @loading = false
        @client = client
        @clients = clients
        @timeframes = timeframes
        @notifier.success("Worklog has been successfully saved.")
      , (error)=>
        if error.data
          @errors = error.data
        @loading = false
      )
    applyDataFromWorklog: (wl)->
      @hourlyRate = wl.hourlyRate
      @clients    = _.map wl.clients, (cl)-> new Client(cl)
      @clientId   = wl.clientId
      # Load the real client object
      @client     = _.select(@clients, (cl)=> cl.id == @clientId)[0]
      @timeframes = _.map wl.timeframes, (tf)->
        f = new Timeframe(tf)
        f.started = new Date(tf.started)
        f.ended   = new Date(tf.ended)
        f
      @comment    = wl.comment
      @id         = wl.id

    secondlyRate: ->
      @hourlyRate / 3600

  Worklog
]
