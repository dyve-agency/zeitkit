$ ->
  Loading.elem ||= $('.loading-animation')
  Loading.message ||= $('.loading-message')
  $('form').on 'submit', (e) ->
    Loading.show()
  $(document).ajaxComplete (e)->
    Loading.hide()
    delete window.App.ajax_loading_message
  $(document).ajaxSend (e)->
    Loading.show(window.App.ajax_loading_message)

Loading = {
  show: (text = false)->
    this.elem.addClass('active')
    this.message.addClass('active').html(text) if text
  hide: ->
    this.elem.removeClass('active')
    this.message.removeClass('active').html()
}
