window.App ||= {}

window.App.ClientShares =
  init: ->
    _this = this
    _this.bind_events()
    base_el = $('.client-shares-wrapper')
    base_el.on 'nested:fieldAdded', (e) ->
      elem = $($(e.field).find('.usernames-input input')[0])
      _this.bind_events(elem)
  bind_events: (elem = null)->
    _this = this
    elems = if elem then [elem] else ($('.client-shares-wrapper input'))
    _.each elems, (elem) ->
      elem = $(elem)
      if !elem.data().bound
        _this.bind_single(elem)
        elem.data("bound", true)
  bind_single: (el)->
    el.typeahead
      ajax: {
        url: "/users/usernames.json"
        triggerLength: 2
      }
