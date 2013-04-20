$ ->
  Loading.elem ||= $('.loading-animation')
  $('form').on 'submit', (e) ->
    Loading.show()
Loading = {
  show: ->
    this.elem.addClass('active')
  hide: ->
    this.elem.removeClass('active')
}
