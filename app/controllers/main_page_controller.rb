# frozen_string_literal: true

class MainPageController < ActionController::Base

  include RouteBuilding

  def index; end

  def create
    params.require(%i[length_matrix address_array])
  rescue ActionController::ParameterMissing
    render plain: 'Адрес не введен'
  else
    @result = build_route(params)
  end

end
