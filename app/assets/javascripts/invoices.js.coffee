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
    productsSelect: ->
      $('.products-select')
    rightSelects: ->
      $('.right-selects select')
    hiddenWorklogs: ->
      $('#invoice_worklog_ids')
    hiddenExpenses: ->
      $('#invoice_expense_ids')
    hiddenProducts: ->
      $('#invoice_product_ids')
  getInvoiceSelected: ->
    this.elems.invoiceSelect().find(':selected')
  # Returns selected expenses and worklogs.
  getInvoiceOptions: ->
    this.elems.invoiceSelect().find('option')
  getRightSelected: ->
    this.elems.rightSelects().find(':selected')
  moveRight: ->
    elems = this.getInvoiceSelected()
    return if elems.length == 0
    this.appendWorklogs(this.filterWorklogs(elems))
    this.appendExpenses(this.filterExpenses(elems))
    this.appendProducts(this.filterProducts(elems))
    this.deselectRight()
    this.appendHiddenInputs()
    this.toggleNoRemainingNotice()
  moveLeft: ->
    elems = this.getRightSelected()
    return if elems.length == 0
    this.appendInvoice(elems)
    this.appendHiddenInputs()
    this.toggleNoRemainingNotice()
  toggleNoRemainingNotice: ->
    expenses = this.elems.expensesSelect()
    worklogs = this.elems.worklogsSelect()
    products = this.elems.productsSelect()
    if worklogs.find('option').length >= 1
      worklogs.removeClass('hidden')
      worklogs.siblings("h3").addClass('hidden')
    else
      worklogs.addClass('hidden')
      worklogs.siblings("h3").removeClass('hidden')
    if expenses.find('option').length >= 1
      expenses.removeClass('hidden')
      expenses.siblings("h3").addClass('hidden')
    else
      expenses.addClass('hidden')
      expenses.siblings("h3").removeClass('hidden')
    if products.find('option').length >= 1
      products.removeClass('hidden')
      products.siblings("h3").addClass('hidden')
    else
      products.addClass('hidden')
      products.siblings("h3").removeClass('hidden')
  appendHiddenInputs: ->
    dom_el = $('.hidden-inputs .dynamic')
    el = $('<div></div>')
    elems = this.getInvoiceOptions()
    worklogs = this.filterWorklogs(elems)
    expenses = this.filterExpenses(elems)
    products = this.filterProducts(elems)
    worklog_template = _.template("<input type='hidden' name=invoice[worklog_ids][] value='<%= worklog_id %>'>")
    expense_template = _.template("<input type='hidden' name=invoice[expense_ids][] value='<%= expense_id %>'>")
    product_template = _.template("<input type='hidden' name=invoice[product_ids][] value='<%= product_id %>'>")
    _.each worklogs, (elem)->
      el.append worklog_template({worklog_id: $(elem).val()})
    _.each expenses, (elem)->
      el.append expense_template({expense_id: $(elem).val()})
    _.each products, (elem)->
      el.append product_template({product_id: $(elem).val()})
    dom_el.html(el.html())
  appendWorklogs: (elems)->
    this.elems.worklogsSelect().append(elems)
  appendExpenses: (elems)->
    this.elems.expensesSelect().append(elems)
  appendProducts: (elems)->
    this.elems.productsSelect().append(elems)
  appendInvoice: (elems)->
    this.elems.invoiceSelect().append(elems)
  filterWorklogs: (elems)->
    _.filter elems, (elem) ->
      $(elem).hasClass "worklog"
  filterExpenses: (elems)->
    _.filter elems, (elem)->
      $(elem).hasClass 'expense'
  filterProducts: (elems)->
    _.filter elems, (elem)->
      $(elem).hasClass 'product'
  extractVals: (elems)->
    _.map elems, (elem) ->
      $(elem).val()
  # Deselect the multi select on the right
  deselectRight: ->
    elems = [this.elems.worklogsSelect(), this.elems.expensesSelect(), this.elems.productsSelect()]
    _.each elems, (elem) ->
      $(elem).val('')
