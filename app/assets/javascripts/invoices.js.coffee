$ ->
  Invoice.init()
Invoice = {
  totalInput: ->
    return $('#invoice_total')
  init: ->
    _that = this
    $('.unpaid-worklogs').on 'click touchstart', 'a', (e) ->
      e.preventDefault()
      _that.totalInput().val($(e.currentTarget).data().total / 100)
    $('.unpaid-expenses').on 'click touchstart', '.add-total', (e) ->
      e.preventDefault()
      input = _that.totalInput()
      oldval = input.val()
      add = $(e.currentTarget).data().total / 100
      new_val = (parseFloat(oldval) + add).toFixed(2)
      input.val(new_val)
}
