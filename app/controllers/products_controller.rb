class ProductsController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :json

  def index
  end

  def new
  end

  def edit
  end

  def create
    flash[:notice] = "Product was successfully created." if @product.save
    respond_with @product, location: products_path
  end

  def update
    flash[:notice] = 'Product was successfully updated.' if @product.update_attributes(params[:product])
    respond_with @product, location: products_path
  end

  def destroy
    @product.destroy
    flash[:notice] = 'Product was successfully deleted.'
    respond_with @product
  end

end
