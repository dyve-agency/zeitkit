app = angular.module("app")

app.factory("UiNotifier", ->
  class UiNotifier
    success: (text)->
      $(".top-right").notify(
        message:
          html: text
        type: "success"
      ).show()

    error: (text) ->
      $(".top-right").notify(
        message:
          html: text
        type: "error"
      ).show()

    hide: ->
      $(".top-right div").css({transition: "opacity 0.3s"}).css({opacity: 0}).css({transition: ""})

    render_error_array: (arr, prefix_msg = "Folgende Fehler sind aufgetreten: ")->
      error_html = window.App.Errors.arr_to_html(arr)
      prefixed = "#{prefix_msg}#{error_html}"
      this.error(prefixed)

    errors_or_fallback: (data, fallback = "Ein unbekannter Fehler is aufgetreten") ->
      if data && data.errors
        @render_error_array(data.errors)
      else
        @error("Unbekannter Fehler beim Request aufgetreten.")


    errors_from_xhr: (xhr, base_message)->
      error_html = base_message
      if xhr && xhr.responseJSON && xhr.responseJSON.errors
        error_html += " #{window.App.Errors.arr_to_html(xhr.responseJSON.errors)}"
      error_html

    loading_message: ->
      this.success("<i class='icon-spinner icon-spin'></i> Lade...")

  UiNotifier
)
