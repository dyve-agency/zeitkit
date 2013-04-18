$ ->
  $('.demo-warn-close').on 'touchstart click', (e) ->
    url = $(e.currentTarget).data().route
    $.ajax url,
      type: 'POST'
      dataType: 'json'
      error: () ->
        console.log('error hiding demo warning')
