/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(() => Invoice.init());
var Invoice = {
  init() {
    const _that = this;
    $('.move-left').on('click', () => _that.moveLeft());
    $('.move-right').on('click', () => _that.moveRight());
    return $('#invoice_client_id').on('change', function() {
      let new_loc;
      const client_id = $(this).find(':selected').val();
      if (client_id === "") { return; }
      const attempt_split = window.location.href.split("?client=");
      const client_param = `?client=${client_id}`;
      if (attempt_split.length === 1) {
        new_loc = window.location.href + client_param;
      } else {
        new_loc = attempt_split[0] + client_param;
      }
      return window.location.href = new_loc;
    });
  },
  elems: {
    invoiceSelect() {
      return $('.invoice-select');
    },
    worklogsSelect() {
      return $('.worklogs-select');
    },
    expensesSelect() {
      return $('.expenses-select');
    },
    productsSelect() {
      return $('.products-select');
    },
    rightSelects() {
      return $('.right-selects select');
    },
    hiddenWorklogs() {
      return $('#invoice_worklog_ids');
    },
    hiddenExpenses() {
      return $('#invoice_expense_ids');
    },
    hiddenProducts() {
      return $('#invoice_product_ids');
    },
    hiddenInputs() {
      return $('.hidden-inputs .dynamic');
    }
  },
  getInvoiceSelected() {
    return this.elems.invoiceSelect().find(':selected');
  },
  // Returns selected expenses and worklogs.
  getInvoiceOptions() {
    return this.elems.invoiceSelect().find('option');
  },
  getRightSelected() {
    return this.elems.rightSelects().find(':selected');
  },
  countOfProducts(id) {
    return this.elems.hiddenInputs().children(`[name='invoice\\[product_ids\\]\\[\\]'][value=${id}]`).length;
  },
  origProductName(id) {
    return this.elems.productsSelect().children(`[class="product"][value=${id}]`).data('title');
  },
  productPrice(id) {
    return this.elems.productsSelect().children(`[class="product"][value=${id}]`).data('price');
  },
  productCurrency(id) {
    return this.elems.productsSelect().children(`[class="product"][value=${id}]`).data('currency');
  },
  roundPrice(price) {
    return (Math.round(price * 100) / 100).toFixed(2);
  },
  moveRight() {
    const elems = this.getInvoiceSelected();
    if (elems.length === 0) { return; }
    this.appendWorklogs(this.filterWorklogs(elems));
    this.appendExpenses(this.filterExpenses(elems));
    this.appendProducts(this.filterProducts(elems));
    this.deselectRight();
    this.appendHiddenInputs(-1);
    return this.toggleNoRemainingNotice();
  },
  moveLeft() {
    const elems = this.getRightSelected();
    if (elems.length === 0) { return; }
    this.appendInvoice(elems);
    this.appendHiddenInputs(1);
    return this.toggleNoRemainingNotice();
  },
  toggleNoRemainingNotice() {
    const expenses = this.elems.expensesSelect();
    const worklogs = this.elems.worklogsSelect();
    const products = this.elems.productsSelect();
    if (worklogs.find('option').length >= 1) {
      worklogs.removeClass('hidden');
      worklogs.siblings("h3").addClass('hidden');
    } else {
      worklogs.addClass('hidden');
      worklogs.siblings("h3").removeClass('hidden');
    }
    if (expenses.find('option').length >= 1) {
      expenses.removeClass('hidden');
      expenses.siblings("h3").addClass('hidden');
    } else {
      expenses.addClass('hidden');
      expenses.siblings("h3").removeClass('hidden');
    }
    if (products.find('option').length >= 1) {
      products.removeClass('hidden');
      return products.siblings("h3").addClass('hidden');
    } else {
      products.addClass('hidden');
      return products.siblings("h3").removeClass('hidden');
    }
  },
  appendHiddenInputs(add) {
    const that = this;
    const dom_el = this.elems.hiddenInputs();
    const el = $('<div></div>');
    const elems = this.getInvoiceOptions();
    const worklogs = this.filterWorklogs(elems);
    const expenses = this.filterExpenses(elems);
    const products = this.filterProducts(elems);
    const worklog_template = _.template("<input type='hidden' name=invoice[worklog_ids][] value='<%= worklog_id %>'>");
    const expense_template = _.template("<input type='hidden' name=invoice[expense_ids][] value='<%= expense_id %>'>");
    const product_template = _.template("<input type='hidden' name=invoice[product_ids][] value='<%= product_id %>'>");
    _.each(worklogs, elem=> el.append(worklog_template({worklog_id: $(elem).val()})));
    _.each(expenses, elem=> el.append(expense_template({expense_id: $(elem).val()})));
    _.each(products, function(elem){
      const pid = $(elem).val();
      const qty = that.countOfProducts(pid) + add;
      const tpl = product_template({product_id: pid});
      return (() => {
        const result = [];
        for (let i = 1, end = qty; i <= end; i++) {
          result.push(el.append(tpl));
        }
        return result;
      })();
    });
    return dom_el.html(el.html());
  },
  appendWorklogs(elems){
    return this.elems.worklogsSelect().append(elems);
  },
  appendExpenses(elems){
    return this.elems.expensesSelect().append(elems);
  },
  appendProducts(elems){
    const that = this;
    return _.each(elems, function(elem){
      let count = that.countOfProducts(elem.value);
      if (count === 1) {
        return elem.remove();
      } else {
        count = count - 1;
        const currency = that.productCurrency(elem.value);
        const price = that.productPrice(elem.value);
        return elem.innerHTML = that.origProductName(elem.value) + ' - ' + count + ' x ' + that.roundPrice(price) + currency + ' = ' + (that.roundPrice(price) * count).toFixed(2) + currency;
      }
    });
  },
  appendInvoice(elems){
    const that = this;
    const invsel = this.elems.invoiceSelect();
    invsel.append(elems.not('.product'));
    return invsel.append(elems.filter('.product').filter(function(index) {
      const option = invsel.children(`[class="product"][value=${this.value}]`);
      const isNew = option.length === 0;
      if (!isNew) {
        const count = that.countOfProducts(this.value) + 1;
        const currency = that.productCurrency(this.value);
        const price = that.productPrice(this.value);
        option[0].innerHTML = that.origProductName(this.value) + ' - ' + count + ' x ' + that.roundPrice(price) + currency + ' = ' + (that.roundPrice(price) * count).toFixed(2) + currency;
      }
      return isNew;
    }).clone());
  },
  filterWorklogs(elems){
    return _.filter(elems, elem => $(elem).hasClass("worklog"));
  },
  filterExpenses(elems){
    return _.filter(elems, elem=> $(elem).hasClass('expense'));
  },
  filterProducts(elems){
    return _.filter(elems, elem=> $(elem).hasClass('product'));
  },
  extractVals(elems){
    return _.map(elems, elem => $(elem).val());
  },
  // Deselect the multi select on the right
  deselectRight() {
    const elems = [this.elems.worklogsSelect(), this.elems.expensesSelect(), this.elems.productsSelect()];
    return _.each(elems, elem => $(elem).val(''));
  }
};
