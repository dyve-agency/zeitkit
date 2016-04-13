class ExpensesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    @expenses = @expenses.order("created_at DESC, client_id DESC")
    respond_with @expenses
  end

  def new
    if params[:client_id]
      client = Client.find(params[:client_id])
      if client
        @expense.client = client
      end
    else
      @expense.client = set_client
    end
  end

  def edit
  end

  def create
    @expense.user = current_user
    flash[:notice] = "Expense was successfully created." if @expense.save
    respond_with @expense, location: expenses_path
  end

  def update
    flash[:notice] = 'Expense was successfully updated.' if @expense.update_attributes(params[:expense])
    respond_with @expense, location: expenses_path
  end

  def destroy
    @expense.destroy
    flash[:notice] = 'Expense was successfully deleted.'
    respond_with @expense
  end

  def set_client
    if current_user.expenses.any?
      @client = current_user.expenses.last.client
    elsif current_user.clients.count == 1
      @client = current_user.clients.first
    end
    @client
  end

end
