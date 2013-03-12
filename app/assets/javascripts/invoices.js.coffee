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
      _that.updateContent($(e.currentTarget))
      input.val(new_val)
  updateContent: (elem)->
    update_elem = $('#invoice_content')
    old_val = update_elem.val()
    add_text = elem.data().reason + " = " + elem.data().total_currency
    new_val = old_val + "\n" + add_text
    update_elem.val(new_val)
}
