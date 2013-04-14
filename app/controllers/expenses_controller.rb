class ExpensesController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_with @expenses
  end

  def new
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

end
