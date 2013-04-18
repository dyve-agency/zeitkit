$ ->
  Tutorial.init()
  $.tutorial = Tutorial

Tutorial =
  elems:
    container: ->
      $('.tutorial')
    tips: ->
      $('.tip-explanations .tips')
  init: ->
    _that = this
    $('.levels').on 'mouseenter', 'a', (e) ->
      _that.select $(e.currentTarget)
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
