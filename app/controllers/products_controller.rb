class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(params[:product])
    @product.user = current_user
    if @product.save
      redirect_to user_products_path(current_user),
        notice: "Product was successfully created."
    else
      render action: "new"
    end
  end

  def update
    if @product.update_attributes(params[:product])
      redirect_to user_products_path(current_user), notice: 'Product was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @product.destroy
    redirect_to user_products_path(current_user)
  end

end
