class DemoController < ApplicationController

  skip_before_filter :require_login

  respond_to :json

  def hide_warning
    session[:hide_demo_warning] = true
    respond_with [], status: 204, location: "hide_demo_warning"
  end

end
