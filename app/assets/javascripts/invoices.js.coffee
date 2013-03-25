$ ->
  Invoice.init()
Invoice =
  init: ->
    _that = this
    $('.move-left').on 'click', ->
      _that.moveLeft()
    $('.move-right').on 'click', ->
      _that.moveRight()
    $('#invoice_client_id').on 'change', ->
      client_id = $(this).find(':selected').val()
      return if client_id == ""
      attempt_split = window.location.href.split("?client=")
      client_param = "?client=" + client_id
      if attempt_split.length == 1
        new_loc = window.location.href + client_param
      else
        new_loc = attempt_split[0] + client_param
      window.location.href = new_loc
  elems:
    invoiceSelect: ->
      $('.invoice-select')
    worklogsSelect: ->
      $('.worklogs-select')
    expensesSelect: ->
      $('.expenses-select')
    rightSelects: ->
      $('.right-selects select')
  getInvoiceSelected: ->
    this.elems.invoiceSelect().find(':selected')
  # Returns selected expenses and worklogs.
  getRightSelected: ->
    this.elems.rightSelects().find(':selected')
  moveRight: ->
    elems = this.getInvoiceSelected()
    return if elems.length == 0
    this.appendWorklogs(this.filterWorklogs(elems))
    this.appendExpenses(this.filterExpenses(elems))
    this.deselectRight()
  moveLeft: ->
    elems = this.getRightSelected()
    return if elems.length == 0
    this.appendInvoice(elems)
  appendWorklogs: (elems)->
    this.elems.worklogsSelect().append(elems)
  appendExpenses: (elems)->
    this.elems.expensesSelect().append(elems)
  appendInvoice: (elems)->
    this.elems.invoiceSelect().append(elems)
  filterWorklogs: (elems)->
    _.filter elems, (elem) ->
      $(elem).hasClass "worklog"
  filterExpenses: (elems)->
    _.filter elems, (elem)->
      $(elem).hasClass 'expense'
  # Deselect the multi select on the right
  deselectRight: ->
    elems = [this.elems.worklogsSelect(), this.elems.expensesSelect()]
    _.each elems, (elem) ->
      $(elem).val('')
