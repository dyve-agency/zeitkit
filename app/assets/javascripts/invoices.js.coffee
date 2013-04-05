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
    hiddenInputs: ->
      $('.hidden-inputs .dynamic')
  getInvoiceSelected: ->
    this.elems.invoiceSelect().find(':selected')
  # Returns selected expenses and worklogs.
  getInvoiceOptions: ->
    this.elems.invoiceSelect().find('option')
  getRightSelected: ->
    this.elems.rightSelects().find(':selected')
  countOfProducts: (id) ->
    this.elems.hiddenInputs().children("[name='invoice\\[product_ids\\]\\[\\]'][value=" + id + ']').length
  origProductName: (id) ->
    this.elems.productsSelect().children('[class="product"][value=' + id + ']')[0].innerHTML
  moveRight: ->
    elems = this.getInvoiceSelected()
    return if elems.length == 0
    this.appendWorklogs(this.filterWorklogs(elems))
    this.appendExpenses(this.filterExpenses(elems))
    this.appendProducts(this.filterProducts(elems))
    this.deselectRight()
    this.appendHiddenInputs(-1)
    this.toggleNoRemainingNotice()
  moveLeft: ->
    elems = this.getRightSelected()
    return if elems.length == 0
    this.appendInvoice(elems)
    this.appendHiddenInputs(1)
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
  appendHiddenInputs: (add) ->
    that = this
    dom_el = this.elems.hiddenInputs()
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
      pid = $(elem).val()
      qty = that.countOfProducts(pid) + add
      tpl = product_template({product_id: pid})
      for i in [1..qty] by 1
        el.append tpl
    dom_el.html(el.html())
  appendWorklogs: (elems)->
    this.elems.worklogsSelect().append(elems)
  appendExpenses: (elems)->
    this.elems.expensesSelect().append(elems)
  appendProducts: (elems)->
    that = this
    _.each elems, (elem)->
      count = that.countOfProducts(elem.value)
      if count == 1
        elem.remove();
      else
        elem.innerHTML = that.origProductName(elem.value) + ' (' + (count - 1) + ')'
  appendInvoice: (elems)->
    that = this
    invsel = this.elems.invoiceSelect()
    invsel.append(elems.not('.product'))
    invsel.append(elems.filter('.product').filter((index) ->
      option = invsel.children('[class="product"][value=' + this.value + ']')
      isNew = option.length == 0;
      if !isNew
        option[0].innerHTML = this.innerHTML + ' (' + (that.countOfProducts(this.value) + 1) + ')'
      return isNew
    ).clone())
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
