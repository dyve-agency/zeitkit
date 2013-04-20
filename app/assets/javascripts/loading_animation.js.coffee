$ ->
  Loading.elem ||= $('.loading-animation')
  Loading.message ||= $('.loading-message')
  $('form').on 'submit', (e) ->
    Loading.show()
  $('body').on 'click touchstart', 'a', (e) ->
    # Make sure we don't have hyperlinks that close boxes for instance.
    Loading.show() if $(e.currentTarget).attr('href') != "#"
    # Just to be sure, hide loading animations after some time
    setTimeout ( ->
      Loading.hide()
    ), 1000
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
