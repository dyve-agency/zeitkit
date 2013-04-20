$ ->
  Loading.elem ||= $('.loading-animation')
  $('form').on 'submit', (e) ->
    Loading.show()
  $('body').on 'click touchstart', 'a', (e) ->
    Loading.show()
  window.App.loading = Loading

Loading = {
  show: ->
    this.elem.addClass('active')
  hide: ->
    this.elem.removeClass('active')
}
