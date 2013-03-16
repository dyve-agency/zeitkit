class StaticController < ApplicationController
  respond_to :html

  def home
    @css_class = "home-design"
    session[:mac_app] = true if params[:mac_app]
  end
end
