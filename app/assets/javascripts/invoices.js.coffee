$ ->
  $('.client-unpaid-list').on 'click touchstart', 'a', (e) ->
    e.preventDefault()
    $('#invoice_total').val($(e.currentTarget).siblings('.unpaid-total').html())
