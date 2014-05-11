class KpisController < ApplicationController
  def new
    @kpi = Kpi.new
  end

  def create
    @kpi = Kpi.new(params[:kpi])
    @kpi.generate_user_data
    render partial: "data", layout: false, locals: { kpi: @kpi }
  end
end
