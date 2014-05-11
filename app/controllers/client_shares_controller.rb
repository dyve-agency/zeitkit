class ClientSharesController < ApplicationController
  def destroy
    @client_share = current_user.client_shares.find(params[:id])
    if @client_share.destroy
      redirect_to clients_path, notice: "Successfully removed shared client"
    else
      redirect_to clients_path, flash: {error: "Could not remove shared client" }
    end
  end
end
