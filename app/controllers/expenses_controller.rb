class ExpensesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @expense = Expense.new
  end

  def edit
  end

  def create
    @expense = Expense.new(params[:expense])
    @expense.user = current_user
    if @expense.save
      redirect_to user_expenses_path(current_user),
        notice: "Expense was successfully created."
    else
      render action: "new"
    end
  end

  def update
    if @expense.update_attributes(params[:expense])
      redirect_to user_expenses_path(current_user), notice: 'Expense was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @expense.destroy
    redirect_to user_expenses_path(current_user)
  end

  def toggle_paid
    @expense.toggle_paid
    if @expense.save
      redirect_to user_expenses_path(current_user), notice: 'Expense was successfully updated.'
    else
      render action: "edit"
    end
  end
end
