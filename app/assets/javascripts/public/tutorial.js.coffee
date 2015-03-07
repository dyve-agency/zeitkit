$ ->
  Tutorial.init()

Tutorial =
  elems:
    container: ->
      $('.tutorial')
    tips: ->
      $('.tip-explanations .tips')
  init: ->
    _that = this
    this.initHider()
    $('.levels').on 'mouseenter', 'a', (e) ->
      _that.select $(e.currentTarget)
    $('.show-tutorial').on 'click touchstart', (e) ->
      e.preventDefault()
      _that.getTutorial($(e.currentTarget))
  initHider: ->
    _that = this
    $('.tutorial-close').on 'touchstart click', (e) ->
      e.preventDefault()
      _that.hideTutorial($(e.currentTarget))
  select: (elem) ->
    this.removeActive(this.elems.container().find('.shown'))
    counterpart = this.elems.tips()[elem.parent().index()]
    this.addActive [elem, counterpart]
    this.animateLightBulb()
  addActive: (elems)->
    _.each elems, (el) ->
      $(el).addClass("shown")
  removeActive: (elems) ->
    _.each elems, (el) ->
      $(el).removeClass("shown")
  animateLightBulb: ->
    elem = $('.icon-lightbulb')
    elem.removeClass("animate-bulb")
    setTimeout (->
      elem.addClass("animate-bulb")
    ), 200
  hideTutorial: (elem) ->
    url = elem.attr 'href'
    this.elems.container().parent().remove()
    $.ajax url,
      type: 'POST'
      dataType: 'json'
      error: () ->
        console.log('error hiding demo warning')
  getTutorial: (clicked_elem)->
    _that = this
    # Tutorial already there, do nothing.
    if this.elems.container().length > 0
      alert 'Tutorial already shown'
      return
    $.ajax clicked_elem.attr('href'),
      type: 'GET'
      dataType: 'html'
      success: (response) ->
        window.location.reload()
      error: () ->
        console.log('there was an error')
