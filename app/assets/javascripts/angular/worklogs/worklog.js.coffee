app = angular.module("app")

app.factory "Worklog", ["RailsResource", "Timeframe", "railsSerializer", "Client", "UiNotifier", (RailsResource, Timeframe, railsSerializer, Client, UiNotifier)->
  class Worklog extends RailsResource
    @configure url: '/worklogs', name: 'worklog', serializer: railsSerializer(->
      @exclude("clients")
      @exclude("client")
      @exclude("loading")
      @exclude("currency")
      @exclude("errors")
      @add("client_id", (wl)->
        if wl.client then wl.client.id else null
      )
      @resource "client", "Client"
      @resource "timeframes", "Timeframe"
    )
    constructor: (opts = {})->
      defaultOpts =
        timeframes: []
        clients: []
        sharedClients: []
        clientId: null
        client: null
        hourlyRate: 0
        comment: ""
        id: null
        loading: false
        errors: []
        total: 0
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
      @hourlyRate = if @client then @client.hourlyRate else 0
      @currency = if @client then @client.currency


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
        @notifier.success("Worklog has been successfully saved.")
        setTimeout(->
          window.location.reload()
        , 200)
      , (error)=>
        if error.data
          @errors = error.data
        @loading = false
      )
    applyDataFromWorklog: (wl)->
      @hourlyRate = wl.hourlyRate
      @clients    = _.map wl.clients, (cl)-> new Client(cl)
      # Concat all shared clients
      shared = _.map wl.sharedClients, (scl)->
        c = new Client(scl)
        c.shared = true
        c
      @clients    = @clients.concat(shared)

      @clientId   = wl.clientId
      @selectClientById()
      @timeframes = _.map wl.timeframes, (tf)->
        f = new Timeframe(tf)
        f.started = new Date(tf.started)
        f.ended   = new Date(tf.ended)
        f
      @comment    = wl.comment
      @id         = wl.id
      @total      = wl.total

    secondlyRate: ->
      @hourlyRate / 3600

    selectClientById: ->
      client     = _.select(@clients, (cl)=> cl.id == @clientId)[0]
      @client = client
      @clientChanged()
      @client

    roundupTimeframes: ->
      _.each @timeframes, (tf)=>
        if tf.ended
          tf.ended = @roundDateUp(tf.ended)
        if tf.started
          tf.started = @roundDateDown(tf.started)
    roundDateUp: (date)->
      coeff = 1000 * 60 * 5
      new Date(Math.ceil(date.getTime() / coeff) * coeff)
    roundDateDown: (date)->
      coeff = 1000 * 60 * 5
      new Date(Math.floor(date.getTime() / coeff) * coeff)

    creditBlocked: ->
      @client && @client.creditBlockReason && @client.creditBlockReason.length

  Worklog
]
