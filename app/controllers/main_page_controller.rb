# frozen_string_literal: true

class MainPageController < ActionController::Base

  include RouteBuilding

  def index; end

  def create
    params.require(%i[length_matrix address_array])
  rescue ActionController::ParameterMissing
    render plain: 'Адрес не введен'
  else
    addresses = JSON.parse params[:address_array]
    @result = make_address_sequence(build_route(parse_length_matrix(params)), addresses)
    puts @result
  end

end
