class KpisController < ApplicationController
  def new
    @kpi = Kpi.new
  end

  def create
    @kpi = Kpi.new(params[:kpi])
    render partial: "data", layout: false, locals: { kpi: @kpi }
  end
end
