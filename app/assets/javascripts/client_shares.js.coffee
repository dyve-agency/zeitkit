window.App ||= {}

window.App.ClientShares =
  init: ->
    _this = this
    $ ->
      _this.bind_event()
  bind_event: ->
    $(document).on 'nested:fieldAdded', (e) ->
      console.log "foo"
