class StaticController < ApplicationController
  respond_to :html
  skip_before_filter :require_login

  def home
    @css_class = "home-design"
  end
end

