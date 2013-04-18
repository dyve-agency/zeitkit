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
    this.removeActive(this.elems.container().find('.active'))
    counterpart = this.elems.tips()[elem.parent().index()]
    this.addActive [elem, counterpart]
  addActive: (elems)->
    _.each elems, (el) ->
      $(el).addClass("active")
  removeActive: (elems) ->
    _.each elems, (el) ->
      $(el).removeClass("active")
