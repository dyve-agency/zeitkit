$ ->
  $('.client-unpaid-list').on 'click touchstart', 'a', (e) ->
    e.preventDefault()
    $('#invoice_total').val($(e.currentTarget).parent().siblings('.unpaid-total').html())
