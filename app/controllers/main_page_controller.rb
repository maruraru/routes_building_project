# frozen_string_literal: true

class MainPageController < ActionController::Base

  include RouteBuilding

  def index
  	params.require(%i[length_matrix address_array])
  rescue ActionController::ParameterMissing
    @result = nil
  else
    @result = build_route(params)
  end

  def create
    
  end

end
