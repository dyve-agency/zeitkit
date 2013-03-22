class StaticController < ApplicationController
  respond_to :html

  def home
    @css_class = "home-design"
  end
end

